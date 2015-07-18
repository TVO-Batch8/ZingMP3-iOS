//
//  SearchViewController.m
//  Music4You
//
//  Created by Peter Pike on 7/8/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()
@property (strong, nonatomic) PlayMusicViewController *playMusicVC;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"APIs: %@", [APIs getAPIsSearchsWithSearchKey:@"soledad" byCondition:@"1" onPage:@"1"]);
    self.arraySong = [NSMutableArray array];
    [self.tableSearch setHidden:YES];
    [self.tableSearch setBounces:NO];
    [self.indicator setTransform:CGAffineTransformMakeScale(3, 3)];
    
    //NSLog(@"APIs: %@", [APIs getAPIsCharts]);
    //NSLog(@"APIs: %@", [APIs getAPIsChartDetailWithChartID:@"IWZ9Z0BW"]);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar endEditing:NO];
    [self.navigationController.navigationBar setHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self.view endEditing:YES];
    [self.searchBar endEditing:YES];
    NSString *searchKey = searchBar.text;
    NSLog(@"%@", searchKey);
    [self.arraySong removeAllObjects];
    [self.indicator startAnimating];
    [self requestJsonDataWithSearchKey:searchKey];
    
    if (self.arraySong.count >= 1) {
        [self.tableSearch setHidden:NO];
        [self.lbNoData setHidden:YES];
    } else {
        [self.tableSearch setHidden:YES];
        [self.lbNoData setHidden:NO];
    }
}
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar endEditing:YES];
    [self.searchBar setText:nil];
    [self.tableSearch setHidden:YES];
    [self.lbNoData setHidden:NO];
    NSLog(@"Cancel search");
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[self.view endEditing:YES];
    UITouch *touch = [[event allTouches] anyObject];
    if ([self.searchBar isFirstResponder] && [touch view] != self.searchBar)
    {
        //[self.searchBar resignFirstResponder];
        [self.searchBar endEditing:NO];
    } else {
        [self.searchBar endEditing:NO];
    }
    [super touchesBegan:touches withEvent:event];
}

// Handle function to request image from api with search key
- (void) requestJsonDataWithSearchKey:(NSString *)searchKey {
    [self.tableSearch setHidden:YES];
    int pageInt = (int)self.arraySong.count/10;
    NSString *page = [NSString stringWithFormat:@"%d", pageInt + 1];
    NSLog(@"String page: %@", page);
    
    NSString *condition = [NSString stringWithFormat:@"%d", (int)self.segment.selectedSegmentIndex + 1];
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIs getAPIsSearchsWithSearchKey:searchKey byCondition:condition onPage:page]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    
    [connection start];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedData = [NSMutableData data];
    self.urlResponse = response;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.downloadedData) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.downloadedData options:kNilOptions error:nil];
        [self parseJson:json];
        if (self.arraySong.count == 0) {
            [self.indicator stopAnimating];
            [self.lbNoData setHidden:NO];
            [self.tableSearch setHidden:YES];
            NSLog(@"No data founded");
            [connection cancel];
            return;
        }
        if (self.arraySong.count >= 95) {
            // update UI
            [self.indicator stopAnimating];
            [self.lbNoData setHidden:YES];
            [self.tableSearch reloadData];
            [self.searchBar endEditing:NO];
            [self.tableSearch setHidden:NO];
            [connection cancel];
            return;
        }
        
        // recall searching request
        NSString *searchKey = self.searchBar.text;
        [self requestJsonDataWithSearchKey:searchKey];
    } else {
        NSLog(@"No data");
    }
}

- (void) parseJson:(NSDictionary *)json {
    NSLog(@"\n***** start parseJson **********");
    int resultCount = (int)[json valueForKey:@"ResultCount"];
    if (resultCount == 0) {
        NSLog(@"No data");
        [self.tableSearch setHidden:YES];
        [self.lbNoData setHidden:NO];
        return;
    }
    [self.tableSearch setHidden:NO];
    NSArray *data = [json valueForKey:@"Data"];
    for (int i = 0; i < data.count; i++) {
        NSString *iD = [[data objectAtIndex:i] valueForKey:@"ID"];
        NSString *title = [[data objectAtIndex:i] valueForKey:@"Title"];
        NSString *artist = [[data objectAtIndex:i] valueForKey:@"Artist"];
        
        
        NSArray *artistDetail = [[data objectAtIndex:i] valueForKey:@"ArtistDetail"];
        NSString *artistAvatar = [[data objectAtIndex:i] valueForKey:@"ArtistAvatar"];
        if (artistDetail) {
            NSDictionary *artistDic = [artistDetail lastObject];
            if ([artistDic isKindOfClass:[NSDictionary class]]) {
                artistAvatar = [artistDic valueForKey:@"ArtistAvatar"];
                if ([artistAvatar isKindOfClass:[NSString class]]) {
                    if ([artistAvatar containsString:@"94_94"]) {
                        artistAvatar = [artistAvatar stringByReplacingOccurrencesOfString:@"94_94" withString:@"165_165"];
                    }
                }
            }
        }
        
        NSString *composer = [[data objectAtIndex:i] valueForKey:@"Composer"];
        
        
        
        NSString *linkPlay = [[data objectAtIndex:i] valueForKey:@"LinkPlay128"];
        
        NSArray *array = [NSArray arrayWithObjects:iD, title, artist, artistAvatar, composer, linkPlay, nil];
        [self.arraySong addObject:array];
    }
    NSLog(@"***** end parseJson **********\n\n");
}

#pragma mark - UITableView Datasource
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraySong.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCellID];
    }
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, [[self.arraySong objectAtIndex:indexPath.row] objectAtIndex:1]]];
    [cell.detailTextLabel setText:[[self.arraySong objectAtIndex:indexPath.row] objectAtIndex:2]];
    [cell.imageView setImage:[UIImage imageNamed:@"loading.png"]];
    
    NSURL *urlAvatar = [NSURL URLWithString:[[self.arraySong objectAtIndex:(int)indexPath.row] objectAtIndex:3]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSData *dataAvatar = [NSData dataWithContentsOfURL:urlAvatar];
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImage *avatar = [UIImage imageWithData:dataAvatar];
                [cell.imageView setImage:avatar];
            });
        });
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueSearch" sender:self];
}

// prepare data for playMusicVC
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int selectedIndex = (int)self.tableSearch.indexPathForSelectedRow.row;
    if ([segue.identifier isEqualToString:@"segueSearch"]) {
        
        self.playMusicVC = (PlayMusicViewController *)segue.destinationViewController;
        
        
        self.playMusicVC.isPlayingSongSelected = NO;
        
        //self.playMusicVC.arraySong = [NSMutableArray array];
        self.playMusicVC.arraySong = self.arraySong;
        self.playMusicVC.currentIndex = selectedIndex;
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar endEditing:YES];
}

// action call search when segmentChanged
- (IBAction)segmentChanged:(id)sender {
    if ([sender isEqual:self.segment] && ![self.searchBar.text isEqualToString:@""]) {
        [self searchBarSearchButtonClicked:self.searchBar];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

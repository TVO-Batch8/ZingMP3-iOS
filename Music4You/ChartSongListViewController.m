//
//  ChartSongListViewController.m
//  Music4You
//
//  Created by Peter Pike on 7/18/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "ChartSongListViewController.h"

@interface ChartSongListViewController ()
@property (strong, nonatomic) PlayMusicViewController *playMusicVC;
@property (weak, nonatomic) IBOutlet UILabel *lbNoData;
@end

@implementation ChartSongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playMusicVC = ((AppDelegate *)([UIApplication sharedApplication].delegate)).playVC;
    [self.indicator setTransform:CGAffineTransformMakeScale(3, 3)];
    [self.indicator startAnimating];
    [self.tableSong setHidden:YES];
    self.arraySong = [NSMutableArray array];
    [self requestJsonDataWithChartID:self.chartID];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:self.chartName];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Handle function to request image from api with chart id
- (void) requestJsonDataWithChartID:(NSString *)chartID {
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIs getAPIsChartDetailWithChartID:self.chartID]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
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
        NSArray *json = [NSJSONSerialization JSONObjectWithData:self.downloadedData options:kNilOptions error:nil];
        [self parseJson:json];
        if (self.arraySong.count == 0) {
            [self.indicator stopAnimating];
            [self.tableSong setHidden:YES];
            [self.lbNoData setHidden:NO];
            NSLog(@"No data founded");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Can't load data! Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
            [alertView show];
            [connection cancel];
            return;
        }
        if (self.arraySong.count >= 35) {
            // update UI
            [self.indicator stopAnimating];
            [self.tableSong reloadData];
            [self.tableSong setHidden:NO];
            [self.lbNoData setHidden:YES];
            [connection cancel];
            return;
        }
        
        // recall searching request
        [self requestJsonDataWithChartID:self.chartID];
    } else {
        NSLog(@"No data");
    }
}

- (void) parseJson:(NSArray *)json {
    NSLog(@"\n***** start parseJson **********");
    
    
    
    for (int i = 0; i < json.count; i++) {
        NSString *iD = [[json objectAtIndex:i] valueForKey:@"ID"];
        NSString *title = [[json objectAtIndex:i] valueForKey:@"Title"];
        NSString *artist = [[json objectAtIndex:i] valueForKey:@"Artist"];
        
        
        NSArray *artistDetail = [[json objectAtIndex:i] valueForKey:@"ArtistDetail"];
        NSString *artistAvatar = [[json objectAtIndex:i] valueForKey:@"ArtistAvatar"];
        
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
        
        NSString *composer = [[json objectAtIndex:i] valueForKey:@"Composer"];
        NSString *linkPlay = [[json objectAtIndex:i] valueForKey:@"LinkPlay128"];
        NSArray *array = [NSArray arrayWithObjects:iD, title, artist, artistAvatar, composer, linkPlay, nil];
        [self.arraySong addObject:array];
    }
    NSLog(@"***** end parseJson **********\n\n");
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraySong.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chartSongCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:chartSongCellID];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%ld. %@", (long)indexPath.row + 1, [[self.arraySong objectAtIndex:indexPath.row] objectAtIndex:1]]];
    [cell.detailTextLabel setText:[[self.arraySong objectAtIndex:indexPath.row] objectAtIndex:2]];
    [cell.imageView setImage:[UIImage imageNamed:@"loading.png"]];
    
    NSURL *urlAvatar = [NSURL URLWithString:[[self.arraySong objectAtIndex:(int)indexPath.row] objectAtIndex:3]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSData *dataAvatar = [NSData dataWithContentsOfURL:urlAvatar];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *avatar = [UIImage imageWithData:dataAvatar];
            if (avatar) {
                [cell.imageView setImage:avatar];
            }
        });
    });
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isConnected]) {
        [self performSegueWithIdentifier:@"segueChartPlay" sender:self];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int selectedIndex = (int)self.tableSong.indexPathForSelectedRow.row;
    
    if ([segue.destinationViewController isKindOfClass:[PlayMusicViewController class]]) {
        self.playMusicVC = (PlayMusicViewController *)segue.destinationViewController;
        
        
        self.playMusicVC.isPlayingSongSelected = NO;
        
        self.playMusicVC.arraySong = self.arraySong;
        self.playMusicVC.currentIndex = selectedIndex;
    }
    
//    if ([segue.identifier isEqualToString:@"segueChartPlay"]) {
//        self.playMusicVC = (PlayMusicViewController *)segue.destinationViewController;
//        
//        
//        self.playMusicVC.isPlayingSongSelected = NO;
//        
//        self.playMusicVC.arraySong = self.arraySong;
//        self.playMusicVC.currentIndex = selectedIndex;
//    }
}

- (BOOL) isConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

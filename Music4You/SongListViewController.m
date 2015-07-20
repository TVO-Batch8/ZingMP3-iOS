//
//  SongListViewController.m
//  Music4You
//
//  Created by Peter Pike on 7/16/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "SongListViewController.h"

@interface SongListViewController ()
@property (strong, nonatomic) PlayMusicViewController *playMusicVC;
@property (weak, nonatomic) IBOutlet UILabel *lbNoData;
@end

@implementation SongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.arraySong = [NSMutableArray array];
    [self.indicator setTransform:CGAffineTransformMakeScale(3, 3)];
    [self requestJsonDataWithSubGenreID:self.stringSubGenreID];
    [self.tableSong reloadData];
    [self.tableSong setHidden:YES];
    [self.indicator startAnimating];
    NSLog(@"APIs: %@", [APIs getAPIsSubGenreDetailWithID:self.stringSubGenreID onPage:@"10"]);
    NSLog(@"songListVC did load");
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationItem setTitle:self.stringSubGenreName];
    NSLog(@"songListVC will appear");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}

// Handle function to request image from api with sub genre key
- (void) requestJsonDataWithSubGenreID:(NSString *)subGenreID {
    
    int pageInt = (int)self.arraySong.count/10;
    NSString *page = [NSString stringWithFormat:@"%d", pageInt + 1];
    NSLog(@"String page: %@", page);
    
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIs getAPIsSubGenreDetailWithID:subGenreID onPage:page]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
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
            [self.tableSong setHidden:YES];
            [self.lbNoData setHidden:NO];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Can't load data! Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
            [alertView show];
            NSLog(@"No data founded");
            [connection cancel];
            return;
        }
        if (self.arraySong.count >= 95) {
            // update UI
            [self.indicator stopAnimating];
            [self.tableSong reloadData];
            [self.tableSong setHidden:NO];
            [self.lbNoData setHidden:YES];
            [connection cancel];
            return;
        }
        
        // recall searching request
        [self requestJsonDataWithSubGenreID:self.stringSubGenreID];
    } else {
        NSLog(@"No data");
    }
}

- (void) parseJson:(NSDictionary *)json {
    NSLog(@"\n***** start parseJson **********");
    int resultCount = (int)[json valueForKey:@"ResultCount"];
    if (resultCount == 0) {
        NSLog(@"No data");
        return;
    }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraySong.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:songCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:songCellID];
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
    [self performSegueWithIdentifier:@"segueGenrePlay" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int selectedIndex = (int)self.tableSong.indexPathForSelectedRow.row;
    if ([segue.identifier isEqualToString:@"segueGenrePlay"]) {
        self.playMusicVC = (PlayMusicViewController *)segue.destinationViewController;
        
        
        self.playMusicVC.isPlayingSongSelected = NO;
        
        self.playMusicVC.arraySong = self.arraySong;
        self.playMusicVC.currentIndex = selectedIndex;
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

//
//  ChartSongListViewController.m
//  Music4You
//
//  Created by Peter Pike on 7/18/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "ChartSongListViewController.h"

@interface ChartSongListViewController ()

@end

@implementation ChartSongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.indicator setTransform:CGAffineTransformMakeScale(3, 3)];
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
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.downloadedData options:kNilOptions error:nil];
        [self parseJson:json];
        if (self.arraySong.count == 0) {
            [self.indicator stopAnimating];
            [self.tableSong setHidden:YES];
            NSLog(@"No data founded");
            [connection cancel];
            return;
        }
        if (self.arraySong.count >= 95) {
            // update UI
            [self.indicator stopAnimating];
            [self.tableSong reloadData];
            [self.tableSong setHidden:NO];
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
#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arraySong.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chartSongCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartSongCellID];
    }
    
    return cell;
}

#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"segueChartPlay" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int selectedIndex = (int)self.tableSong.indexPathForSelectedRow.row;
    if ([segue.identifier isEqualToString:@"segueChartPlay"]) {
        PlayMusicViewController *playMusicVC = (PlayMusicViewController *)segue.destinationViewController;
        
    }
}/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

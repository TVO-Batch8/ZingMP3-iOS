//
//  ChartsViewController.m
//  Music4You
//
//  Created by abtranbn on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "ChartsViewController.h"

@interface ChartsViewController () {
    NSString *id0, *id1, *id2;
}
@property (strong, nonatomic) CoreDataHelper *coreDataHelper;
@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.tableChart registerNib:[UINib nibWithNibName:@"ChartTableViewCell" bundle:nil] forCellReuseIdentifier:chartCellID];
    
    self.coreDataHelper = [[CoreDataHelper alloc] init];
    self.managedObjectContext = [self managedObjectContext];
    self.coreDataHelper.context = self.managedObjectContext;
    
    [self.indicator setTransform:CGAffineTransformMakeScale(3, 3)];
    self.arrayAvatar = [NSMutableArray array];
    self.arrayChart = [NSMutableArray arrayWithArray:[self.coreDataHelper fetchAllChart]];
    [self.navigationItem setTitle:@"Chart"];
    NSLog(@"Chart APIs: %@", [APIs getAPIsChartDetailWithChartID:@"IWZ9Z08I"]);
    
    id0 = [[self.arrayChart objectAtIndex:0] chartID];
    id1 = [[self.arrayChart objectAtIndex:1] chartID];
    id2 = [[self.arrayChart objectAtIndex:2] chartID];
    
    [self requestJsonDataWithChartID:id0];
    [self requestJsonDataWithChartID:id1];
    [self requestJsonDataWithChartID:id2];
    
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

// Handle function to request image from api with chart id
- (void) requestJsonDataWithChartID:(NSString *)chartID {
    
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[APIs getAPIsChartDetailWithChartID:chartID]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
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
        if (self.arrayAvatar.count == 0) {
            [self.indicator stopAnimating];
            [self.tableChart setHidden:YES];
            [self.lbNoData setHidden:NO];
            NSLog(@"No data founded");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Can't load data! Check your internet connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
            [alertView show];
            [connection cancel];
            return;
        }
        
        // update UI
        [self.indicator stopAnimating];
        [self.tableChart reloadData];
        [self.tableChart setHidden:NO];
        [self.lbNoData setHidden:YES];
        [connection cancel];
    } else {
        NSLog(@"No data");
    }
}

- (void) parseJson:(NSArray *)json {
    NSLog(@"\n***** start parseJson **********");
    
    
    
    for (int i = 0; i < 3; i++) {
        
        
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
        if (artistAvatar) {
            [self.arrayAvatar addObject:artistAvatar];
        }
        
    }
    NSLog(@"***** end parseJson **********\n\n");
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayChart.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[self.arrayChart objectAtIndex:section] chartName];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chartCellID];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartCellID];
//    }
//    Chart *chart = [self.arrayChart objectAtIndex:indexPath.row];
//    [cell.textLabel setText:chart.chartName];
//    
//    if ([chart.chartName isEqualToString:@"VIỆT NAM"]) {
//        [cell.imageView setImage:[UIImage imageNamed:@"vietnam.png"]];
//    } else if([chart.chartName isEqualToString:@"ÂU MỸ"]) {
//        [cell.imageView setImage:[UIImage imageNamed:@"america.png"]];
//    } else {
//        [cell.imageView setImage:[UIImage imageNamed:@"korea.png"]];
//    }
    
    ChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chartCellID];
    Chart *chart = [self.arrayChart objectAtIndex:indexPath.section];
    if (self.arrayAvatar.count > 8) {
        if ([chart.chartName isEqualToString:@"VIỆT NAM"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSURL *url0 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:0]];
                NSData *data0 = [NSData dataWithContentsOfURL:url0];
                NSURL *url1 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:1]];
                NSData *data1 = [NSData dataWithContentsOfURL:url1];
                NSURL *url2 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:2]];
                NSData *data2 = [NSData dataWithContentsOfURL:url2];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.iV1 setImage:[UIImage imageWithData:data0]];
                    [cell.iV2 setImage:[UIImage imageWithData:data1]];
                    [cell.iV3 setImage:[UIImage imageWithData:data2]];
                });
                
            });
            
            
            
        } else if([chart.chartName isEqualToString:@"ÂU MỸ"]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSURL *url0 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:3]];
                NSData *data0 = [NSData dataWithContentsOfURL:url0];
                NSURL *url1 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:4]];
                NSData *data1 = [NSData dataWithContentsOfURL:url1];
                NSURL *url2 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:5]];
                NSData *data2 = [NSData dataWithContentsOfURL:url2];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.iV1 setImage:[UIImage imageWithData:data0]];
                    [cell.iV2 setImage:[UIImage imageWithData:data1]];
                    [cell.iV3 setImage:[UIImage imageWithData:data2]];
                });
                
            });
            
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSURL *url0 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:6]];
                NSData *data0 = [NSData dataWithContentsOfURL:url0];
                NSURL *url1 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:7]];
                NSData *data1 = [NSData dataWithContentsOfURL:url1];
                NSURL *url2 = [NSURL URLWithString:[self.arrayAvatar objectAtIndex:8]];
                NSData *data2 = [NSData dataWithContentsOfURL:url2];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [cell.iV1 setImage:[UIImage imageWithData:data0]];
                    [cell.iV2 setImage:[UIImage imageWithData:data1]];
                    [cell.iV3 setImage:[UIImage imageWithData:data2]];
                });
                
            });
            
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        [cell setBackgroundColor:[UIColor yellowColor]];
    } else {
        [cell setBackgroundColor:[UIColor whiteColor]];
    }
}


#pragma mark - UITableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self isConnected]) {
        [self performSegueWithIdentifier:@"segueChart" sender:self];
    } else {
        UIAlertView *alertNotConnected = [[UIAlertView alloc] initWithTitle:nil message:@"Check your internet connection" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Settings", nil];
        [alertNotConnected show];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    int selectedIndex = (int)self.tableChart.indexPathForSelectedRow.row;
    if ([segue.identifier isEqualToString:@"segueChart"]) {
        ChartSongListViewController *chartSongListVC = (ChartSongListViewController *)segue.destinationViewController;
        Chart *chart = [self.arrayChart objectAtIndex:selectedIndex];
        chartSongListVC.chartID = chart.chartID;
        chartSongListVC.chartName = chart.chartName;
        [chartSongListVC.arraySong removeAllObjects];
    }
}

- (BOOL) isConnected {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString: UIApplicationOpenSettingsURLString]];
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

//
//  ChartsViewController.m
//  Music4You
//
//  Created by abtranbn on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "ChartsViewController.h"

@interface ChartsViewController ()
@property (strong, nonatomic) CoreDataHelper *coreDataHelper;
@end

@implementation ChartsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.coreDataHelper = [[CoreDataHelper alloc] init];
    self.managedObjectContext = [self managedObjectContext];
    self.coreDataHelper.context = self.managedObjectContext;
    
    self.arrayChart = [NSMutableArray arrayWithArray:[self.coreDataHelper fetchAllChart]];
    [self.navigationItem setTitle:@"Chart"];
    NSLog(@"Chart APIs: %@", [APIs getAPIsChartDetailWithChartID:@"IWZ9Z08I"]);
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayChart.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:chartCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chartCellID];
    }
    Chart *chart = [self.arrayChart objectAtIndex:indexPath.row];
    [cell.textLabel setText:chart.chartName];
    
    if ([chart.chartName isEqualToString:@"VIỆT NAM"]) {
        [cell.imageView setImage:[UIImage imageNamed:@"vietnam.png"]];
    } else if([chart.chartName isEqualToString:@"ÂU MỸ"]) {
        [cell.imageView setImage:[UIImage imageNamed:@"america.png"]];
    } else {
        [cell.imageView setImage:[UIImage imageNamed:@"korea.png"]];
    }
    return cell;
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

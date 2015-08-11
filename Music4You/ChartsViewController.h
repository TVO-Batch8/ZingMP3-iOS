//
//  ChartsViewController.h
//  Music4You
//
//  Created by abtranbn on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"
#import "ChartTableViewCell.h"
#import "ChartSongListViewController.h"
#define chartCellID @"chartCellID"

@interface ChartsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (weak, nonatomic) IBOutlet UILabel *lbNoData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UITableView *tableChart;
@property (strong, nonatomic) NSMutableArray *arrayChart;

@property (strong, nonatomic) NSMutableData *downloadedData;
@property (strong, nonatomic) NSURLResponse *urlResponse;
@property (strong, nonatomic) NSMutableArray *arrayAvatar;
- (BOOL) isConnected;
@end

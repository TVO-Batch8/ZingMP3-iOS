//
//  ChartsViewController.h
//  Music4You
//
//  Created by abtranbn on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIs.h"
#import "CoreDataHelper.h"
#import "ChartSongListViewController.h"
#define chartCellID @"chartCellID"

@interface ChartsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (weak, nonatomic) IBOutlet UITableView *tableChart;
@property (strong, nonatomic) NSMutableArray *arrayChart;
@end

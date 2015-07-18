//
//  ChartSongListViewController.h
//  Music4You
//
//  Created by Peter Pike on 7/18/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIs.h"
#import "PlayMusicViewController.h"
#define chartSongCellID @"chartSongCellID"

@interface ChartSongListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableSong;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) NSMutableData *downloadedData;
@property (strong, nonatomic) NSURLResponse *urlResponse;

@property (strong, nonatomic) NSMutableArray *arraySong;
@property (strong, nonatomic) NSString *chartID;
@end

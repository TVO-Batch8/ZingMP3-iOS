//
//  SearchViewController.h
//  Music4You
//
//  Created by Peter Pike on 7/8/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIs.h"
#import "PlayMusicViewController.h"
#define searchCellID @"searchCellID"

@interface SearchViewController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UILabel *lbNoData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;


@property (weak, nonatomic) IBOutlet UITableView *tableSearch;

@property (strong, nonatomic) NSURLResponse *urlResponse;
@property (strong, nonatomic) NSMutableData *downloadedData;
@property (strong, nonatomic) NSMutableArray *arraySong;
- (BOOL) isConnected;
@end


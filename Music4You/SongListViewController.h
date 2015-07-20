//
//  SongListViewController.h
//  Music4You
//
//  Created by Peter Pike on 7/16/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIs.h"
#import "PlayMusicViewController.h"
#define songCellID @"songCellID"

@interface SongListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableSong;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) NSMutableArray *arraySong;
@property (strong, nonatomic) NSString *stringSubGenreID;
@property (strong, nonatomic) NSString *stringSubGenreName;

@property (strong, nonatomic) NSMutableData *downloadedData;
@property (strong, nonatomic) NSURLResponse *urlResponse;
@end

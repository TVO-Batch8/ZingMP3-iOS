//
//  GenreViewController.h
//  Music4You
//
//  Created by abtranbn on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIs.h"
#import "CoreDataHelper.h"

#define genreCellID @"genreCellID"

@interface GenreViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (weak, nonatomic) IBOutlet UITableView *tableGenre;
@property (strong, nonatomic) NSMutableArray *arrayGenres;
@property (strong, nonatomic) NSMutableArray *arraySubGenres;

- (BOOL) isConnected;
@end

//
//  FavouritesViewController.h
//  Music4You
//
//  Created by abtranbn on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIs.h"
#import "CoreDataHelper.h"
#import "PlayMusicViewController.h"
#define favouriteCellID @"favouriteCellID"

@interface FavouritesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (weak, nonatomic) IBOutlet UILabel *lbNoFavourite;

@property (weak, nonatomic) IBOutlet UITableView *tableFavourite;
@property (strong, nonatomic) NSMutableArray *arrayFavourites;

@property (strong, nonatomic) NSMutableArray *arraySong;
@end

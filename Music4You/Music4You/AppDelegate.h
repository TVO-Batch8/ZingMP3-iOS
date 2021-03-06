//
//  AppDelegate.h
//  Music4You
//
//  Created by Peter Pike on 7/8/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <AVFoundation/AVFoundation.h>
#import "CoreDataHelper.h"
#import "Reachability.h"
#import "SongListViewController.h"

@import CoreTelephony;


@interface AppDelegate : UIResponder <UIApplicationDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) id playVC;
@property  (strong, nonatomic) AVPlayer *song;
@property (strong, nonatomic) Reachability *reachability;
@end


//
//  PlayMusicViewController.h
//  Music4You
//
//  Created by Peter Pike on 7/14/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "CoreDataHelper.h"
#import "AppDelegate.h"
#import "AutoScrollLabel.h"
#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

@interface PlayMusicViewController : UIViewController<AVAudioPlayerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (strong, nonatomic) AVPlayer *song;
@property (strong, nonatomic) NSMutableArray *arraySong;
@property (nonatomic) int currentIndex;
@property (nonatomic) BOOL isPlayingSongSelected;

@end

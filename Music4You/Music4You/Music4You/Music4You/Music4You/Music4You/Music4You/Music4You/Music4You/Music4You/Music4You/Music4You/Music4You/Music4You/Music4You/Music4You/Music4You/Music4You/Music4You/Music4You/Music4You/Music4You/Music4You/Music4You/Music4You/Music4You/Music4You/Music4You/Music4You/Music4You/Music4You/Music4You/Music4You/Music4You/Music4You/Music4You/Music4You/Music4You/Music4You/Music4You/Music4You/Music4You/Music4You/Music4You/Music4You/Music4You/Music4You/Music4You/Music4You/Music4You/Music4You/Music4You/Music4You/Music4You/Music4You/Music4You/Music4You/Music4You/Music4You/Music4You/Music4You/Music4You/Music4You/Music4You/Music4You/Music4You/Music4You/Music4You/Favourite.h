//
//  Favourite.h
//  Music4You
//
//  Created by Peter Pike on 7/16/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Favourite : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * artistAvatar;
@property (nonatomic, retain) NSString * composer;
@property (nonatomic, retain) NSString * linkPlay128;
@property (nonatomic, retain) NSString * songID;
@property (nonatomic, retain) NSString * songTitle;
- (id) initWithSongID:(NSString *) songID title:(NSString *)songTitle artist:(NSString *)artist artistAvatar:(NSString *)artistAvatar composer:(NSString *)composer linkPlay128:(NSString *) linkPlay128 managedObjectContext:(NSManagedObjectContext *)context;
@end

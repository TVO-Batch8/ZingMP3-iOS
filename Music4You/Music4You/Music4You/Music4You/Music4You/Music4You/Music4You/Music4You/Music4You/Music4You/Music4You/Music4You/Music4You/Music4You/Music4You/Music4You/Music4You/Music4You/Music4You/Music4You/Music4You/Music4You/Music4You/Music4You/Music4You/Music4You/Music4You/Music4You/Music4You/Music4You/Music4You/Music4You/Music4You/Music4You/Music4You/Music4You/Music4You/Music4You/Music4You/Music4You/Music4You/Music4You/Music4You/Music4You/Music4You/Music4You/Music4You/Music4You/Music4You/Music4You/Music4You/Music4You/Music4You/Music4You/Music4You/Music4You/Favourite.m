//
//  Favourite.m
//  Music4You
//
//  Created by Peter Pike on 7/16/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "Favourite.h"


@implementation Favourite

@dynamic artist;
@dynamic artistAvatar;
@dynamic composer;
@dynamic linkPlay128;
@dynamic songID;
@dynamic songTitle;

// init function of Favourite implement
- (id) initWithSongID:(NSString *) songID title:(NSString *)songTitle artist:(NSString *)artist artistAvatar:(NSString *)artistAvatar composer:(NSString *)composer linkPlay128:(NSString *) linkPlay128 managedObjectContext:(NSManagedObjectContext *)context{
    Favourite *favourite = [NSEntityDescription insertNewObjectForEntityForName:@"Favourite" inManagedObjectContext:context];
    favourite.songID = songID;
    favourite.songTitle = songTitle;
    favourite.artist = artist;
    favourite.artistAvatar = artistAvatar;
    favourite.composer = composer;
    favourite.linkPlay128 = linkPlay128;
    return favourite;
}
@end

//
//  SubGenre.m
//  Music4You
//
//  Created by Peter Pike on 7/13/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "SubGenre.h"


@implementation SubGenre

@dynamic genreID;
@dynamic subGenreID;
@dynamic subGenreName;
@dynamic subToGenre;

// init function of SubGenre implement
- (id) initWithSubGenreID:(NSString *)subGenreID genreID:(NSString *)genreID subGenreName:(NSString *) subGenreName managedObjectContext:(NSManagedObjectContext *)context {
    SubGenre *subGenre = [NSEntityDescription insertNewObjectForEntityForName:@"SubGenre" inManagedObjectContext:context];
    subGenre.genreID = genreID;
    subGenre.subGenreID = subGenreID;
    subGenre.subGenreName = subGenreName;
    return subGenre;
}
@end

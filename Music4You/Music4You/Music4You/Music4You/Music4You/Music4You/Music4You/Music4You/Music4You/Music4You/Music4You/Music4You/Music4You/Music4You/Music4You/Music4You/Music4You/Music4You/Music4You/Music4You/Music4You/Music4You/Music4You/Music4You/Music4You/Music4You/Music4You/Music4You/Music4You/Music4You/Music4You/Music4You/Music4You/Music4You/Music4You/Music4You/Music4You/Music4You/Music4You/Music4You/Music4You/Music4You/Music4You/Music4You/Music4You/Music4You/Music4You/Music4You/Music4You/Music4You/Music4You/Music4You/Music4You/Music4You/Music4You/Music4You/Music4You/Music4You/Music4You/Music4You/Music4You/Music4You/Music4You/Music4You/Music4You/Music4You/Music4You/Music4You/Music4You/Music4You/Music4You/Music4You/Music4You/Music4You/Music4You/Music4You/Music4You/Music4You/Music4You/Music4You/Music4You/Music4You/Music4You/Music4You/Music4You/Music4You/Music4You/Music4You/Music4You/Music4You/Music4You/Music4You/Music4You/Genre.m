//
//  Genre.m
//  Music4You
//
//  Created by Peter Pike on 7/13/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "Genre.h"
#import "SubGenre.h"


@implementation Genre

@dynamic genreID;
@dynamic genreName;
@dynamic genreToSub;

// init function of Genre implement
- (id) initWithGenreID:(NSString *)genreID genreName:(NSString *)genreName managedObjectContext:(NSManagedObjectContext *)context {
    
    Genre *genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:context];
    
    genre.genreID = genreID;
    
    genre.genreName = genreName;
    
    return genre;
    
}
@end

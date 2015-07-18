//
//  SubGenre.h
//  Music4You
//
//  Created by Peter Pike on 7/13/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Genre;

@interface SubGenre : NSManagedObject

@property (nonatomic, retain) NSString * genreID;
@property (nonatomic, retain) NSString * subGenreID;
@property (nonatomic, retain) NSString * subGenreName;
@property (nonatomic, retain) Genre *subToGenre;

// init function of SubGenre
- (id) initWithSubGenreID:(NSString *)subGenreID genreID:(NSString *)genreID subGenreName:(NSString *) subGenreName managedObjectContext:(NSManagedObjectContext *)context;

@end

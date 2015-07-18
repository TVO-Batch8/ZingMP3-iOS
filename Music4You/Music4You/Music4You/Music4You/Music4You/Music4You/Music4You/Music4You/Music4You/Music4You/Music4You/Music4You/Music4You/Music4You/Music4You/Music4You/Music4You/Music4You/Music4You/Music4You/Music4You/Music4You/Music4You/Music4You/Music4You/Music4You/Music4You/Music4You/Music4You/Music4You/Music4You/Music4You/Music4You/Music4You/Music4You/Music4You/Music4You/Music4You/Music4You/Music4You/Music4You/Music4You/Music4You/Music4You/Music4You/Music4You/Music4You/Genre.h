//
//  Genre.h
//  Music4You
//
//  Created by Peter Pike on 7/13/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SubGenre;

@interface Genre : NSManagedObject

@property (nonatomic, retain) NSString * genreID;
@property (nonatomic, retain) NSString * genreName;
@property (nonatomic, retain) NSSet *genreToSub;

// init function of Genre
- (id) initWithGenreID:(NSString *)genreID genreName:(NSString *)genreName managedObjectContext:(NSManagedObjectContext *)context;
@end

@interface Genre (CoreDataGeneratedAccessors)

- (void)addGenreToSubObject:(SubGenre *)value;
- (void)removeGenreToSubObject:(SubGenre *)value;
- (void)addGenreToSub:(NSSet *)values;
- (void)removeGenreToSub:(NSSet *)values;

@end

//
//  CoreDataHelper.h
//  Music4You
//
//  Created by Peter Pike on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Favourite.h"
#import "Genre.h"
#import "SubGenre.h"
#import "Chart.h"

@interface CoreDataHelper : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

// fetch data from entities
- (NSArray *) fetchAllFavoutite;
- (NSArray *) fetchAllGenre;
- (NSArray *) fetchAllSubGenre;
- (NSArray *) fetchAllChart;

// delete data from entities
- (BOOL) deleteFavourite:(Favourite *)favourite;
- (BOOL) deleteGenre:(Genre *)genre;
- (BOOL) deleteSubGenre:(SubGenre *)subGenre;
- (BOOL) deleteChart:(Chart *)chart;

// query data from entities
- (NSArray *) queryFavouritesWithSong:(NSString *)songName;
- (Favourite *) queryFavouriteWithID:(NSString *)favouriteID;
- (Genre *) queryGenreWithName:(NSString *)genreName;
- (NSArray *) querySubGenresWithGenreID:(NSString *)genreID;
- (SubGenre *) querySubGenreWithName:(NSString *)subGenreName;
- (Chart *) queryChartWithName:(NSString *)chartName;

- (void) saveContext;
@end

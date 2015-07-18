//
//  CoreDataHelper.m
//  Music4You
//
//  Created by Peter Pike on 7/10/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "CoreDataHelper.h"

@implementation CoreDataHelper

// fetch data from Favourite
- (NSArray *) fetchAllFavoutite {
    NSManagedObjectContext *mOC = self.context;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Favourite" inManagedObjectContext:mOC];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [mOC executeFetchRequest:fetchRequest error:&error];
    return array;
}

// fetch data from Genre
- (NSArray *) fetchAllGenre {
    NSManagedObjectContext *mOC = self.context;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:mOC];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [mOC executeFetchRequest:fetchRequest error:&error];
    return array;
}

// fetch data from GenreDetail
- (NSArray *) fetchAllSubGenre {
    NSManagedObjectContext *mOC = self.context;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SubGenre" inManagedObjectContext:mOC];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [mOC executeFetchRequest:fetchRequest error:&error];
    return array;
}

// fetch data from Chart
- (NSArray *) fetchAllChart {
    NSManagedObjectContext *mOC = self.context;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Chart" inManagedObjectContext:mOC];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entityDescription];
    NSError *error = nil;
    NSArray *array = [mOC executeFetchRequest:fetchRequest error:&error];
    return array;
}


// delete favourite
- (BOOL) deleteFavourite:(Favourite *)favourite {
    [self.context deleteObject:favourite];
    return YES;
}

// delete genre
- (BOOL) deleteGenre:(Genre *)genre {
    [self.context deleteObject:genre];
    return YES;
}

// delete subGenre
- (BOOL) deleteSubGenre:(SubGenre *)subGenre {
    [self.context deleteObject:subGenre];
    return YES;
}

// delete chart
- (BOOL) deleteChart:(Chart *)chart {
    [self.context deleteObject:chart];
    return YES;
}

// query favourite(s) with songName
- (NSArray *) queryFavouritesWithSong:(NSString *)songName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Favourite" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"songName LIKE[c] %@", songName];
    [fetchRequest setPredicate:predicate];
    NSSortDescriptor *sortDescription = [[NSSortDescriptor alloc] initWithKey:@"songName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescription]];
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        return nil;
    }
    return array;
}

// query favourite with favouriteID
- (Favourite *) queryFavouriteWithID:(NSString *)favouriteID {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Favourite" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"songID LIKE[c] %@", favouriteID];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:fetchRequest error:&error];
    if (array.count == 0) {
        return nil;
    }
    return array[0];
}

// query genre with genreName
- (Genre *) queryGenreWithName:(NSString *)genreName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Genre" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"genreName LIKE[c] %@", genreName];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        return nil;
    }
    return array[0];
}

// query subGenres with subGenreID
- (NSArray *) querySubGenresWithGenreID:(NSString *)genreID {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SubGenre" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"genreID LIKE[c] %@", genreID];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        return nil;
    }
    return array;
}

// query subGenre with subGenreName
- (SubGenre *) querySubGenreWithName:(NSString *)subGenreName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"SubGenre" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"subGenreName LIKE[c] %@", subGenreName];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        return nil;
    }
    return array[0];
}

// query chart with chartName
- (Chart *) queryChartWithName:(NSString *)chartName {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Chart" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chartName LIKE[c] %@", chartName];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [self.context executeFetchRequest:fetchRequest error:&error];
    if (!array) {
        return nil;
    }
    return array[0];
}


- (void) saveContext {
    [self.context save:nil];
}
@end

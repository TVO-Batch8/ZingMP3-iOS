//
//  APIs.h
//  Music4You
//
//  Created by abtranbn on 7/9/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+SCEncoding.h"
#define PRIVATE_KEY @"c9c2a7f66b677012b763512da77040b3"
#define PUBLIC_KEY @"4c3d549977f7943bd9cc6d33f656bb5c1c87d2c0"

@interface APIs : NSObject

// get APIs search
+ (NSString *) getAPIsSearchsWithSearchKey:(NSString *) searchKey byCondition:(NSString *) condition onPage:(NSString *)page;

// get APIs song detail
+ (NSString *) getAPIsSongWithSongID:(NSString *) songID;

// get APIs category detail
+ (NSString *) getAPIsSubGenreDetailWithID:(NSString *)subGenreID onPage:(NSString *)page;

// get APIs charts
+ (NSString *) getAPIsCharts;

// get APIs chart detail
+ (NSString *) getAPIsChartDetailWithChartID:(NSString *) chartID;
@end

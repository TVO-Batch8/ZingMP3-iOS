//
//  APIs.m
//  Music4You
//
//  Created by abtranbn on 7/9/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "APIs.h"

@implementation APIs
// get APIs search implement
+ (NSString *) getAPIsSearchsWithSearchKey:(NSString *) searchKey byCondition:(NSString *) condition onPage:(NSString *)page {
    NSDictionary *jsonDicSearch = @{@"kw":searchKey, @"t":condition, @"p":page};
    NSString *dataStringSearchEncoded = [self getEncodedStringFromJSONDic:jsonDicSearch];
    NSString *signatureSearch = [dataStringSearchEncoded HMACWithSecret:PRIVATE_KEY];
    NSString *searchURLString = [NSString stringWithFormat:@"http://api.mp3.zing.vn/api/search?publicKey=%@&signature=%@&jsondata=%@", PUBLIC_KEY, signatureSearch, dataStringSearchEncoded];
    return searchURLString;
}

// get APIs song detail implement
+ (NSString *) getAPIsSongWithSongID:(NSString *) songID {
    NSDictionary *jsonDicSong = @{@"t":@"song", @"id":songID};
    NSString *dataStringSongEncoded = [self getEncodedStringFromJSONDic:jsonDicSong];
    NSString *signatureSong = [dataStringSongEncoded HMACWithSecret:PRIVATE_KEY];
    NSString *songURLString = [NSString stringWithFormat:@"http://api.mp3.zing.vn/api/detail?publicKey=%@&signature=%@&jsondata=%@", PUBLIC_KEY, signatureSong, dataStringSongEncoded];
    return songURLString;
}

// get APIs category detail implement
+ (NSString *) getAPIsSubGenreDetailWithID:(NSString *)subGenreID onPage:(NSString *)page {
    NSDictionary *jsonDicCatDetail = @{@"id":subGenreID, @"t":@"song", @"p":page};
    NSString *dataStringCatDetailEncoded = [self getEncodedStringFromJSONDic:jsonDicCatDetail];
    NSString *signatureCatDetail = [dataStringCatDetailEncoded HMACWithSecret:PRIVATE_KEY];
    NSString *catDetailURLString = [NSString stringWithFormat:@"http://api.mp3.zing.vn/api/genre-detail?publicKey=%@&signature=%@&jsondata=%@", PUBLIC_KEY, signatureCatDetail, dataStringCatDetailEncoded];
    return catDetailURLString;
}

// get APIs charts implement
+ (NSString *) getAPIsCharts {
    NSDictionary *jsonDicCharts = @{@"t": @"song"};
    NSString *dataStringChartsEncoded = [self getEncodedStringFromJSONDic:jsonDicCharts];
    NSString *signatureCharts = [dataStringChartsEncoded HMACWithSecret:PRIVATE_KEY];
    NSString *chartsURLString = [NSString stringWithFormat:@"http://api.mp3.zing.vn/api/list-chart?publicKey=%@&signature=%@&jsondata=%@", PUBLIC_KEY, signatureCharts, dataStringChartsEncoded];
    return chartsURLString;
}

// get APIs chart detail implement
+ (NSString *) getAPIsChartDetailWithChartID:(NSString *) chartID {
    NSDictionary *jsonDicChartDetail = @{@"id": chartID};
    NSString *dataStringChartDetailEncoded = [self getEncodedStringFromJSONDic:jsonDicChartDetail];
    NSString *signatureChartDetail = [dataStringChartDetailEncoded HMACWithSecret:PRIVATE_KEY];
    NSString *chartDetailURLString = [NSString stringWithFormat:@"http://api.mp3.zing.vn/api/chart-detail?publicKey=%@&signature=%@&jsondata=%@", PUBLIC_KEY, signatureChartDetail, dataStringChartDetailEncoded];
    return chartDetailURLString;
}

// get encoded string from JSON dictionary
+ (NSString *) getEncodedStringFromJSONDic:(NSDictionary *) dic {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
    NSString *jsonString;
    if (error) {
        NSLog(@"error: %@", error.description);
        return nil;
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"cat: %@", jsonString);
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *dataString = [data base64EncodedStringWithOptions:0];
    NSString *dataStringEncoded = [dataString urlEncode];
    return dataStringEncoded;
}
@end

//
//  ConnectionInterface.m
//  Music4You
//
//  Created by Peter Pike on 7/16/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import "ConnectionInterface.h"

@implementation ConnectionInterface
// Handle function to request image from api with search key
- (void) requestJsonDataWithKeyWord:(NSString *)keyWord byCondition:(id)condition byType:(NSString *)type {
    NSString *page = @"1";
    if (self.arraySong.count > 9) {
        page = @"2";
    }
    NSString *stringAPIs = @"";
    if ([type isEqualToString:@"searchType"]) {
        stringAPIs = [APIs getAPIsSearchsWithSearchKey:keyWord byCondition:condition onPage:page];
    } else if ([type isEqualToString:@"genreType"]){
        stringAPIs = [APIs getAPIsSubGenreDetailWithID:keyWord onPage:page];
    }
    NSLog(@"string APIs: %@", stringAPIs);
    NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:stringAPIs] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:theRequest delegate:self];
    
    self.keyWord = keyWord;
    self.condition = condition;
    self.type = type;
    
    [connection start];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    self.downloadedData = [NSMutableData data];
    self.arraySong = [NSMutableArray array];
    self.urlResponse = response;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.downloadedData appendData:data];
    NSLog(@"Received data");
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.downloadedData) {
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.downloadedData options:kNilOptions error:nil];
        [self parseJson:json];
        if (self.arraySong.count == 0) {
            
            NSLog(@"No data founded");
            [connection cancel];
            return;
        }
        if (self.arraySong.count >= 15) {
            // update UI
            
            [connection cancel];
            return;
        }
        
        // recall request
        
        [self requestJsonDataWithKeyWord:self.keyWord byCondition:self.condition byType:self.type];
    } else {
        NSLog(@"No data");
    }
}

- (void) parseJson:(NSDictionary *)json {
    NSLog(@"\n***** start parseJson **********");
    int resultCount = (int)[json valueForKey:@"ResultCount"];
    if (resultCount == 0) {
        NSLog(@"No data counted");
        
        return;
    }
    
    NSArray *data = [json valueForKey:@"Data"];
    for (int i = 0; i < data.count; i++) {
        NSString *iD = [[data objectAtIndex:i] valueForKey:@"ID"];
        NSString *title = [[data objectAtIndex:i] valueForKey:@"Title"];
        NSString *artist = [[data objectAtIndex:i] valueForKey:@"Artist"];
        NSString *artistAvatar = [[data objectAtIndex:i] valueForKey:@"ArtistAvatar"];
        NSString *composer = [[data objectAtIndex:i] valueForKey:@"Composer"];
        NSString *linkPlay = [[data objectAtIndex:i] valueForKey:@"LinkPlay128"];
        NSArray *array = [NSArray arrayWithObjects:iD, title, artist, artistAvatar, composer, linkPlay, nil];
        [self.arraySong addObject:array];
    }
    NSLog(@"***** end parseJson **********\n\n");
}

- (NSArray *) getResultArray {
    [self requestJsonDataWithKeyWord:self.keyWord byCondition:self.condition byType:self.type];
    if (self.arraySong.count != 0) {
        NSLog(@"Have data");
        return self.arraySong;
    }
    NSLog(@"Have no data");
    return nil;
}
@end

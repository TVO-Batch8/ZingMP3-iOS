//
//  ConnectionInterface.h
//  Music4You
//
//  Created by Peter Pike on 7/16/15.
//  Copyright (c) 2015 Peter Pike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIs.h"

@interface ConnectionInterface : NSObject<NSURLConnectionDataDelegate, NSURLConnectionDelegate>

@property (strong, nonatomic) NSString *keyWord;
@property (strong, nonatomic) id condition;
@property (strong, nonatomic) NSString *type;

@property (strong, nonatomic) NSURLResponse *urlResponse;
@property (strong, nonatomic) NSMutableData *downloadedData;
@property (strong, nonatomic) NSMutableArray *arraySong;

- (NSArray *) getResultArray;
@end

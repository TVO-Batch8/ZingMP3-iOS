//
//  NSString+SCEncoding.h
//  MP3Demo
//
//  Created by abtranbn on 7/6/15.
//  Copyright (c) 2015 duymy. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

@interface NSString (SCEncoding)
- (NSString *)urlEncodeUsingEncoding:(CFStringEncoding)encoding;
- (NSString *)urlEncode;
- (NSString*) HMACWithSecret:(NSString*) secret;
@end

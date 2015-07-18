//
//  NSString+SCEncoding.m
//  MP3Demo
//
//  Created by abtranbn on 7/6/15.
//  Copyright (c) 2015 duymy. All rights reserved.
//

#import "NSString+SCEncoding.h"

@implementation NSString (SCEncoding)
- (NSString *)urlEncodeUsingEncoding:(CFStringEncoding)encoding {
    
    return CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]"), encoding));
}

- (NSString *)urlEncode {
    return [self urlEncodeUsingEncoding:kCFStringEncodingUTF8];
}

- (NSString*) HMACWithSecret:(NSString*) secret
{
    CCHmacContext    ctx;
    const char       *key = [secret UTF8String];
    const char       *str = [self UTF8String];
    unsigned char    mac[CC_MD5_DIGEST_LENGTH];
    char             hexmac[2 * CC_MD5_DIGEST_LENGTH + 1];
    char             *p;
    
    CCHmacInit( &ctx, kCCHmacAlgMD5, key, strlen( key ));
    CCHmacUpdate( &ctx, str, strlen(str) );
    CCHmacFinal( &ctx, mac );
    
    p = hexmac;
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++ ) {
        snprintf( p, 3, "%02x", mac[ i ] );
        p += 2;
    }
    
    return [NSString stringWithUTF8String:hexmac];
}

@end

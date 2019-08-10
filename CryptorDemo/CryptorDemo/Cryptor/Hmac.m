//
//  HMAC.m
//  CryptorDemo
//
//  Created by YZF on 2018/11/5.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import "Hmac.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation Hmac

+ (NSString *)hmac:(NSString *)string key:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [string cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *hmacData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[hmacData bytes];
    NSMutableString *hmacResult = [NSMutableString stringWithCapacity:hmacData.length * 2];
    for (int i = 0; i < hmacData.length; ++i){
        [hmacResult appendFormat:@"%02x", buffer[i]];
    }
    return hmacResult;
}

+ (NSString *)hmac_sha256:(NSString *)string {
    const char *s = [string cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    NSString *hash = [out description];
    hash = [hash stringByReplacingOccurrencesOfString:@" " withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@"<" withString:@""];
    hash = [hash stringByReplacingOccurrencesOfString:@">" withString:@""];
    return hash;
}

@end

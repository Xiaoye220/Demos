//
//  MD5.m
//  CryptorDemo
//
//  Created by YZF on 2018/10/25.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation MD5

//对字符串数据进行MD5的签名
+ (NSString *)md5:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return  result;
}

@end

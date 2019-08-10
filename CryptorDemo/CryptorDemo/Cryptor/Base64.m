//
//  Base64.m
//  CryptorDemo
//
//  Created by YZF on 2018/10/25.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import "Base64.h"

@implementation Base64

+ (NSString *)encode:(NSData *)data {
    //判断是否传入需要加密数据参数
    if ((data == nil) || (data == NULL)) {
        return nil;
    } else if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    //使用系统的API进行Base64加密操作
    NSDataBase64EncodingOptions options;
    options = NSDataBase64EncodingEndLineWithLineFeed;
    return [data base64EncodedStringWithOptions:options];
}

+ (NSData *)decode:(NSString *)string {
    //判断是否传入需要加密数据参数
    if ((string == nil) || (string == NULL)) {
        return nil;
    } else if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    //使用系统的API进行Base64解密操作
    NSDataBase64DecodingOptions options;
    options = NSDataBase64DecodingIgnoreUnknownCharacters;
    return [[NSData alloc] initWithBase64EncodedString:string options:options];
}

@end

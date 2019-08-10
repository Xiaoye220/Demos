//
//  AES.h
//  CryptorDemo
//
//  Created by YZF on 2018/10/25.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AES : NSObject

/**
 AES 加密
 根据 key 的长度，自动使用 AES-128，AES-192，AES-256 算法
 iv 为空使用 ECB 模式，不为空使用 CBC 模式

 @param data 要加密数据
 @param key 秘钥
 @param iv 偏移量
 @return 加密后数据
 */
+ (NSData *)encrypt:(NSData *)data key:(NSString *)key iv:(nullable NSString *)iv;

+ (NSData *)decrypt:(NSData *)data key:(NSString *)key iv:(nullable NSString *)iv;

@end

NS_ASSUME_NONNULL_END

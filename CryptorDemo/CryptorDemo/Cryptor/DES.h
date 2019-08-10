//
//  DES.h
//  CryptorDemo
//
//  Created by YZF on 2018/11/2.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DES : NSObject

+ (NSData *)encrypt:(NSData *)data key:(NSString *)key iv:(nullable NSString *)iv;

+ (NSData *)decrypt:(NSData *)data key:(NSString *)key iv:(nullable NSString *)iv;

@end

NS_ASSUME_NONNULL_END

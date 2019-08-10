//
//  HMAC.h
//  CryptorDemo
//
//  Created by YZF on 2018/11/5.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Hmac : NSObject

+ (NSString *)hmac:(NSString *)string key:(NSString *)key;

+ (NSString *)hmac_sha256:(NSString *)string;

@end

NS_ASSUME_NONNULL_END

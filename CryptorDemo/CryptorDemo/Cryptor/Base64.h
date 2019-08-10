//
//  Base64.h
//  CryptorDemo
//
//  Created by YZF on 2018/10/25.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Base64 : NSObject

+ (NSString *)encode:(NSData *)data;

+ (NSData *)decode:(NSString *)string;

@end

NS_ASSUME_NONNULL_END

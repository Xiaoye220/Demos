//
//  DES.m
//  CryptorDemo
//
//  Created by YZF on 2018/11/2.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import "DES.h"
#import <CommonCrypto/CommonCrypto.h>

@implementation DES

+ (NSData *)encrypt:(NSData *)data key:(NSString *)key iv:(nullable NSString *)iv {
    return [self encrypt:data key:key iv:iv op:kCCEncrypt];
}

+ (NSData *)decrypt:(NSData *)data key:(NSString *)key iv:(nullable NSString *)iv {
    return [self encrypt:data key:key iv:iv op:kCCDecrypt];
}

+ (NSData *)encrypt:(NSData *)data key:(NSString *)key iv:(nullable NSString *)iv op:(CCOperation)op {
    if(data == nil || [data length] <= 0) {
        return nil;
    }
    if(key == nil || [key length] <= 0) {
        return nil;
    }
    
    size_t keySize; // 秘钥长度，不为 8、24 返回 nil
    CCAlgorithm algorithm;   // 加密算法
    if(key.length == kCCKeySizeDES) {
        keySize = key.length;
        algorithm = kCCAlgorithmDES;
    } else if(key.length == kCCKeySize3DES) {
        keySize = key.length;
        algorithm = kCCAlgorithm3DES;
    } else {
        return nil;
    }
    
    NSData *result = nil;
    // 默认 option
    CCOptions options = kCCOptionECBMode | kCCOptionPKCS7Padding;
    BOOL isCBC = NO;
    
    //setup key
    const char *cKey = [key UTF8String];
    
//    unsigned char cKey[keySize];
//    bzero(cKey, sizeof(cKey));
//    [[key dataUsingEncoding:NSUTF8StringEncoding] getBytes:cKey length:keySize];
    
//    使用 memset 方式 size 需要 +1，最后一位存 '\0'
//    char cKey[keySize+1];
//    memset(cKey, 0, sizeof(cKey));
//    [key getCString:cKey maxLength:sizeof(cKey) encoding:NSUTF8StringEncoding];
    
    //setup iv，长度不为 0、8 返回 nil
    const char *cIv = nil;
    if(iv && iv.length != 0) {
        if(iv.length == kCCKeySizeDES) {
            cIv = [iv UTF8String];
            options = kCCOptionPKCS7Padding;
            isCBC = YES;
        } else {
            return nil;
        }
    }
    
    //setup output buffer
    size_t bufferSize = [data length] + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    
    //do encrypt
    size_t encryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(op,                   // 加密 还是 解密
                                          algorithm,            // 算法
                                          options,              // CBC 模式还是 ECB 模式
                                          cKey,                 // 秘钥
                                          keySize,              // 秘钥长度
                                          cIv,                  // iv
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    } else {
        free(buffer);
    }
    return result;
}


@end

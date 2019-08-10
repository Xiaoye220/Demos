//
//  ViewController.m
//  CryptorDemo
//
//  Created by YZF on 2018/10/25.
//  Copyright © 2018 Xiaoye. All rights reserved.
//

#import "ViewController.h"
#import "Base64.h"
#import "AES.h"
#import "MD5.h"
#import "DES.h"
#import "Hmac.h"
#import <CommonCrypto/CommonCrypto.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testMD5];
//    [self testAES];
//    [self testDES];
//    [self testBase64];
//    [self testHMAC];
    
}

- (void)testMD5 {
    NSString *content = @"为所欲为";
    
    NSString *md5_1 = [MD5 md5:content];
//    NSString *md5_2 = [self md5:content];
    
    NSLog(@"%@", md5_1);
//    NSLog(@"%@", md5_2);
}

- (void)testBase64 {
    NSString *content = @"为所欲为";
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *encodeStr = [Base64 encode: contentData];
    NSData *decodeData = [Base64 decode: encodeStr];
    

    NSLog(@"decryptData: %@", [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding]);
}

- (void)testAES {
    NSString *key = @"1234567890123456";
    NSString *content = @"为所欲为";
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *encryptData = [AES encrypt:contentData key:key iv:key];
    NSData *decryptData = [AES decrypt:encryptData key:key iv:key];
    
    NSLog(@"encryptData: %@", encryptData);
    NSLog(@"decryptData: %@", [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding]);
}


- (void)testDES {
    NSString *key = @"12345678";
    NSString *content = @"为所欲为";
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *encryptData = [DES encrypt:contentData key:key iv:key];
    NSData *decryptData = [DES decrypt:encryptData key:key iv:key];
    
    NSLog(@"encryptData: %@", encryptData);

    NSLog(@"decryptData: %@", [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding]);
}

- (void)testHMAC {
    NSString *key = @"12345678";
    NSString *content = @"123456";
    
    NSString *hmacStr = [Hmac hmac:content key:key];
    NSLog(@"hmacStr: %@", hmacStr);
}

@end

//
//  YFSocialBase.m
//  YFSocial
//
//  Created by YZF on 2018/10/10.
//

#import "YFSocialBase.h"
#import "CTMediator.h"

@implementation YFSocialBase

-(void)base {
    NSLog(@"base");
}

- (void)facebook {
    [[CTMediator sharedInstance] performTarget:@"Facebook" action:@"facebook" params:nil shouldCacheTarget:NO];
}

@end

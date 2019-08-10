//
//  OMTSocialBase.m
//  OMTSocial
//
//  Created by YZF on 2018/10/10.
//

#import "OMTSocialBase.h"
#import "CTMediator.h"

@implementation OMTSocialBase

-(void)base {
    NSLog(@"base");
}

- (void)facebook {
    [[CTMediator sharedInstance] performTarget:@"Facebook" action:@"facebook" params:nil shouldCacheTarget:NO];
}

@end

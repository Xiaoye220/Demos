//
//  Target_Facebook.m
//  YFSocial
//
//  Created by YZF on 2018/10/15.
//

#import "Target_Facebook.h"
#import "YFSocialFacebook.h"

@implementation Target_Facebook

- (id)Action_facebook:(NSDictionary *)params; {
    NSLog(@"action facebook");
    
    YFSocialFacebook *facebook = [YFSocialFacebook new];
    [facebook facebook];
    
    return nil;
}

@end

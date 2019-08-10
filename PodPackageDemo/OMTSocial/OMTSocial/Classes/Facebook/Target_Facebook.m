//
//  Target_Facebook.m
//  OMTSocial
//
//  Created by YZF on 2018/10/15.
//

#import "Target_Facebook.h"
#import "OMTSocialFacebook.h"

@implementation Target_Facebook

- (id)Action_facebook:(NSDictionary *)params; {
    NSLog(@"action facebook");
    
    OMTSocialFacebook *facebook = [OMTSocialFacebook new];
    [facebook facebook];
    
    return nil;
}

@end

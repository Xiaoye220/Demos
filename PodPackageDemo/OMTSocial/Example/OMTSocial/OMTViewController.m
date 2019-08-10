//
//  OMTViewController.m
//  OMTSocial
//
//  Created by Xiaoye220 on 10/10/2018.
//  Copyright (c) 2018 Xiaoye220. All rights reserved.
//

#import "OMTViewController.h"

#import <OMTSocial/OMTSocial.h>
//#import "OMTSocialFacebook.h"

#import <OMTSocial/OMTSocialFacebook.h>

@interface OMTViewController ()

@end

@implementation OMTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    OMTSocialFacebook *facebook = [OMTSocialFacebook new];
//    [facebook base];

    OMTSocialBase *base = [OMTSocialBase new];
    [base base];
    [base facebook];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  Target_MediatorError.h
//  OMTSDKRouterKit
//
//  Created by mutouren on 2018/1/2.
//

#import <Foundation/Foundation.h>

@interface Target_MediatorError : NSObject


- (id)Action_NotReturnValueWithTargetName:(NSString *)targetName actionName:(NSString *)actionName;

- (id)Action_NotTargetWithTargetName:(NSString *)targetName;

- (id)Action_NotActionWithActionName:(NSString *)actionName;

@end

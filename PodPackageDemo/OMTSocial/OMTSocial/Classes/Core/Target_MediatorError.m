//
//  Target_MediatorError.m
//  OMTSDKRouterKit
//
//  Created by mutouren on 2018/1/2.
//

#import "Target_MediatorError.h"

@implementation Target_MediatorError

- (id)Action_NotReturnValueWithTargetName:(NSString *)targetName actionName:(NSString *)actionName {
    NSMutableString *logString = [NSMutableString
                                  stringWithString:@"\n\n***************************ctmediator Start***************************\n\n"];
    
    [logString appendFormat:@"ctmediator is not found return value target:\t\t%@ action:\t\t%@\n", targetName,actionName];
    
    [logString appendFormat:@"\n\n***************************ctmediator end***************************\n\n"];
    
    NSLog(@"%@",logString);
    //    NSAssert(NO, logString);
    return nil;
}

- (id)Action_NotTargetWithTargetName:(NSString *)targetName {
    NSMutableString *logString = [NSMutableString
                                  stringWithString:@"\n\n***************************ctmediator Start***************************\n\n"];
    
    [logString appendFormat:@"ctmediator is not found target:\t\t%@\n", targetName];
    
    [logString appendFormat:@"\n\n***************************ctmediator end***************************\n\n"];
    
    NSLog(@"%@",logString);
    //    NSAssert(NO, logString);
    return nil;
}

- (id)Action_NotActionWithActionName:(NSString *)actionName {
    NSMutableString *logString = [NSMutableString
                                  stringWithString:@"\n\n***************************ctmediator Start***************************\n\n"];
    
    [logString appendFormat:@"ctmediator is not found action:\t\t%@\n", actionName];
    
    [logString appendFormat:@"\n\n***************************ctmediator end***************************\n\n"];
    
    NSLog(@"%@",logString);
    //    NSAssert(NO, logString);
    
    return nil;
}

@end

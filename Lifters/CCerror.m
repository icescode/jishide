//
//  CCerror.m
//  hotstreamios
//
//  Created by Hardy on 21/11/15.
//  Copyright © 2015 ioshub. All rights reserved.
//

#import "CCerror.h"

#define ERROR_DOMAIN @"com.hotstream.ios"

@implementation CCerror

+(NSError *)ccerror:(NSString *)msg code:(int)code {
    
    return [NSError errorWithDomain:ERROR_DOMAIN
                               code:code
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:msg,NSLocalizedDescriptionKey ,nil]];
    
}

@end

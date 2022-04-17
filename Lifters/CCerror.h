//
//  CCerror.h
//  hotstreamios
//
//  Created by Hardy on 21/11/15.
//  Copyright © 2015 ioshub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCerror : NSObject
+(NSError *)ccerror:(NSString *)msg code:(int)code;
@end

//
//  CCMP3Encoder.h
//  hotstreamios
//
//  Created by Hardy on 21/11/15.
//  Copyright © 2015 ioshub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CCMP3Encoder : NSObject
-(id)initWithSamplerate:(int)samplerate bitrate:(int)bitrate optimize:(BOOL)optimize;
-(NSData *)encodedMP3Buffer:(AudioBufferList)buffer;
-(id)initializeMP3Encoder;
-(NSData *)encodedFlushLastBlock;
@end

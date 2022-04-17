//
//  CCVorbisEncoder.h
//  hotstreamios
//
//  Created by Hardy on 21/11/15.
//  Copyright © 2015 ioshub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void(^magicHeaderCompletion)(NSData *header, NSData * body);
typedef void(^vorbisPacketCompletion)(NSData *header, NSData * body);

@interface CCVorbisEncoder : NSObject

-(id)initVorbisWithSamplerate:(int)samplerate bitrate:(int)bitrate quality:(float)quality cbr:(BOOL)cbr vtag:(NSDictionary *)vtag;
-(id)vorbisInitWithParams;
-(void)vorbisCreateHeader:(magicHeaderCompletion)completion;
-(void)encodedVorbisBuffer:(AudioBufferList )buffer completion:(vorbisPacketCompletion)completion;
@end

//
//  CCMP3Encoder.m
//  hotstreamios
//
//  Created by Hardy on 21/11/15.
//  Copyright © 2015 ioshub. All rights reserved.
//


#import "CCMP3Encoder.h"
#import "lame.h"
#import "CCerror.h"
#import <Accelerate/Accelerate.h>

#define MP3_NOT_OK -100

@interface CCMP3Encoder () {
    
    lame_t lame;
    long ret;
    int defaultBitrate;
    int defaultSamplerate;
    BOOL optimizeCPUUsage;
    
}
@end

@implementation CCMP3Encoder

-(id)initWithSamplerate:(int)samplerate bitrate:(int)bitrate optimize:(BOOL)optimize {
    
    if (self) {
        
        defaultSamplerate = samplerate;
        defaultBitrate = bitrate;
        optimizeCPUUsage = optimize;
    }
    return self;
}
-(id)initializeMP3Encoder {
    
    
    lame = lame_init();
    
    lame_set_mode(lame, STEREO);
    
    if (optimizeCPUUsage) {
        
        lame_set_preset(lame, MEDIUM);
    }
    
    lame_set_in_samplerate(lame, defaultSamplerate);
    lame_set_brate(lame,defaultBitrate);
    lame_set_out_samplerate(lame,defaultSamplerate);
    
    int status = lame_init_params(lame);
    
    if (status >= 0 )  return nil;
    
    return [CCerror ccerror:@"Cannot initialize LAME encoder" code:MP3_NOT_OK];
}
-(NSData *)encodedMP3Buffer:(AudioBufferList)buffer {
    
    @autoreleasepool {
        
        
        unsigned bufferLen = 0;
        unsigned char * bufferChar = NULL;
        
        void ** channelBuffers	= NULL;
        short ** channelBuffers16 = NULL;
        
        int16_t *buffer16 = NULL;
        
        int result;
        
        
        unsigned channel,wideSample,sample;
        
        AudioBuffer audioBuffer = buffer.mBuffers[0];
        
        
        int numberFrames = audioBuffer.mDataByteSize / sizeof(Float32);
        
        /* see lame.h mp3buf_size in bytes = 1.25*num_samples + 7200 */
        
        bufferLen =  1.25 * (buffer.mBuffers[0].mNumberChannels * numberFrames) + 7200;
        
        bufferChar = (unsigned char *)calloc(bufferLen, sizeof(unsigned char));
        
        channelBuffers = calloc(buffer.mBuffers[0].mNumberChannels, sizeof(void *));
        
        for(channel = 0; channel < buffer.mBuffers[0].mNumberChannels; ++channel) {
            
            channelBuffers[channel] = NULL;
        }
        
        channelBuffers16 = (short **)channelBuffers;
        
        for(channel = 0; channel < buffer.mBuffers[0].mNumberChannels; ++channel) {
            
            channelBuffers16[channel] = calloc(numberFrames, sizeof(long));
            
            /* TODO catch if error happen when allocate memory failed */
        }
        
        buffer16 = buffer.mBuffers[0].mData;
        
        for(wideSample = sample = 0; wideSample < numberFrames; ++wideSample) {
            
            for(channel = 0; channel < buffer.mBuffers[0].mNumberChannels; ++channel, ++sample) {
                
                channelBuffers16[channel][wideSample] = (short)(buffer16[sample]);
            }
        }
        
        result = lame_encode_buffer(lame, channelBuffers16[0], channelBuffers16[1], numberFrames, bufferChar, bufferLen);
        
        NSData * retval = [NSData dataWithBytes:bufferChar length:result];
        
        for(channel = 0; channel < buffer.mBuffers[0].mNumberChannels; ++channel) {
            
            free(channelBuffers[channel]);
        }
        
        free(channelBuffers);
        free(bufferChar);
        return retval;

    }
    
    return nil;
    
}
-(NSData *)encodedFlushLastBlock {
    
    unsigned char * buf = NULL;
    int bufSize = 7200;
    int result;
    
    buf = (unsigned char*)calloc(bufSize, sizeof(unsigned char));
    
    result = lame_encode_flush(lame, buf, bufSize);
    
    NSData * retval = [NSData dataWithBytes:buf length:result];
    
    lame_close(lame);
    free(buf);

    return retval;
}
@end

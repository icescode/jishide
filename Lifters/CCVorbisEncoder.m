//
//  CCVorbisEncoder.m
//  hotstreamios
//
//  Created by Hardy on 21/11/15.
//  Copyright © 2015 ioshub. All rights reserved.
//

#import "CCVorbisEncoder.h"
#import "vorbisenc.h"
#import "ogg.h"
#import "CCerror.h"

#define FORBIS_ERROR 
@interface CCVorbisEncoder () {
    
    /* vorbis */
    
    vorbis_info vi;
    vorbis_comment vc;
    vorbis_dsp_state vd;
    vorbis_block vb;
    
    ogg_stream_state os; /* take physical pages, weld into a logical */
    ogg_page         og; /* one Ogg bitstream page.  Vorbis packets are inside */
    ogg_packet       op; /* one raw packet of data for decode */
    
    ogg_packet header;
    ogg_packet header_comm;
    ogg_packet header_code;
    
    BOOL cbrMode;
    float vquality;
    int defaultSamplerate;
    int defaultBitrate;
    
    
    NSString * tagartist;
    NSString * tagtitle;
    
}
@end

@implementation CCVorbisEncoder

-(id)initVorbisWithSamplerate:(int)samplerate bitrate:(int)bitrate quality:(float)quality cbr:(BOOL)cbr vtag:(NSDictionary *)vtag {
    self = [super init];
    
    if(self) {
        
        vorbis_info_init(&vi);
        vquality = quality;
        cbrMode = cbr;
     
        defaultBitrate = bitrate;
        defaultSamplerate = samplerate;
        
        if(vtag) {
            
            if([vtag valueForKey:@"artist"]) tagartist = [[vtag valueForKey:@"artist"]description];
            if([vtag valueForKey:@"title"]) tagtitle = [[vtag valueForKey:@"title"]description];
        }
    }
    
    return self;
}
-(void)dealloc {
    
    ogg_stream_clear(&os);
    vorbis_block_clear(&vb);
    vorbis_dsp_clear(&vd);
    vorbis_comment_clear(&vc);
    vorbis_info_clear(&vi);

}
-(id)vorbisInitWithParams {
    
    int vret;
    
    if (!cbrMode) {
        
        
        if (vquality > 0) {
            
            vret = vorbis_encode_init_vbr(&vi, 2, defaultSamplerate, vquality);
            
        }else {
            
            vret = vorbis_encode_init_vbr(&vi, 2, defaultSamplerate, 0.7);
        }
        
        
        
    }else {
        
        
        vret = vorbis_encode_init(&vi, 2, defaultSamplerate, defaultBitrate * 1000, -1, -1);
    }
    
    
    if (vret != 0) {
        
        return [CCerror ccerror:@"cannot initialize vorbis" code:OV_EIMPL];
        
    }
    
    vret = vorbis_encode_setup_init(&vi);
    
    if (vret != 0) {
        
        return [CCerror ccerror:@"cannot initialize vorbis" code:OV_EIMPL];
        
    }
    
    vorbis_comment_init(&vc);
    
    if (tagartist && tagartist.length > 0) {
        
        vorbis_comment_add_tag(&vc,"ARTIST", tagartist.UTF8String);
        
    }else {
        
        vorbis_comment_add_tag(&vc,"ARTIST","unknown artist");
    }
    
    if (tagtitle && tagtitle.length > 0) {
        
        vorbis_comment_add_tag(&vc,"TITLE",tagtitle.UTF8String);
        
    }else {
        
        vorbis_comment_add_tag(&vc,"TITLE","unknown title");
    }
    
    vorbis_comment_add_tag(&vc,"Transcoder","libhotstreamios.v.1.0");
    vorbis_comment_add_tag(&vc,"vendor","http://hardy.ioshub.com");
    vorbis_comment_add_tag(&vc,"libvorbis",vorbis_version_string());
    
    
    vorbis_analysis_init(&vd,&vi);
    vorbis_block_init(&vd,&vb);
    
    srand((unsigned int)time(NULL));
    
    ogg_stream_init(&os,rand());
    
    vorbis_analysis_headerout(&vd,&vc,&header,&header_comm,&header_code);

    
    return nil;
}
-(void)vorbisCreateHeader:(magicHeaderCompletion)completion {
    
    ogg_stream_packetin(&os,&header); /* automatically placed in its own page */
    
    ogg_stream_packetin(&os,&header_comm);
    ogg_stream_packetin(&os,&header_code);
    
    for(;;) {
        
        if(0 == ogg_stream_flush(&os, &og)) break;
        
        if (og.body_len > 0 && og.header_len > 0) {
            
            completion([NSData dataWithBytes:og.header length:og.header_len],[NSData dataWithBytes:og.body length:og.body_len]);
        }
    }

}
-(void)encodedVorbisBuffer:(AudioBufferList )buffer completion:(vorbisPacketCompletion)completion {
    
    
    float **bufferO;
    
    int16_t *buffer16 = NULL;
    
    unsigned channel,wideSample,sample;
    
    
    AudioBuffer audioBuffer = buffer.mBuffers[0];
    
    int numberFrames = audioBuffer.mDataByteSize / sizeof(Float32);
    
    
    bufferO = vorbis_analysis_buffer(&vd, numberFrames);

    buffer16 = buffer.mBuffers[0].mData;
    
    for(wideSample = sample = 0; wideSample < numberFrames; ++wideSample) {
        
        for(channel = 0; channel < buffer.mBuffers[0].mNumberChannels; ++channel, ++sample) {
            
            bufferO[channel][wideSample] = ((int16_t)(buffer16[sample])) /32768.f;
        }
    }

    
    vorbis_analysis_wrote(&vd, numberFrames);
    
    while(vorbis_analysis_blockout(&vd,&vb)==1){
        
        vorbis_analysis(&vb, NULL);
        vorbis_bitrate_addblock(&vb);
        
        while(vorbis_bitrate_flushpacket(&vd,&op)){
            
            vorbis_bitrate_flushpacket(&vd,&op);
            ogg_stream_packetin(&os,&op);
            
            int result=ogg_stream_pageout(&os,&og);
            if(result==0)break;
            
            if(og.body_len > 0 && og.header_len > 0) {

                completion([NSData dataWithBytes:og.header length:og.header_len],[NSData dataWithBytes:og.body length:og.body_len]);

            }
            ogg_page_eos(&og);
        }
    }
}
@end

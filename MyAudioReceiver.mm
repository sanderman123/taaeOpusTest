//
//  MyAudioReceiver.m
//  taaeOpusTest
//
//  Created by Sander Valstar on 3/16/15.
//  Copyright (c) 2015 Sander Valstar. All rights reserved.
//

#import "MyAudioReceiver.h"

@implementation MyAudioReceiver
static void receiverCallback(__unsafe_unretained MyAudioReceiver *THIS,
                             __unsafe_unretained AEAudioController *audioController,
                             void *source,
                             const AudioTimeStamp *time,
                             UInt32 frames,
                             AudioBufferList *audio) {
    [THIS encodeOpus:audio];
    
//    [THIS->_player addToBufferAudioBufferList:audio frames:frames timestamp:time];
}
-(AEAudioControllerAudioCallback)receiverCallback {
    return (AEAudioControllerAudioCallback) receiverCallback;
}

-(void)encodeOpus:(AudioBufferList*)abl{
    //audioController.audioDescription
    [opusEncoder encodeBufferList:abl completionBlock:^(NSData *data, NSError *error) {
        if (data) {
            NSLog(@"opus data length, from: %u to: %lu", abl->mBuffers[0].mDataByteSize * abl->mNumberBuffers, (unsigned long)data.length);
            [self decodeOpus:data];
        } else {
            NSLog(@"Error encoding frame to opus: %@", error);
        }
    }];
}

- (void) decodeOpus:(NSData*)packetData {
    [opusDecoder decodePacket:packetData completionBlock:^(NSData *pcmData, NSUInteger numDecodedSamples, NSError *error) {
        if (error) {
            NSLog(@"Error decoding packet: %@", error);
            return;
        } else {
            NSLog(@"Decoded %lu samples", (unsigned long)numDecodedSamples);
            NSLog(@"PCMData length: %lu", (unsigned long)pcmData.length);
        }

        bool success = [self.player addToBufferPCMData:pcmData];
        if (!success) {
            NSLog(@"Error copying output pcm into buffer, insufficient space");
        }
    }];
}


- (void) setupOpusEncoderFromABSD:(AudioStreamBasicDescription)asbd {
    NSError *error = nil;
    opusEncoder = [OKEncoder encoderForASBD:asbd application:kOpusKitApplicationAudio error:&error];
    if (error) {
        NSLog(@"Error setting up opus encoder: %@", error);
    } else {
        NSLog(@"Opus encoder setup successfully");
    }
}

-(void) setupOpusDecoderFromASBD:(AudioStreamBasicDescription)asbd{
    OpusKitSampleRate sampleRate;
    switch ((int)asbd.mSampleRate) {
        case 8000:
            sampleRate = kOpusKitSampleRate_8000;
            break;
        case 12000:
            sampleRate = kOpusKitSampleRate_12000;
            break;
        case 16000:
            sampleRate = kOpusKitSampleRate_16000;
            break;
        case 24000:
            sampleRate = kOpusKitSampleRate_24000;
            break;
        default:
            sampleRate = kOpusKitSampleRate_48000;
            break;
    }
    
    OpusKitChannels channels;
    switch (asbd.mChannelsPerFrame) {
        case 2:
            channels = kOpusKitChannelsStereo;
            break;
        default:
            channels = kOpusKitChannelsMono;
            break;
    }
    
    opusDecoder = [[OKDecoder alloc] initWithSampleRate:sampleRate numberOfChannels:channels];
    NSError *error = nil;
    if (![opusDecoder setupDecoderWithError:&error]) {
        NSLog(@"Error setting up opus decoder: %@", error);
    } else {
        NSLog(@"Opus decoder setup successfully");
    }
}

-(instancetype)initWithPlayer:(MyAudioPlayer*) player AudioController:(AEAudioController*)audioController{
    self = [super init];
    self.player = player;
    self.audioController = audioController;
    
    [self setupOpusEncoderFromABSD:self.audioController.audioDescription];
    [self setupOpusDecoderFromASBD:self.audioController.audioDescription];
    return self;
}
@end
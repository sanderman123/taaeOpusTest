//
//  MyAudioReceiver.h
//  taaeOpusTest
//
//  Created by Sander Valstar on 3/16/15.
//  Copyright (c) 2015 Sander Valstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TheAmazingAudioEngine.h>
#import "MyAudioPlayer.h"
#import "OpusKit.h"

@interface MyAudioReceiver : NSObject<AEAudioReceiver>{
    OKEncoder *opusEncoder;
    OKDecoder *opusDecoder;
}

@property (nonatomic, strong) MyAudioPlayer* player;
@property (nonatomic,strong) AEAudioController* audioController;

-(instancetype)initWithPlayer:(MyAudioPlayer*) player AudioController:(AEAudioController*) audioController;


@end

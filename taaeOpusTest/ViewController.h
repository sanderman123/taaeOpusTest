//
//  ViewController.h
//  taaeOpusTest
//
//  Created by Sander Valstar on 3/16/15.
//  Copyright (c) 2015 Sander Valstar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheAmazingAudioEngine.h"
#import "AEPlaythroughChannel.h"
#import "MyAudioPlayer.h"
#import "MyAudioReceiver.h"


@interface ViewController : UIViewController{
    AEAudioController *audioController;
    AEPlaythroughChannel *playThrough;
    MyAudioPlayer *player;
    MyAudioReceiver *receiver;
}


@end


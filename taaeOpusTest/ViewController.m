//
//  ViewController.m
//  taaeOpusTest
//
//  Created by Sander Valstar on 3/16/15.
//  Copyright (c) 2015 Sander Valstar. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    audioController = [[AEAudioController alloc] initWithAudioDescription: [AEAudioController nonInterleavedFloatStereoAudioDescription] inputEnabled:YES];
    
    audioController.preferredBufferDuration = 0.0029;
    
    player = [[MyAudioPlayer alloc] init];
    
    //setup input
    
    receiver = [[MyAudioReceiver alloc] initWithPlayer:player AudioController:audioController];
//    id<AEAudioReceiver> receiverr = [AEBlockAudioReceiver audioReceiverWithBlock:
//                                    ^(void *source,
//                                      const AudioTimeStamp *time,
//                                      UInt32 frames,
//                                      AudioBufferList *audio) {
//                                        // Do something with 'audio'
//                                        [player addToBufferAudioBufferList:audio frames:frames timestamp:time];
//                                    }];
    
    [audioController addInputReceiver:receiver];
    
    [audioController addChannels:[NSArray arrayWithObject:player]];
    
    NSError *error = [NSError alloc];
    if(![audioController start:&error]){
        NSLog(@"Error starting AudioController: %@", error.localizedDescription);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

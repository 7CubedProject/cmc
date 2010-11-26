//
//  TapViewController.h
//  cmc
//
//  Created by Avi Itskovich on 10-11-26.
//  Copyright 2010 Bloq Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface TapViewController : UIViewController <GKSessionDelegate> {
  GKSession *session;
  GKPeerPickerController *peerPicker;

  AVAudioPlayer* _player;
}

@end

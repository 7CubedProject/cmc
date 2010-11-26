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

@interface TapViewController : UIViewController <GKSessionDelegate, GKPeerPickerControllerDelegate> {
  // Connection
  GKSession *_session;
  GKPeerPickerController *_peerPicker;
  NSString *_peer;

  // Audio
  AVAudioPlayer* _player;

  NSArray* _buttons;
}

@property (nonatomic, retain) GKSession *session;
@property (nonatomic, retain) GKPeerPickerController *peerPicker;
@property (nonatomic, retain) NSString *peer;

// Session Methods
- (void)invalidateSession:(GKSession *)session;

// GKPeerPickerController Delegate Methods
- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker;
- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session;
- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type;


@end

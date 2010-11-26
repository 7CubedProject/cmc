//
//  AudioFactory.h
//  cmc
//
//  Created by Jeff Verkoeyen on 10-11-26.
//  Copyright 2010 Jeff Verkoeyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioFactory : NSObject <
  AVAudioPlayerDelegate
> {
@private
  NSMutableArray* _inactivePlayers;  // of AVAudioPlayer* objects
  NSMutableArray* _activePlayers;  // of AVAudioPlayer* objects
  NSData* _audioData;
}

// Designated initializer
- (id)initWithData:(NSData*)audioData;

- (void)play;

@end

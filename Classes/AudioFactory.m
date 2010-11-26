//
//  AudioFactory.m
//  cmc
//
//  Created by Jeff Verkoeyen on 10-11-26.
//  Copyright 2010 Jeff Verkoeyen. All rights reserved.
//

#import "AudioFactory.h"


@implementation AudioFactory

- (id)initWithData:(NSData*)audioData {
  if (self = [super init]) {
    _inactivePlayers = [[NSMutableArray alloc] init];
    _activePlayers = [[NSMutableArray alloc] init];
    _audioData = [audioData retain];
  }

  return self;
}


- (id)init {
  return [self initWithData:nil];
}


- (void)dealloc {
  [_inactivePlayers release]; _inactivePlayers = nil;
  [_activePlayers release]; _activePlayers = nil;
  [_audioData release]; _audioData = nil;

  [super dealloc];
}


- (void)play {
  AVAudioPlayer* player = nil;

  if ([_inactivePlayers count] > 0) {
    player = [_inactivePlayers lastObject];
    [_inactivePlayers removeLastObject];

  } else {
    player = [[AVAudioPlayer alloc] initWithData:_audioData error:nil];
    player.delegate = self;
  }

  [player play];
  [_activePlayers addObject:player];
}


#pragma mark -
#pragma mark AVAudioPlayerDelegate


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
  [_activePlayers removeObject:player];
  [_inactivePlayers addObject:player];
}



@end

//
//  DrawingWindow.m
//  cmc
//
//  Created by Jeff Verkoeyen on 10-11-26.
//  Copyright 2010 Jeff Verkoeyen. All rights reserved.
//

#import "DrawingWindow.h"


@implementation DrawingWindow


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  if (event.type == UIEventSubtypeMotionShake) {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:nil];
  }
}

@end

//
//  DrawingView.h
//  cmc
//
//  Created by Jeff Verkoeyen on 10-11-26.
//  Copyright 2010 Jeff Verkoeyen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DrawingView : UIView {
@private
  CGContextRef _bmp;
  CGImageRef _image;
}

- (void)drawPoints:(NSArray*)points; // [{lastPoint:NSValue(CGPoint), thisPoint:NSValue(CGPoint)}, ...]

@end
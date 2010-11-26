//
//  DrawingView.m
//  cmc
//
//  Created by Jeff Verkoeyen on 10-11-26.
//  Copyright 2010 Jeff Verkoeyen. All rights reserved.
//

#import "DrawingView.h"

// http://developer.apple.com/library/mac/#documentation/GraphicsImaging/Conceptual/drawingwithquartz2d/dq_context/dq_context.html#//apple_ref/doc/uid/TP30001066-CH203
// Thanks, Apple!
CGContextRef MyCreateBitmapContext (int pixelsWide,
                                    int pixelsHigh) {
  CGContextRef    context = NULL;
  CGColorSpaceRef colorSpace;
  void *          bitmapData;
  int             bitmapByteCount;
  int             bitmapBytesPerRow;

  bitmapBytesPerRow   = (pixelsWide * 4);// 1
  bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);

  colorSpace = CGColorSpaceCreateDeviceRGB();// 2
  bitmapData = malloc( bitmapByteCount );// 3
  memset(bitmapData, 0, bitmapByteCount);
  if (bitmapData == NULL) {
    fprintf (stderr, "Memory not allocated!");
    return NULL;
  }
  context = CGBitmapContextCreate (bitmapData,// 4
                                   pixelsWide,
                                   pixelsHigh,
                                   8,      // bits per component
                                   bitmapBytesPerRow,
                                   colorSpace,
                                   kCGImageAlphaPremultipliedLast);
  if (context== NULL) {
    free (bitmapData);// 5
    fprintf (stderr, "Context not created!");
    return NULL;
  }
  CGColorSpaceRelease( colorSpace );// 6

  return context;// 7
}


@implementation DrawingView



- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    _bmp = MyCreateBitmapContext(frame.size.width, frame.size.height);

    _brushColor = [UIColor colorWithRed:(double)(rand()%100+100)/255.0
                                  green:(double)(rand()%100+100)/255.0
                                   blue:(double)(rand()%100+100)/255.0
                                  alpha:1];

    _image = CGBitmapContextCreateImage(_bmp);
  }

  return self;
}

- (void)dealloc {
  CFRelease(_bmp); _bmp = nil;
  CFRelease(_image); _image = nil;
  [super dealloc];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextDrawImage(context, rect, _image);
}


- (void)drawCircleAtPoint:(CGPoint)point {
  CGFloat circleRadius = 20;
  CGColorRef color = [_brushColor CGColor];
  const CGFloat* colorPts = CGColorGetComponents(color);
  CGContextSetRGBFillColor (_bmp,  colorPts[0], colorPts[1], colorPts[2], 1);
  CGContextFillEllipseInRect (_bmp, CGRectMake (point.x - circleRadius / 2,
                                                point.y - circleRadius / 2,
                                                circleRadius * 2, circleRadius * 2));
}


- (void)drawPoints:(NSArray*)points {
  for (NSDictionary* info in points) {
    CGPoint currentPoint = [[info objectForKey:@"currentPoint"] CGPointValue];
    CGPoint previousPoint = [[info objectForKey:@"previousPoint"] CGPointValue];

    for (CGFloat t = 0; t < 1; t += 0.1) {
      CGPoint interpPoint = CGPointMake(previousPoint.x + (currentPoint.x - previousPoint.x) * t,
                                        previousPoint.y + (currentPoint.y - previousPoint.y) * t);
      [self drawCircleAtPoint:interpPoint];
    }
  }

  CFRelease(_image);
  _image = CGBitmapContextCreateImage (_bmp);// 5

  [self setNeedsDisplay];
}


@end

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
  for (NSInteger ix = 0; ix < bitmapByteCount; ++ix) {
    ((char*)bitmapData)[rand()%bitmapByteCount] = rand()%256;
  }
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


- (void)drawPoints:(NSArray*)points {
  CGRect myBoundingBox;// 1
  myBoundingBox = CGRectMake (0, 0, self.bounds.size.width, self.bounds.size.height);// 2

  CGContextSetRGBFillColor (_bmp, 1, 0, 0, 1);
  CGContextFillRect (_bmp, CGRectMake (0, 0, 200, 100 ));

  CFRelease(_image);
  _image = CGBitmapContextCreateImage (_bmp);// 5

  [self setNeedsDisplay];
}


@end

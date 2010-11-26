//
//  cmcAppDelegate.h
//  cmc
//
//  Created by Avi Itskovich on 10-11-26.
//  Copyright 2010 Bloq Software. All rights reserved.
//

#import <UIKit/UIKit.h>

// Controllers
#import "TapViewController.h"

@interface cmcAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
  TapViewController *tapController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end


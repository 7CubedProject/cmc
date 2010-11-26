//
//  TapViewController.m
//  cmc
//
//  Created by Avi Itskovich on 10-11-26.
//  Copyright 2010 Bloq Software. All rights reserved.
//

#import "TapViewController.h"


@implementation TapViewController

@synthesize session     = _session;
@synthesize peerPicker  = _peerPicker;
@synthesize peer        = _peer;

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {

    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:
                      [[NSBundle mainBundle] pathForResource:@"beep_2" ofType:@"aifc"]];

    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
  }
  return self;
}

- (void)dealloc {
  [_player release]; _player = nil;

  [super dealloc];
}

#define PACK_COORD(row, col)    ((((row) & 0xFFFF) << 16) | ((col) & 0xFFFF))
#define UNPACK_COL(packed)      ((packed) & 0xFFFF)
#define UNPACK_ROW(packed)      (((packed) >> 16) & 0xFFFF)

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  _peerPicker = [[GKPeerPickerController alloc] init];
  _peerPicker.delegate = self;
  [_peerPicker show];

  static const CGFloat buttonSizeInPixels = 50;

  CGSize screenSize = [UIScreen mainScreen].bounds.size;
  NSInteger numberOfColumns = floor(screenSize.width / buttonSizeInPixels);
  NSInteger numberOfRows = floor(screenSize.height / buttonSizeInPixels);

  CGPoint topLeft = CGPointMake(floor((screenSize.width - numberOfColumns * buttonSizeInPixels) / 2),
                                floor((screenSize.height - numberOfRows * buttonSizeInPixels) / 2));

  NSMutableArray* buttons = [[NSMutableArray alloc]
                             initWithCapacity:numberOfRows * numberOfColumns];

  for (NSInteger iRow = 0; iRow < numberOfRows; ++iRow) {
    for (NSInteger iCol = 0; iCol < numberOfColumns; ++iCol) {
      UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
      CGRect frame = CGRectMake(topLeft.x + iCol * buttonSizeInPixels,
                                topLeft.y + iRow * buttonSizeInPixels,
                                buttonSizeInPixels, buttonSizeInPixels);
      [button addTarget: self
                 action: @selector(tapButton:)
       forControlEvents: UIControlEventTouchUpInside];
      button.tag = PACK_COORD(iRow, iCol);
      button.frame = frame;
      [self.view addSubview:button];
      [buttons addObject:button];
    }
  }

  _buttons = [[NSArray arrayWithArray:buttons] retain];
}

- (void)viewDidUnload {
  [_buttons release];
  _buttons = nil;
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

// DO IT!
- (void)tapButton:(UIButton*)button {
  NSInteger row = UNPACK_ROW(button.tag);
  NSInteger col = UNPACK_COL(button.tag);

  [_player play];
}

#pragma mark -
#pragma mark GKPeerPickerController Delegate

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
  // Hide old picker
  [picker dismiss];
  picker.delegate = nil;
/*
  // Show new picker
  _peerPicker = [[GKPeerPickerController alloc] init];
  _peerPicker.delegate = self;
  [_peerPicker show];*/
}

- (GKSession *)peerPickerController:(GKPeerPickerController *)picker sessionForConnectionType:(GKPeerPickerConnectionType)type {
  // Create a new session
  _session = [[GKSession alloc] initWithSessionID:@"cmc" displayName:@"Collabarative Music Creation" sessionMode:GKSessionModePeer];
  return [_session autorelease];
}

- (void)peerPickerController:(GKPeerPickerController *)picker didConnectPeer:(NSString *)peerID toSession:(GKSession *)session {

  // Set up the session
  self.peer = peerID;
  self.session = session;
  self.session.delegate = self;
  [self.session setDataReceiveHandler:self withContext:NULL];

  // Hide the picker
  [picker dismiss];
  picker.delegate = nil;
  [picker autorelease];

}

#pragma mark -
#pragma mark Session Methods

- (void)invalidateSession:(GKSession *)session {
  if (session) {
    [session disconnectFromAllPeers];
    session.available = NO;
    [session setDataReceiveHandler:nil withContext:NULL];
    session.delegate = nil;
  }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

    // Relinquish ownership any cached data, images, etc. that aren't in use.
}


@end


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

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _peerPicker = [[GKPeerPickerController alloc] init];
  _peerPicker.delegate = self;
  [_peerPicker show];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  [_player play];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark GKPeerPickerController Delegate

- (void)peerPickerControllerDidCancel:(GKPeerPickerController *)picker {
  // Hide old picker
  [picker dismiss];
  picker.delegate = nil;
  [picker autorelease];
  
  // Show new picker
  _peerPicker = [[GKPeerPickerController alloc] init];
  _peerPicker.delegate = self;
  [_peerPicker show];
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

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


@end

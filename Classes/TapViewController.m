//
//  TapViewController.m
//  cmc
//
//  Created by Avi Itskovich on 10-11-26.
//  Copyright 2010 Bloq Software. All rights reserved.
//

#import "TapViewController.h"

#import "DrawingView.h"


@implementation TapViewController

@synthesize session     = _session;
@synthesize peerPicker  = _peerPicker;
@synthesize peer        = _peer;

#pragma mark -
#pragma mark Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
  self.view = [[[DrawingView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _peerPicker = [[GKPeerPickerController alloc] init];
  _peerPicker.delegate = self;
  [_peerPicker show];
  DrawingView* view = (DrawingView*)self.view;
  [view drawPoints:nil];
}

- (void)viewDidUnload {
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
  //[self sendButtonTap:row column:col];

  [self playMusic];
}

- (void)playMusic {
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
  GKSession* session = [[GKSession alloc] initWithSessionID:@"cmc" displayName:@"Collabarative Music Creation" sessionMode:GKSessionModePeer];
  return [session autorelease];
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


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  NSArray *touchArray = [self encodeTouches:touches];
  [(DrawingView *)self.view drawPoints:touchArray];
  [self sendTouches:touchArray];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  NSArray *touchArray = [self encodeTouches:touches];
  [(DrawingView *)self.view drawPoints:touchArray];
  [self sendTouches:touchArray];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  NSArray *touchArray = [self encodeTouches:touches];
  [(DrawingView *)self.view drawPoints:touchArray];
  [self sendTouches:touchArray];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [self touchesEnded:touches withEvent:event];
}

#pragma mark -
#pragma mark GKSession Data Methods


- (NSArray *)encodeTouches:(NSSet *)touches {
  // Encode the touches in an array 
  NSArray *touchArray = [touches allObjects];
  NSMutableArray *pointArray = [[NSMutableArray alloc] initWithCapacity:[touchArray count]];
  for (UITouch *touch in touchArray) {
    NSDictionary *pointData = [[NSDictionary alloc] initWithObjectsAndKeys:
                               [NSValue valueWithCGPoint:[touch locationInView:self.view]],
                               @"currentPoint",
                               [NSValue valueWithCGPoint:[touch previousLocationInView:self.view]],
                               @"previousPoint",
                               nil];
    [pointArray addObject:pointData];
    [pointData release];
  }
  return [pointArray autorelease];
}

- (void)sendTouches:(NSArray *)touches {
  NSData *touchData = [NSKeyedArchiver archivedDataWithRootObject:touches];
  
  NSError *error = nil;
  [self.session sendDataToAllPeers:touchData withDataMode:GKSendDataReliable error:&error];
  
  if (error) {
    NSLog(@"SAD FACE ON SENDING DATA");
    NSLog(@"Error: %@", error);
  }
}

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession:(GKSession *)session context:(void *)context {

  id touchArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];

  if ([touchArray isKindOfClass:[NSArray class]]) {
    NSLog(@"Recieved Array");
    [(DrawingView *)self.view drawPoints:touchArray]; 
  } else {
    NSLog(@"Recieved something else");
  }

}

- (void)sendButtonTap:(NSInteger)row column:(NSInteger)column {

  NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:row],[NSNumber numberWithInt:column],nil];
  NSData *buttonData = [NSKeyedArchiver archivedDataWithRootObject:array];

  NSError *error = nil;
  [self.session sendDataToAllPeers:buttonData withDataMode:GKSendDataReliable error:&error];

  if (error) {
    NSLog(@"SAD FACE ON SENDING DATA");
    NSLog(@"Error: %@", error);
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

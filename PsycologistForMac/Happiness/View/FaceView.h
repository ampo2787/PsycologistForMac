//
//  FaceView.h
//  Psychologist
//
//  Created by WinsOffice on 2018. 4. 7..
//  Copyright © 2018년 Computer Engineering, CNU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@class FaceView ;

#pragma mark - Declaration of <FaceViewDelegte>
@protocol FaceViewDelegate

-(CGFloat) smilenessForFaceView:(FaceView *) requestor ;

@end


#pragma mark - Declaration of Public methods
@interface FaceView : NSView

-(void) reset;
@property (assign) id<FaceViewDelegate> delegate ;

-(BOOL)isFlipped;

//-(IBAction) pinchGestureRecognized:(UIPinchGestureRecognizer *) sender;
// Pinch gesture 를 처리한다


@end

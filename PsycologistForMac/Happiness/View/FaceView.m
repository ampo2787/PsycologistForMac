//
//  FaceView.m
//  Psychologist
//
//  Created by WinsOffice on 2018. 4. 7..
//  Copyright © 2018년 Computer Engineering, CNU. All rights reserved.
//

#import "FaceView.h"


#pragma mark - Declaration of Private Methods
@interface FaceView()

@property (nonatomic,readwrite) CGFloat faceScale ;
@property (nonatomic,readonly)  CGFloat smileness ;

-(void)  drawCircleAtCenterPoint:(CGPoint) centerPoint
                      withRadius:(CGFloat) radius
                       inContext:(CGContextRef) context ;
-(void)  drawFaceAtCenterPoint:(CGPoint) centerPoint
                    withRadius:(CGFloat) radius
                     inContext:(CGContextRef) context ;
-(void) drawEyesBasedOnFaceCenterPoint: (CGPoint) faceCenterPoint
                        withFaceRadius: (CGFloat) faceRadius
                             inContext: (CGContextRef) context ;
-(void) drawNoseBasedOnFaceCenterPoint: (CGPoint) faceCenterPoint
                        withFaceRadius: (CGFloat) faceRadius
                             inContext: (CGContextRef) context ;
@end


#pragma mark -
#pragma mark - Implementation of "FaceView" methods
@implementation FaceView

#pragma mark - Overrding methods
// MacOS 기본 좌표계는 iOS 좌표계와 y 축의 방향이 반대이다.
// NSView 객체에 대해, MacOS 좌표계의 y 축의 방향을 알아보는 method 가 isFlipped 이고,
// return 값이 NO 로 되어 있다.
// MacOS 좌표계를 iOS 좌표계와 동일하게 만들려면,
// isFlipped 를 override 하여 항상 YES 값을 얻게하면 된다.
-(BOOL) isFlipped {
    return YES;
}

#pragma mark - Implementation of methods

#define MIN_FACE_SCALE       0.05
#define MAX_FACE_SCALE       1.5
#define DEFAULT_FACE_SCALE   0.9


-(void) reset {
    self.faceScale = DEFAULT_FACE_SCALE;
}

// This method is only for reflecting Pinch Scale
-(void) sefFaceScale: (CGFloat) newScale {
    if (newScale < MIN_FACE_SCALE) {
        _faceScale = MIN_FACE_SCALE;
    }
    else if (newScale > MAX_FACE_SCALE) {
        _faceScale = MAX_FACE_SCALE;
    }
    else {
        _faceScale = newScale ;
    }
}


#pragma mark - Property Implementation
#define MAX_SMILENESS   +1.0
#define MIN_SMILENESS   -1.0
-(CGFloat) smileness {
    CGFloat  _smileness = [self.delegate smilenessForFaceView:self];
    if (_smileness < MIN_SMILENESS) {
        _smileness = MIN_SMILENESS ;
    } else if (_smileness > MAX_SMILENESS) {
        _smileness = MAX_SMILENESS ;
    }
    return _smileness ;
}


#pragma mark - private methods for drawRect()
#define CLOCKWISE   1 ;
-(void) drawCircleAtCenterPoint:(CGPoint) centerPoint
                     withRadius:(CGFloat) radius
                      inContext:(CGContextRef) context
{
    CGFloat startAngle = 0.0 ;
    CGFloat endAngle = 2.0 * M_PI ;
    int drawingDirection = CLOCKWISE ;
    [NSGraphicsContext saveGraphicsState];
    {
        CGContextBeginPath(context) ;
        {
            CGContextAddArc(context, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, drawingDirection) ;
            CGContextFillPath(context) ;
        }
        CGContextStrokePath(context) ;
    }
    [NSGraphicsContext restoreGraphicsState];
}

-(void)  drawFaceAtCenterPoint:(CGPoint) centerPoint
                    withRadius:(CGFloat) radius
                     inContext:(CGContextRef) context
{
    [[NSColor darkGrayColor] setFill] ;
    [self drawCircleAtCenterPoint:centerPoint withRadius:radius inContext:context] ;
}


#define EYE_HorizontalOffsetRatio    0.35
#define EYE_VerticalOffsetRatio      0.30
#define EYE_RadiusRatio              0.15
- (void) drawEyesBasedOnFaceCenterPoint: (CGPoint) faceCenterPoint
                         withFaceRadius: (CGFloat) faceRadius
                              inContext: (CGContextRef) context
{
    CGPoint eyePoint ;
    CGFloat eyeHorizontalOffset = faceRadius * EYE_HorizontalOffsetRatio ;
    CGFloat eyeVerticalOffset =  faceRadius * EYE_VerticalOffsetRatio ;
    CGFloat eyeRadius = faceRadius * EYE_RadiusRatio ;
    eyePoint.x = faceCenterPoint.x - eyeHorizontalOffset ;
    eyePoint.y = faceCenterPoint.y - eyeVerticalOffset ;
    
    [[NSColor cyanColor] setFill] ;
    [self drawCircleAtCenterPoint:eyePoint
                       withRadius:eyeRadius
                        inContext:context] ;
    eyePoint.x = faceCenterPoint.x + eyeHorizontalOffset ;
    [self drawCircleAtCenterPoint:eyePoint
                       withRadius:eyeRadius
                        inContext:context] ;
}

#define MOUTH_HorizontalOffsetRatio   0.45
#define MOUTH_VerticalOffsetRatio     0.5
#define MOUTH_RadiusRatio             0.3   // 얼굴 크기에 대한 비례

-(void) drawMouthBasedOnFaceCenterPoint:(CGPoint) faceCenterPoint
                         withFaceRadius:(CGFloat) faceRadius
                              inContext:(CGContextRef) context
{
    CGPoint mouthLeftPoint ;
    CGFloat mouthHorizontalOffset = faceRadius * MOUTH_HorizontalOffsetRatio ;
    CGFloat mouthVerticalOffset = faceRadius * MOUTH_VerticalOffsetRatio ;
    mouthLeftPoint.x = faceCenterPoint.x - mouthHorizontalOffset ;
    mouthLeftPoint.y = faceCenterPoint.y + mouthVerticalOffset ;
    CGPoint mouthRightPoint ;
    mouthRightPoint.x = faceCenterPoint.x + mouthHorizontalOffset ;
    mouthRightPoint.y = faceCenterPoint.y + mouthVerticalOffset ;
    
    CGPoint mouthLeftControlPoint = mouthLeftPoint;
    mouthLeftControlPoint.x += mouthHorizontalOffset * (2.0/3.0) ;
    CGPoint mouthRightControlPoint = mouthRightPoint ;
    mouthRightControlPoint.x -= mouthHorizontalOffset * (2.0/3.0) ;
    
    CGFloat smileOffset = (faceRadius * MOUTH_RadiusRatio) * self.smileness ;
    mouthLeftControlPoint.y += smileOffset ;
    mouthRightControlPoint.y += smileOffset ;
    
    CGContextSetLineWidth(context, 0.5) ; // 선 굵기
    [[NSColor greenColor] setStroke] ;
    [[NSColor greenColor] setFill] ;
    
    [NSGraphicsContext saveGraphicsState];
    {
        CGContextBeginPath(context) ;
        CGContextMoveToPoint(context, mouthLeftPoint.x, mouthLeftPoint.y) ;
        if (fabs(smileOffset) < 1) {
            // smileness 의 절대값이 1 미만으로 아주 작으면, 입을 가는 직선으로 그린다.
            CGContextAddLineToPoint(context, mouthRightPoint.x, mouthRightPoint.y) ;
            CGContextStrokePath(context);
        }
        else {
            // smileness 의 절대값이 1 이상인 경우에는, bezier curve 를 사용하여 입을 그린다.
            CGContextAddCurveToPoint
            (context,
             mouthLeftControlPoint.x, mouthLeftControlPoint.y,
             mouthRightControlPoint.x, mouthRightControlPoint.y,
             mouthRightPoint.x, mouthRightPoint.y) ;
            CGContextMoveToPoint(context, mouthRightPoint.x, mouthRightPoint.y) ;
            CGContextAddCurveToPoint
            (context,
             mouthRightControlPoint.x, mouthRightControlPoint.y-smileOffset/2,
             mouthLeftControlPoint.x, mouthLeftControlPoint.y-smileOffset/2,
             mouthLeftPoint.x, mouthLeftPoint.y) ;
            CGContextFillPath(context) ;
        }
    }
    [NSGraphicsContext restoreGraphicsState];
}

#define NOSE_HorizontalOffsetRatio      0.0
#define NOSE_VerticalOffsetRatio        0.1
#define NOSE_RadiusRatio                0.09

-(void) drawNoseBasedOnFaceCenterPoint: (CGPoint) faceCenterPoint
                        withFaceRadius: (CGFloat) faceRadius
                             inContext: (CGContextRef) context
{
    CGPoint noseCenterPoint = faceCenterPoint ;
    noseCenterPoint.y = faceCenterPoint.y + faceRadius * NOSE_VerticalOffsetRatio ;
    [[NSColor orangeColor] setFill] ;
    [self drawCircleAtCenterPoint:noseCenterPoint
                       withRadius:faceRadius*NOSE_RadiusRatio
                        inContext:context] ;
}

#pragma mark - Customization of drawRect()

- (void)drawRect:(CGRect)dirtyRect {
    // 얼굴의 중심 위치를 찾는다.
    CGPoint faceCenterPoint ;
    faceCenterPoint.x = self.bounds.origin.x + self.bounds.size.width / 2 ;
    faceCenterPoint.y = self.bounds.origin.y + self.bounds.size.height / 2 ;
    
    // 얼굴의 반경을 정한다. (얼굴은 정원이다)
    // FaceView 의 width 와 height 중 짧은 쪽을 얼굴 최대 직경으로 한다.
    CGFloat faceRadius = self.bounds.size.width / 2 ;
    if (self.bounds.size.width > self.bounds.size.height) {
        faceRadius = self.bounds.size.height / 2 ;
    }
    faceRadius *= self.faceScale ; // 얼굴 scale 에 맞추어 얼굴 반경을 조정한다.
    
    // 드로잉 컨텍스를 얻는다
    CGContextRef context = NSGraphicsContext.currentContext.graphicsPort ;
    
    // 얼굴의 각 부분을 그린다
    [self drawFaceAtCenterPoint:faceCenterPoint
                     withRadius:faceRadius
                      inContext:context] ;
    [self drawEyesBasedOnFaceCenterPoint:faceCenterPoint
                          withFaceRadius:faceRadius
                               inContext:context];
    [self drawMouthBasedOnFaceCenterPoint:faceCenterPoint
                           withFaceRadius:faceRadius
                                inContext:context] ;
    [self drawNoseBasedOnFaceCenterPoint:faceCenterPoint
                          withFaceRadius:faceRadius
                               inContext:context] ;
}


#pragma mark - Reflect the new face scale By Pinch Gesture
//- (IBAction) pinchGestureRecognized:(UIPinchGestureRecognizer *) sender {
//    if ((sender.state == UIGestureRecognizerStateChanged) ||
//        (sender.state == UIGestureRecognizerStateEnded)     )
//    {
//        self.faceScale *= sender.scale;
//        sender.scale = 1.0 ;
//        // Pinch scale is always 1 just before new pinching.
//        // So, we want to get newly the relative pinch scale
//        // based on the value 1 which we set the previous pinch scale as.
//        [self setNeedsDisplay] ;
//    }
//}

@end

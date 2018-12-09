//
//  HappinessViewController.m
//  Psychologist
//
//  Created by WinsOffice on 2018. 4. 7..
//  Copyright © 2018년 Computer Engineering, CNU. All rights reserved.
//

#import "HappinessViewController.h"
#import "PsychologistViewController.h"

@interface HappinessViewController ()

+(CGFloat) happinessToSmileness:(int) happiness; // happiness 를 smileness 로 변환
-(void) updateFaceView;

@property (nonatomic,readonly) PsychologistViewController* psychologistViewController;


@end


#define MAX_HAPPINESS       100
#define MIN_HAPPINESS       0
#define DEFAULT_HAPPINESS   50


#pragma mark - Implementation of "HappnewwViewController"
@implementation HappinessViewController

+(CGFloat) happinessToSmileness:(int) happiness {
    // 구간 [0,100] 의 Happiness int 값을,
    // 얼굴 드로잉에 사용할 구간 [-1,+1] 의 smileness 값으로 변환한다.
    CGFloat ratioOfHappiness = (CGFloat)(happiness - MIN_HAPPINESS) / (CGFloat)(MAX_HAPPINESS - MIN_HAPPINESS) ;
    // ratio 의 범위: [0, +1]
    CGFloat smileness = ratioOfHappiness * 2.0 - 1.0; // smileness 의 범위: [-1,+1]
    return smileness;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    [self.faceView reset]; // faceView 를 초기화
    self.faceView.delegate = self ; // faceView 의 delegate 설정
    
    self.view.layer.backgroundColor = NSColor.lightGrayColor.CGColor;
    [self updateFaceView] ;
}


-(void) updateFaceView {
    self.happinessSlider.intValue = self.happiness ;
    self.happinessLabel.stringValue = [NSString stringWithFormat:@"%d",self.happiness] ;
    [self.faceView setNeedsDisplay:TRUE] ;
}


#pragma mark - Properties
-(void) setHappiness:(int)newHappiness {
    if (newHappiness < MIN_HAPPINESS) {
        newHappiness = MIN_HAPPINESS ;
    }
    else if (newHappiness > MAX_HAPPINESS) {
        newHappiness = MAX_HAPPINESS ;
    }
    _happiness = newHappiness ;
    [self updateFaceView] ;
}


-(PsychologistViewController*) psychologistViewController {
    return (PsychologistViewController*)
        self.parentViewController.childViewControllers.firstObject;
}

#pragma mark - Implementation of <FaceViewDelegate> Protocol
-(CGFloat) smilenessForFaceView:(FaceView *)requestor {
    CGFloat smileness = 0.0 ;
    // 의미 없는 기본 값.
    // 현재 viewController 가 알고 있는 FaceView 객체가 Requestor 가 아니라면,
    // 의미 없는 기본 값을 제공한다.
    if (requestor == self.faceView) {
        // 현재 viewController 가 알고 있는 FaceView 객체이므로, 정확한 smileness 값을 계산한다.
        smileness = [[self class] happinessToSmileness:self.happiness] ;
    }
    return smileness ;
}


#pragma mark - Implementation of IBAction

- (IBAction)backToPsychologistTouched:(NSButton *)sender {
    [self.psychologistViewController enableAnswerButtons];
}

- (IBAction)happinessSliderChanged:(NSSlider *)sender {
    [self setHappiness:sender.intValue] ;
}

@end

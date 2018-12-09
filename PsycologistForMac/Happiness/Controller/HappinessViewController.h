//
//  HappinessViewController.h
//  Psychologist
//
//  Created by WinsOffice on 2018. 4. 7..
//  Copyright © 2018년 Computer Engineering, CNU. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "FaceView.h"

@interface HappinessViewController : NSViewController <FaceViewDelegate>
    // FaceView 에서 HappinessViewContorller 의 happiness 값을 얻게 하려고 하는 delegate 이다.

@property (nonatomic,assign)    int happiness;
    // PsychologistControllerView 에서 진단 후 diagnosis 값을,
    // 이곳 HappinessViewController 의 happiness 값으로 전달하는 목적으로 사용된다.
    // Happiness 값이 새롭게 주어지면, FaceView 는 그에 맞게 그려지게 된다.

@property (weak) IBOutlet   NSTextField *happinessLabel;
// 현재의 happiness 값 [0,100] 을 보여주는 Label

@property (weak) IBOutlet   FaceView* faceView;
// 얼굴을 그려서 보여주는 View

@property (weak) IBOutlet   NSSlider *happinessSlider;
// Slider 의 값을, 프로그램에서 설정하는 용도로 사용
// 구간 [0,100] 의 Happiness 값을 slider 값으로 전달한다.

- (IBAction)happinessSliderChanged:(NSSlider *)sender;
// 사용자가 변경한 슬라이더 값을 받아들이는 responder


@property (weak) IBOutlet NSButton *backToPsychologistButton;
// HappinessView 에서 PsychologistView 로 되돌아 가기 위한 버튼

- (IBAction)backToPsychologistTouched:(NSButton *)sender;
// backToPsychologistButton 이 touch 된 것을 처리
// HappinessView 에서 PsychologistView 로 되돌아 가게 한다.


@end

//
//  PsychologistViewController.h
//  PsycologistForMac
//
//  Created by JihoonPark on 2018. 10. 1..
//  Copyright © 2018년 JihoonPark. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

#define PSYCHOLOGIST_NOTIFICATION_GOOD @"phychologist_noti_good"
#define PSYCHOLOGIST_NOTIFICATION_SOSO @"phychologist_noti_soso"
#define PSYCHOLOGIST_NOTIFICATION_BAD @"phychologist_noti_bad"

@interface PsychologistViewController : NSViewController

-(void) enableAnswerButtons;

@end

NS_ASSUME_NONNULL_END

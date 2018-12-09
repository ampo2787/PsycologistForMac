//
//  PsychologistViewController.m
//  PsycologistForMac
//
//  Created by JihoonPark on 2018. 10. 1..
//  Copyright © 2018년 JihoonPark. All rights reserved.
//

#import "PsychologistViewController.h"
#import "HappinessViewController.h"

@interface PsychologistViewController ()

@property (readonly) HappinessViewController * happinessViewController;

-(IBAction)sadButtonTouched:(NSButton *)sender;
-(IBAction)sosoButtonTouched:(NSButton *)sender;
-(IBAction)happyButtonTouched:(NSButton *)sender;

@property (weak) IBOutlet NSButton *sadButton;
@property (weak) IBOutlet NSButton *sosoButton;
@property (weak) IBOutlet NSButton *happyButton;

-(void) showDiagnosis:(int) diagnosis;

-(void) setAnswerButton:(NSButton*) answerButton withTitleColor:(NSColor *) titleColor;

-(void) initFeelingButton;

@end

#pragma mark - Implementation of Methods
@implementation PsychologistViewController

#pragma mark - Private Methods

-(void) setAnswerButton:(NSButton *)answerButton withTitleColor:(NSColor *)titleColor{
    NSMutableAttributedString* attributedTitleOfButton = [[NSMutableAttributedString alloc]initWithAttributedString:answerButton.attributedTitle];
    NSRange titleRange = NSMakeRange(0, attributedTitleOfButton.length);
    [attributedTitleOfButton addAttribute:NSForegroundColorAttributeName value:titleColor range:titleRange];
    
    NSFont * font = [NSFont fontWithName:@"Helvetica" size:18];
    [attributedTitleOfButton addAttribute:NSFontAttributeName value:font range:titleRange];
    [answerButton setAttributedTitle:attributedTitleOfButton];
}

-(void)showDiagnosis:(int)diagnosis{
    self.happinessViewController.happiness = diagnosis;
}

-(void)initFeelingButton{
    [self setAnswerButton:self.sadButton withTitleColor:NSColor.yellowColor];
    [self setAnswerButton:self.sosoButton withTitleColor:NSColor.cyanColor];
    [self setAnswerButton:self.happyButton withTitleColor:NSColor.orangeColor];
    self.happinessViewController.view.hidden = YES;
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.backgroundColor = NSColor.darkGrayColor.CGColor;
    [self initFeelingButton];
}

- (void)viewWillAppear{
    [super viewWillAppear];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(feelingNotificationHandler:) name:PSYCHOLOGIST_NOTIFICATION_BAD object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(feelingNotificationHandler:) name:PSYCHOLOGIST_NOTIFICATION_SOSO object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(feelingNotificationHandler:) name:PSYCHOLOGIST_NOTIFICATION_GOOD object:nil];
    
}

#pragma mark - IBAction Methods

#define HAPPINESS_BAD   10
#define HAPPINESS_SOSO  50
#define HAPPINESS_GOOD  90

-(IBAction)sadButtonTouched:(NSButton *)sender{
    self.happinessViewController.view.hidden = NO;
    self.sosoButton.enabled = NO;
    self.happyButton.enabled = NO;
    [self showDiagnosis:HAPPINESS_BAD];
}
-(IBAction)sosoButtonTouched:(NSButton *)sender{
    self.happinessViewController.view.hidden = NO;
    self.sadButton.enabled = NO;
    self.happyButton.enabled = NO;
    [self showDiagnosis:HAPPINESS_SOSO];
}

-(IBAction)happyButtonTouched:(NSButton *)sender{
    self.happinessViewController.view.hidden = NO;
    self.sosoButton.enabled = NO;
    self.sadButton.enabled = NO;
    [self showDiagnosis:HAPPINESS_GOOD];
}

#pragma mark - Getter for object/ViewController
-(void)setRepresentedObject:(id)representedObject{
    [super setRepresentedObject:representedObject];
}

-(HappinessViewController *) happinessViewController{
    return (HappinessViewController*) self.parentViewController.childViewControllers.lastObject;
}

#pragma mark - public method

-(void) enableAnswerButtons {
    self.happinessViewController.view.hidden = YES;
    self.sadButton.enabled = YES;
    self.sosoButton.enabled = YES;
    self.happyButton.enabled = YES;
}

#pragma mark - Notification Handler

-(void)feelingNotificationHandler:(NSNotification *)noti{
    NSLog(@"feelingNotificationHandler %@", noti.name);
    [self enableAnswerButtons];
    if([noti.name isEqualToString:PSYCHOLOGIST_NOTIFICATION_BAD]){
        [self sadButtonTouched:self.sadButton];
    }else if([noti.name isEqualToString:PSYCHOLOGIST_NOTIFICATION_GOOD]){
        [self happyButtonTouched:self.happyButton];
    } else if([noti.name isEqualToString:PSYCHOLOGIST_NOTIFICATION_SOSO]){
        [self sosoButtonTouched:self.sosoButton];
    }
}


@end

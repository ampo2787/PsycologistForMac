//
//  AppDelegate.m
//  PsycologistForMac
//
//  Created by JihoonPark on 2018. 10. 1..
//  Copyright © 2018년 JihoonPark. All rights reserved.
//

#import "AppDelegate.h"
#import "PsychologistViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (IBAction)funnyClick:(NSMenuItem *)sender {
    NSLog(@"funnyClick Here %@", sender.title);
    if([sender.title isEqualToString:@"Good"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:PSYCHOLOGIST_NOTIFICATION_GOOD object:self];
    }else if([sender.title isEqualToString:@"soso"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:PSYCHOLOGIST_NOTIFICATION_SOSO object:self];
    }else if([sender.title isEqualToString:@"Bad"]){
        [[NSNotificationCenter defaultCenter]postNotificationName:PSYCHOLOGIST_NOTIFICATION_BAD object:self];
    }
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end

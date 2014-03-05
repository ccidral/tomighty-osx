//
//  AppDelegate.h
//  Tomighty
//
//  Created by Célio Cidral Jr on 23/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "TimerListener.h"

@class StatusIcon;

@interface AppDelegate : NSObject <NSApplicationDelegate, TimerListener>

@property(weak) IBOutlet NSMenu *statusMenu;
@property(weak) IBOutlet NSMenuItem *remainingTimeMenuItem;
@property(weak) IBOutlet NSMenuItem *stopTimerMenuItem;
@property(weak) IBOutlet NSMenuItem *pomodoroCountMenuItem;
@property(weak) IBOutlet NSMenuItem *resetPomodoroCountMenuItem;
@property(weak) IBOutlet NSMenuItem *startPomodoroMenuItem;
@property(weak) IBOutlet NSMenuItem *startShortBreakMenuItem;
@property(weak) IBOutlet NSMenuItem *startLongBreakMenuItem;
@property(weak) IBOutlet NSMenuItem *pauseTimerMenuItem;

- (IBAction)startPomodoro:(id)sender;

- (IBAction)startShortBreak:(id)sender;

- (IBAction)startLongBreak:(id)sender;

- (IBAction)stopTimer:(id)sender;

- (IBAction)resetPomodoroCount:(id)sender;

- (IBAction)showPreferences:(id)sender;

- (IBAction)pauseTimer:(id)sender;

@end

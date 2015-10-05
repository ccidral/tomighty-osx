//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <AppKit/AppKit.h>

#import "TYStatusMenu.h"
#import "TYStatusIcon.h"

@interface TYAppDelegate : NSObject <NSApplicationDelegate, TYStatusMenu, NSUserNotificationCenterDelegate>

@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet NSMenuItem *remainingTimeMenuItem;
@property (weak) IBOutlet NSMenuItem *stopTimerMenuItem;
@property (weak) IBOutlet NSMenuItem *pomodoroCountMenuItem;
@property (weak) IBOutlet NSMenuItem *resetPomodoroCountMenuItem;
@property (weak) IBOutlet NSMenuItem *startPomodoroMenuItem;
@property (weak) IBOutlet NSMenuItem *startShortBreakMenuItem;
@property (weak) IBOutlet NSMenuItem *startLongBreakMenuItem;

- (IBAction)startPomodoro:(id)sender;
- (IBAction)startShortBreak:(id)sender;
- (IBAction)startLongBreak:(id)sender;
- (IBAction)stopTimer:(id)sender;
- (IBAction)resetPomodoroCount:(id)sender;
- (IBAction)showPreferences:(id)sender;

@end

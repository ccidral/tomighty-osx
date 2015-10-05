//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYDefaultAppUI.h"

@implementation TYDefaultAppUI
{
    __strong id <TYStatusMenu> statusMenu;
    __strong id <TYStatusIcon> statusIcon;
}

- (id)initWith:(id <TYStatusMenu>)aStatusMenu statusIcon:(id<TYStatusIcon>)aStatusIcon
{
    self = [super init];
    if(self)
    {
        statusMenu = aStatusMenu;
        statusIcon = aStatusIcon;
    }
    return self;
}

- (void)switchToIdleState
{
    [statusMenu enableStopTimerItem:false];
    [statusMenu enableStartPomodoroItem:true];
    [statusMenu enableStartShortBreakItem:true];
    [statusMenu enableStartLongBreakItem:true];
    [statusIcon changeIcon:ICON_STATUS_IDLE];
    [self updateRemainingTime:0];
}

- (void)switchToPomodoroState
{
    [statusMenu enableStopTimerItem:true];
    [statusMenu enableStartPomodoroItem:false];
    [statusMenu enableStartShortBreakItem:true];
    [statusMenu enableStartLongBreakItem:true];
    [statusIcon changeIcon:ICON_STATUS_POMODORO];
}

- (void)switchToShortBreakState
{
    [statusMenu enableStopTimerItem:true];
    [statusMenu enableStartPomodoroItem:true];
    [statusMenu enableStartShortBreakItem:false];
    [statusMenu enableStartLongBreakItem:true];
    [statusIcon changeIcon:ICON_STATUS_SHORT_BREAK];
}

- (void)switchToLongBreakState
{
    [statusMenu enableStopTimerItem:true];
    [statusMenu enableStartPomodoroItem:true];
    [statusMenu enableStartShortBreakItem:true];
    [statusMenu enableStartLongBreakItem:false];
    [statusIcon changeIcon:ICON_STATUS_LONG_BREAK];
}

- (void)updateRemainingTime:(int)remainingSeconds
{
    int minutes = remainingSeconds / 60;
    int seconds = remainingSeconds % 60;
    
    NSString *text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
    [statusIcon setRemainingTimeText:text];
}

- (void)updatePomodoroCount:(int)count
{
    BOOL isPlural = count > 1;
    
    NSString *text = count > 0 ?
        [NSString stringWithFormat:@"%d pomodoro%@", count, isPlural ? @"s" : @""]
        : @"No pomodoros";

    [statusMenu setPomodoroCountText:text];
    [statusMenu enableResetPomodoroCountItem:count > 0];
}

@end

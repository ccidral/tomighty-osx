//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Carbon/Carbon.h>
#import "TYUserInterfaceAgent.h"
#import "TYTimerContext.h"

@implementation TYUserInterfaceAgent
{
    id <TYAppUI> ui;
    id <TYPreferences> preferences;
}

- (id)initWith:(id <TYAppUI>)theAppUI preferences:(id <TYPreferences>)aPreferences
{
    self = [super init];
    if(self)
    {
        ui = theAppUI;
        preferences = aPreferences;
    }
    return self;
}

- (void)dispatchNewNotification: (NSString*) text
{
    if ([preferences getInt:PREF_ENABLE_NOTIFICATIONS]) {
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        notification.title = text;
        notification.soundName = NSUserNotificationDefaultSoundName;
        
        [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    }
}

- (void)updateAppUiInResponseToEventsFrom:(id <TYEventBus>)eventBus
{
    [eventBus subscribeTo:APP_INIT subscriber:^(id eventData) {
        [ui switchToIdleState];
        [ui updateRemainingTime:0 withMode:TYAppUIRemainingTimeModeDefault];
        [ui setStatusIconTextFormat:(TYAppUIStatusIconTextFormat) [preferences getInt:PREF_STATUS_ICON_TIME_FORMAT]];
        [ui updatePomodoroCount:0];
    }];

    [eventBus subscribeTo:POMODORO_START subscriber:^(id eventData) {
        [ui switchToPomodoroState];
        [self dispatchNewNotification:@"Pomodoro started"];
    }];
    
    [eventBus subscribeTo:TIMER_STOP subscriber:^(id eventData) {
        [ui switchToIdleState];
        [self dispatchNewNotification:@"Timer stopped"];
    }];
    
    [eventBus subscribeTo:SHORT_BREAK_START subscriber:^(id eventData) {
        [ui switchToShortBreakState];
        [self dispatchNewNotification:@"Short break started"];
    }];
    
    [eventBus subscribeTo:LONG_BREAK_START subscriber:^(id eventData) {
        [ui switchToLongBreakState];
        [self dispatchNewNotification:@"Long break started"];
    }];
    
    [eventBus subscribeTo:TIMER_TICK subscriber:^(id <TYTimerContext> timerContext) {
        [ui updateRemainingTime:[timerContext getRemainingSeconds] withMode:TYAppUIRemainingTimeModeDefault];
    }];

    [eventBus subscribeTo:TIMER_START subscriber:^(id <TYTimerContext> timerContext) {
        [ui updateRemainingTime:[timerContext getRemainingSeconds] withMode:TYAppUIRemainingTimeModeStart];
    }];
    
    [eventBus subscribeTo:POMODORO_COUNT_CHANGE subscriber:^(NSNumber *pomodoroCount) {
        [ui updatePomodoroCount:[pomodoroCount intValue]];
    }];

    [eventBus subscribeTo:PREFERENCE_CHANGE subscriber:^(NSString *preferenceKey) {
        if ([preferenceKey isEqualToString:PREF_STATUS_ICON_TIME_FORMAT]) {
            [ui setStatusIconTextFormat:(TYAppUIStatusIconTextFormat) [preferences getInt:PREF_STATUS_ICON_TIME_FORMAT]];
        }
    }];
}

@end

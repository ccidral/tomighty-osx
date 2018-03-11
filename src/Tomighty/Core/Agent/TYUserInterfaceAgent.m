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
        NSLog(@"%d --- ENABLE DND", [preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]);
        if ([preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                         1 * NSEC_PER_SEC),
                           dispatch_get_main_queue(),
                           ^{
                               turnDoNotDisturbOn();
                           });
            
        }
    }];
    
    [eventBus subscribeTo:POMODORO_COMPLETE subscriber:^(id eventData) {
        
        if ([preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]) {
            turnDoNotDisturbOff();
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     1 * NSEC_PER_SEC),
                       dispatch_get_main_queue(),
                       ^{
                           NSLog(@"--- Pomodoro complete");
                           [self dispatchNewNotification:@"Pomodoro completed"];
                       });
        
    }];
    
    [eventBus subscribeTo:TIMER_STOP subscriber:^(id eventData) {
        /*if ([preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                     1 * NSEC_PER_SEC),
                       dispatch_get_main_queue(),
                       ^{
                           NSLog(@"--- DISABLE DND");
                           turnDoNotDisturbOff();
                       });
        }*/
        if ([preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]) {
            turnDoNotDisturbOff();
        }
        [ui switchToIdleState];
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

///
/// This block of code for turning Do Not Disturb on and off
/// is directly from https://stackoverflow.com/a/36385778/518130
///
void turnDoNotDisturbOn(void)
{
    // The trick is to set DND time range from 00:00 (0 minutes) to 23:59 (1439 minutes),
    // so it will always be on
    CFPreferencesSetValue(CFSTR("dndStart"), (__bridge CFPropertyListRef)(@(0.0f)),
                          CFSTR("com.apple.notificationcenterui"),
                          kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    
    CFPreferencesSetValue(CFSTR("dndEnd"), (__bridge CFPropertyListRef)(@(1440.f)),
                          CFSTR("com.apple.notificationcenterui"),
                          kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    
    CFPreferencesSetValue(CFSTR("doNotDisturb"), (__bridge CFPropertyListRef)(@(YES)),
                          CFSTR("com.apple.notificationcenterui"),
                          kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    
    // Notify all the related daemons that we have changed Do Not Disturb preferences
    commitDoNotDisturbChanges();
}


void turnDoNotDisturbOff()
{
    CFPreferencesSetValue(CFSTR("dndStart"), NULL,
                          CFSTR("com.apple.notificationcenterui"),
                          kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    
    CFPreferencesSetValue(CFSTR("dndEnd"), NULL,
                          CFSTR("com.apple.notificationcenterui"),
                          kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    
    CFPreferencesSetValue(CFSTR("doNotDisturb"), (__bridge CFPropertyListRef)(@(NO)),
                          CFSTR("com.apple.notificationcenterui"),
                          kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    
    commitDoNotDisturbChanges();
}

void commitDoNotDisturbChanges(void)
{
    NSLog(@"--- CommitDND");
    /// XXX: I'm using kCFPreferencesCurrentUser placeholder here which means that this code must
    /// be run under regular user's account (not root/admin). If you're going to run this code
    /// from a privileged helper, use kCFPreferencesAnyUser in order to toggle DND for all users
    /// or drop privileges and use kCFPreferencesCurrentUser.
    CFPreferencesSynchronize(CFSTR("com.apple.notificationcenterui"), kCFPreferencesCurrentUser, kCFPreferencesCurrentHost);
    [[NSDistributedNotificationCenter defaultCenter] postNotificationName: @"com.apple.notificationcenterui.dndprefs_changed"
                                                                   object: nil userInfo: nil
                                                       deliverImmediately: YES];
}



@end

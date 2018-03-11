//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Carbon/Carbon.h>
#import "TYDefaultTimerContext.h"
#import "TYDefaultTomighty.h"
#import "TYEventBus.h"
#import "TYPreferences.h"
#import "TYHotkey.h"

@implementation TYDefaultTomighty
{
    int pomodoroCount;
    int pomodoroCycle;
    
    id <TYTimer> timer;
    id <TYPreferences> preferences;
    id <TYEventBus> eventBus;
    BOOL continuousMode;
    EventHotKeyRef startHotkeyRef, stopHotkeyRef;
}

- (id)initWith:(id <TYTimer>)aTimer
   preferences:(id <TYPreferences>)aPreferences
      eventBus:(id <TYEventBus>)anEventBus
{
    self = [super init];
    if(self)
    {
        pomodoroCount = 0;
        timer = aTimer;
        preferences = aPreferences;
        eventBus = anEventBus;
        continuousMode = [preferences getInt:PREF_CONTINUOUS_MODE];
        pomodoroCycle = [preferences getInt:PREF_TIME_CYCLE];
        
        [eventBus subscribeTo:POMODORO_COMPLETE subscriber:^(id eventData)
        {
            [self incrementPomodoroCount];
            
        }];
        
        [eventBus subscribeTo:READY_FOR_NEXT_TIMER subscriber:^(id eventData) {
            if ([preferences getInt:PREF_CONTINUOUS_MODE] == YES) {
                //start the next timer, depending on the previous context
                id <TYTimerContext> context = eventData;
                switch ([context getContextType]) {
                    case POMODORO:
                        if (pomodoroCount < pomodoroCycle) {
                            [self startShortBreak];
                        }
                        else {
                            [self startLongBreak];
                        }
                        break;
                        
                    default:
                        [self startPomodoro];
                        break;
                }
            }

        }];

        [eventBus subscribeTo:PREFERENCE_CHANGE subscriber:^(id eventData) {
            [self registerHotkeys];
        }];

        [self installHotkeyEventHandler];
        [self registerHotkeys];
    }
    return self;
}

- (void)startTimer:(TYTimerContextType)contextType
       contextName:(NSString *)contextName
           minutes:(int)minutes
{
    id <TYTimerContext> timerContext = [TYDefaultTimerContext
                                        ofType:contextType
                                        name:contextName
                                        remainingSeconds:minutes * 60];
    [timer start:timerContext];
}

- (void)startPomodoro
{
    NSLog(@"%d --- TEST", [preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]);
    if ([preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]) {
        sleep(0.5);
        turnDoNotDisturbOn();
    }
    [self startTimer:POMODORO
         contextName:@"Pomodoro"
             minutes:[preferences getInt:PREF_TIME_POMODORO]];
}

- (void)startShortBreak
{
    //if ([preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]) {
    //    turnDoNotDisturbOff();
    //}
    [self startTimer:SHORT_BREAK
         contextName:@"Short break"
             minutes:[preferences getInt:PREF_TIME_SHORT_BREAK]];
}

- (void)startLongBreak
{
    //if ([preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]) {
    //    turnDoNotDisturbOff();
    //}
    [self startTimer:LONG_BREAK
         contextName:@"Long break"
             minutes:[preferences getInt:PREF_TIME_LONG_BREAK]];

}

- (void)stopTimer
{
    [timer stop];
}

- (void)setPomodoroCount:(int)newCount
{
    pomodoroCount = newCount;
    [eventBus publish:POMODORO_COUNT_CHANGE data:[NSNumber numberWithInt:pomodoroCount]];
}

- (void)resetPomodoroCount
{
    [self setPomodoroCount:0];
}

- (void)incrementPomodoroCount
{
    int newCount = pomodoroCount + 1;
    
    if(newCount > pomodoroCycle)
    {
        newCount = 1;
    }
    
    [self setPomodoroCount:newCount];
}

// From here: http://stpeterandpaul.ca/tiger/documentation/Carbon/Reference/Carbon_Event_Manager_Ref/Reference/reference.html
- (void)installHotkeyEventHandler
{
    EventTypeSpec eventType;
    eventType.eventClass=kEventClassKeyboard;
    eventType.eventKind=kEventHotKeyPressed;

    InstallEventHandler(GetApplicationEventTarget(), &TYHotkeyHandler,
                        1, &eventType, (__bridge void*)self, NULL);
}

- (void)unregisterKeys
{
    if(startHotkeyRef) {
        UnregisterEventHotKey(startHotkeyRef);
        startHotkeyRef = nil;
    }
    if(stopHotkeyRef) {
        UnregisterEventHotKey(stopHotkeyRef);
        stopHotkeyRef = nil;
    }
}

- (void)registerHotkeys
{
    TYHotkey *start = [TYHotkey hotkeyWithString:[preferences
                                                 getString:PREF_HOTKEY_START]];
    TYHotkey *stop = [TYHotkey hotkeyWithString:[preferences
                                                    getString:PREF_HOTKEY_STOP]];
    EventHotKeyID hotkeyID;

    [self unregisterKeys];

    hotkeyID.signature='thk1'; // it's a UInt32 actually, value can be anything
    hotkeyID.id=11;
    RegisterEventHotKey(start.code, start.carbonFlags, hotkeyID,
                        GetApplicationEventTarget(), 0, &startHotkeyRef);

    hotkeyID.signature='thk2';
    hotkeyID.id=13;
    RegisterEventHotKey(stop.code, stop.carbonFlags, hotkeyID,
                        GetApplicationEventTarget(), 0, &stopHotkeyRef);

}

OSStatus TYHotkeyHandler(EventHandlerCallRef next, EventRef evt, void *data) {
    TYDefaultTomighty *target = (__bridge TYDefaultTomighty*)data;
    EventHotKeyID hkid;
    GetEventParameter(evt, kEventParamDirectObject,typeEventHotKeyID, NULL,
                      sizeof(hkid), NULL, &hkid);
    switch(hkid.id) {
        case 11:
            [target startPomodoro];
            break;
        case 13:
            [target stopTimer];
            break;
    }
    return noErr;
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

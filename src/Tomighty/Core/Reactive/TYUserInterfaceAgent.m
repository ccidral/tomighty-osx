//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYUserInterfaceAgent.h"
#import "TYTimerContext.h"

@implementation TYUserInterfaceAgent
{
    __strong id <TYAppUI> ui;
}

- (id)initWith:(id <TYAppUI>)theAppUI
{
    self = [super init];
    if(self)
    {
        ui = theAppUI;
    }
    return self;
}

- (void)updateTimer:(id) eventData
{
    id <TYTimerContext> timerContext = eventData;
    [ui updateRemainingTime:[timerContext getRemainingSeconds]];
}

- (void)updateAppUiInResponseToEventsFrom:(id <TYEventBus>)eventBus
{

    [eventBus subscribeTo:POMODORO_START subscriber:^(id eventData) {
        [self updateTimer: eventData];
        [ui switchToPomodoroState];
    }];
    
    [eventBus subscribeTo:TIMER_STOP subscriber:^(id eventData) {
        [self updateTimer: eventData];
        [ui switchToIdleState];
    }];
    
    [eventBus subscribeTo:SHORT_BREAK_START subscriber:^(id eventData) {
        [self updateTimer: eventData];
        [ui switchToShortBreakState];
    }];
    
    [eventBus subscribeTo:LONG_BREAK_START subscriber:^(id eventData) {
        [self updateTimer: eventData];
        [ui switchToLongBreakState];
    }];
    
    [eventBus subscribeTo:TIMER_TICK subscriber:^(id eventData) {
        [self updateTimer: eventData];
    }];
    
    [eventBus subscribeTo:POMODORO_COUNT_CHANGE subscriber:^(id eventData) {
        NSNumber *pomodoroCount = eventData;
        [ui updatePomodoroCount:[pomodoroCount intValue]];
    }];
}

@end

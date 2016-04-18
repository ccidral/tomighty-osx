//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TYEventType)
{
    APP_INIT                  = 0,
    
    TIMER_START               = 1,
    TIMER_TICK                = 2,
    TIMER_STOP                = 3,
    TIMER_ABORT               = 4,
    TIMER_GOES_OFF            = 5,
    
    POMODORO_START            = 6,
    BREAK_START               = 7,
    SHORT_BREAK_START         = 8,
    LONG_BREAK_START          = 9,
    
    POMODORO_COMPLETE         = 10,
    POMODORO_COUNT_CHANGE     = 11,
    
    PREFERENCE_CHANGE         = 12,
    READY_FOR_NEXT_TIMER      = 13
};

typedef void (^TYEventSubscriber)(id eventData);

@protocol TYEventBus <NSObject>

- (void)subscribeTo:(TYEventType)eventType subscriber:(TYEventSubscriber)subscriber;
- (void)publish:(TYEventType)eventType data:(id)data;

@end

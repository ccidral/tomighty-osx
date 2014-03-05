//
//  Preferences.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 28/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "Preferences.h"

NSString *const PREF_TIME_POMODORO = @"time_pomodoro";
NSString *const PREF_TIME_SHORT_BREAK = @"time_short_break";
NSString *const PREF_TIME_LONG_BREAK = @"time_long_break";
NSString *const PREF_SOUND_TIMER_START = @"sound_timer_start";
NSString *const PREF_SOUND_TIMER_FINISH = @"sound_timer_finish";
NSString *const PREF_SOUND_TICTAC_POMODORO = @"sound_tictac_pomodoro";
NSString *const PREF_SOUND_TICTAC_BREAK = @"sound_tictac_break";
NSString *const PREF_GENERAL_SHOW_IN_STATUS = @"general_show_in_status";
NSString *const PREF_GENERAL_ALLOW_PAUSE = @"general_allow_pause";

NSString *const PREF_CHANGED_NOTIFICATION = @"com.tomighty.preferencesChanged";
NSString *const PREF_CHANGED_NOTIFICATION_ITEM_KEY = @"com.tomighty.preferencesChanged.changedKey";


@implementation Preferences

+ (void)initialize {
    static BOOL initialized = NO;
    if (!initialized) {
        initialized = YES;

        NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
        [defaultValues setObject:[NSNumber numberWithInt:25] forKey:PREF_TIME_POMODORO];
        [defaultValues setObject:[NSNumber numberWithInt:5] forKey:PREF_TIME_SHORT_BREAK];
        [defaultValues setObject:[NSNumber numberWithInt:15] forKey:PREF_TIME_LONG_BREAK];
        [defaultValues setObject:[NSNumber numberWithInt:1] forKey:PREF_SOUND_TIMER_START];
        [defaultValues setObject:[NSNumber numberWithInt:1] forKey:PREF_SOUND_TIMER_FINISH];
        [defaultValues setObject:[NSNumber numberWithInt:1] forKey:PREF_SOUND_TICTAC_POMODORO];
        [defaultValues setObject:[NSNumber numberWithInt:1] forKey:PREF_SOUND_TICTAC_BREAK];
        [defaultValues setObject:[NSNumber numberWithInt:0] forKey:PREF_GENERAL_SHOW_IN_STATUS];
        [defaultValues setObject:[NSNumber numberWithInt:0] forKey:PREF_GENERAL_ALLOW_PAUSE];


        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    }
}

+ (NSInteger)integerForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] integerForKey:key];
}

+ (BOOL)boolForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:PREF_CHANGED_NOTIFICATION object:nil userInfo:@{PREF_CHANGED_NOTIFICATION_ITEM_KEY : key}];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:PREF_CHANGED_NOTIFICATION object:nil userInfo:@{PREF_CHANGED_NOTIFICATION_ITEM_KEY : key}];
}

@end

//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYUserDefaultsPreferences.h"
#import "TYEventBus.h"

NSString * const PREF_TIME_POMODORO            = @"org.tomighty.time.pomodoro";
NSString * const PREF_TIME_SHORT_BREAK         = @"org.tomighty.time.short_break";
NSString * const PREF_TIME_LONG_BREAK          = @"org.tomighty.time.long_break";
NSString * const PREF_TIME_CYCLE               = @"org.tomighty.time.cycle";
NSString * const PREF_PLAY_SOUND_WHEN_TIMER_STARTS        = @"org.tomighty.sound.play_on_timer_start";
NSString * const PREF_PLAY_SOUND_WHEN_TIMER_GOES_OFF         = @"org.tomighty.sound.play_on_timer_stop";
NSString * const PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO  = @"org.tomighty.sound.play_tick_tock_during_pomodoro";
NSString * const PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK     = @"org.tomighty.sound.play_tick_tock_during_break";
NSString * const PREF_CONTINUOUS_MODE = @"org.tomighty.continuous";
NSString * const PREF_STATUS_ICON_TIME_FORMAT     = @"org.tomighty.general.status_icon_time_format";
// formats must have same values as TYAppUIStatusIconTextFormat enum in TYAppUI.h
// TODO : move this values to some common place?
int const PREF_STATUS_ICON_TIME_FORMAT_NONE = 0;
int const PREF_STATUS_ICON_TIME_FORMAT_MINUTES = 1;
int const PREF_STATUS_ICON_TIME_FORMAT_SECONDS = 2;
NSString * const PREF_HOTKEY_START = @"org.tomighty.hotkey.start";
NSString * const PREF_HOTKEY_STOP = @"org.tomighty.hotkey.stop";
NSString * const PREF_ENABLE_NOTIFICATIONS = @"org.tomighty.enable_notifications";
NSString * const PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO = @"org.tomighty.enable_do_not_disturb_during_pomodoro";


@implementation TYUserDefaultsPreferences
{
    id <TYEventBus> eventBus;
}

- (id)initWith:(id <TYEventBus>)anEventBus
{
    self = [super init];
    if(self)
    {
        eventBus = anEventBus;

        NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

        [defaultValues setObject:[NSNumber numberWithInt:25] forKey:PREF_TIME_POMODORO];
        [defaultValues setObject:[NSNumber numberWithInt:5] forKey:PREF_TIME_SHORT_BREAK];
        [defaultValues setObject:[NSNumber numberWithInt:15] forKey:PREF_TIME_LONG_BREAK];
        [defaultValues setObject:[NSNumber numberWithInt:4] forKey:PREF_TIME_CYCLE];
        [defaultValues setObject:[NSNumber numberWithInt:true] forKey:PREF_PLAY_SOUND_WHEN_TIMER_STARTS];
        [defaultValues setObject:[NSNumber numberWithInt:true] forKey:PREF_PLAY_SOUND_WHEN_TIMER_GOES_OFF];
        [defaultValues setObject:[NSNumber numberWithInt:true] forKey:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO];
        [defaultValues setObject:[NSNumber numberWithInt:true] forKey:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK];
        [defaultValues setObject:[NSNumber numberWithInt:true] forKey:PREF_CONTINUOUS_MODE];
        [defaultValues setObject:[NSNumber numberWithInt:false] forKey:PREF_ENABLE_NOTIFICATIONS];
        [defaultValues setObject:[NSNumber numberWithInt:false] forKey:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO];
        [defaultValues setObject:[NSNumber numberWithInt:PREF_STATUS_ICON_TIME_FORMAT_NONE] forKey:PREF_STATUS_ICON_TIME_FORMAT];
        [defaultValues setObject:@"^⌘P" forKey:PREF_HOTKEY_START];
        [defaultValues setObject:@"^⌘S" forKey:PREF_HOTKEY_STOP];
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
    }
    return self;
}

- (int)getInt:(NSString *)key
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:key];
}

- (void)setInt:(NSString *)key value:(int)value
{
    int actualValue = [self getInt:key];
    if(value != actualValue)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [eventBus publish:PREFERENCE_CHANGE data:key];
    }
}

- (NSString*)getString:(NSString*)key
{
    NSString *ret = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return ret;
}

- (void)setString:(NSString *)key value:(NSString *)value
{
    NSString *v = [self getString:key];
    if(![v isEqualToString:value]) {
        [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
        [eventBus publish:PREFERENCE_CHANGE data:key];
    }
}
@end

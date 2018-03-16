//
//  TYPreferencesWindowController.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 12/03/14.
//  Copyright (c) 2014 Gig Software. All rights reserved.
//

#import "TYPreferences.h"
#import "TYPreferencesWindowController.h"

@interface TYPreferencesWindowController ()

@end

@implementation TYPreferencesWindowController
{
    id <TYPreferences> preferences;
}

- (id)initWithPreferences:(id <TYPreferences>)aPreferences
{
    self = [super initWithWindowNibName:@"PreferencesWindow"];
    {
        preferences = aPreferences;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self.text_time_pomodoro setIntValue:[preferences getInt:PREF_TIME_POMODORO]];
    [self.text_time_short_break setIntValue:[preferences getInt:PREF_TIME_SHORT_BREAK]];
    [self.text_time_long_break setIntValue:[preferences getInt:PREF_TIME_LONG_BREAK]];
    [self.text_time_cycle setIntValue:[preferences getInt:PREF_TIME_CYCLE]];
    [self.check_play_sound_when_timer_starts setState:[preferences getInt:PREF_PLAY_SOUND_WHEN_TIMER_STARTS]];
    [self.check_play_sound_when_timer_goes_off setState:[preferences getInt:PREF_PLAY_SOUND_WHEN_TIMER_GOES_OFF]];
    [self.check_play_ticktock_sound_during_pomodoro setState:[preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO]];
    [self.check_play_ticktock_sound_during_break setState:[preferences getInt:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK]];
    [self.check_show_notifications setState:[preferences getInt:PREF_ENABLE_NOTIFICATIONS]];
    [self.check_enable_do_not_disturb_during_pomodoro setState:[preferences getInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO]];
    [self.check_continuous_mode setState:[preferences getInt:PREF_CONTINUOUS_MODE]];
    [self.popup_status_icon_time_format selectItemAtIndex:[preferences getInt:PREF_STATUS_ICON_TIME_FORMAT]];
    [self.text_hotkey_start
     setHotkey:[TYHotkey hotkeyWithString:[preferences
                                            getString:PREF_HOTKEY_START]]];
    [self.text_hotkey_stop
     setHotkey:[TYHotkey hotkeyWithString:[preferences
                                            getString:PREF_HOTKEY_STOP]]];
}

- (void)windowWillClose:(NSNotification *)notification {
    // Force text controls to end editing before close
    [self.window makeFirstResponder:nil];
}

- (IBAction)save_time_pomodoro:(id)sender {
    [preferences setInt:PREF_TIME_POMODORO value:[self.text_time_pomodoro intValue]];
}

- (IBAction)save_time_short_break:(id)sender {
    [preferences setInt:PREF_TIME_SHORT_BREAK value:[self.text_time_short_break intValue]];
}

- (IBAction)save_time_long_break:(id)sender {
    [preferences setInt:PREF_TIME_LONG_BREAK value:[self.text_time_long_break intValue]];
}

- (IBAction)save_time_cycle:(id)sender {
    [preferences setInt:PREF_TIME_CYCLE value:[self.text_time_cycle intValue]];
}

- (IBAction)save_play_sound_when_timer_starts:(id)sender {
    [preferences setInt:PREF_PLAY_SOUND_WHEN_TIMER_STARTS value:(int)[self.check_play_sound_when_timer_starts state]];
}

- (IBAction)save_play_sound_when_timer_goes_off:(id)sender {
    [preferences setInt:PREF_PLAY_SOUND_WHEN_TIMER_GOES_OFF value:(int)[self.check_play_sound_when_timer_goes_off state]];
}

- (IBAction)save_play_ticktock_sound_during_pomodoro:(id)sender {
    [preferences setInt:PREF_PLAY_TICKTOCK_SOUND_DURING_POMODORO value:(int)[self.check_play_ticktock_sound_during_pomodoro state]];
}

- (IBAction)save_play_ticktock_sound_during_break:(id)sender {
    [preferences setInt:PREF_PLAY_TICKTOCK_SOUND_DURING_BREAK value:(int)[self.check_play_ticktock_sound_during_break state]];
}

- (IBAction)save_show_notifications:(id)sender {
    [preferences setInt:PREF_ENABLE_NOTIFICATIONS value:(int)[self.check_show_notifications state]];
}

- (IBAction)save_enable_do_not_disturb_during_pomodoro:(id)sender {
    [preferences setInt:PREF_ENABLE_DO_NOT_DISTURB_DURING_POMODORO value:(int)[self.check_enable_do_not_disturb_during_pomodoro state]];
}

- (IBAction)save_continuous_mode:(id)sender {
    [preferences setInt:PREF_CONTINUOUS_MODE value:(int)[self.check_continuous_mode state]];
}

- (IBAction)save_status_icon_time_format:(id)sender {
    [preferences setInt:PREF_STATUS_ICON_TIME_FORMAT value:(int)self.popup_status_icon_time_format.indexOfSelectedItem];
}

- (IBAction)save_hotkey_start:(id)sender
{
    // Note that we don't use [_t.. stringValue] because it'll return the key
    // with all modifiers, not just those which are pressed
    [preferences setString:PREF_HOTKEY_START
                     value:_text_hotkey_start.hotkey.string];
}

- (IBAction)save_hotkey_stop:(id)sender
{
    // Note that we don't use [_t.. stringValue] because it'll return the key
    // with all modifiers, not just those which are pressed
    [preferences setString:PREF_HOTKEY_STOP
                     value:_text_hotkey_stop.hotkey.string];
}

@end

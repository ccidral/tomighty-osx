//
//  PreferencesWindowController.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 28/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "Preferences.h"

@implementation PreferencesWindowController

- (id)init {
    self = [super initWithWindowNibName:@"PreferencesWindow"];
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.time_pomodoro setIntegerValue:[Preferences integerForKey:PREF_TIME_POMODORO]];
    [self.time_shortBreak setIntegerValue:[Preferences integerForKey:PREF_TIME_SHORT_BREAK]];
    [self.time_longBreak setIntegerValue:[Preferences integerForKey:PREF_TIME_LONG_BREAK]];
    [self.sound_on_timer_start setState:[Preferences boolForKey:PREF_SOUND_TIMER_START]];
    [self.sound_on_timer_finish setState:[Preferences boolForKey:PREF_SOUND_TIMER_FINISH]];
    [self.sound_tictac_during_pomodoro setState:[Preferences boolForKey:PREF_SOUND_TICTAC_POMODORO]];
    [self.sound_tictac_during_break setState:[Preferences boolForKey:PREF_SOUND_TICTAC_BREAK]];
    [self.general_show_in_status selectItemAtIndex:[Preferences integerForKey:PREF_GENERAL_SHOW_IN_STATUS]];
    [self.general_allow_pause setState:[Preferences integerForKey:PREF_GENERAL_ALLOW_PAUSE]];
}

- (void)windowWillClose:(NSNotification *)notification {
    // Force text controls to end editing before close
    [self.window makeFirstResponder:nil];
}

- (IBAction)save_time_pomodoro:(id)sender {
    [Preferences setInteger:[self.time_pomodoro integerValue] forKey:PREF_TIME_POMODORO];
}

- (IBAction)save_time_shortBreak:(id)sender {
    [Preferences setInteger:[self.time_shortBreak integerValue] forKey:PREF_TIME_SHORT_BREAK];
}

- (IBAction)save_time_longBreak:(id)sender {
    [Preferences setInteger:[self.time_longBreak integerValue] forKey:PREF_TIME_LONG_BREAK];
}

- (IBAction)save_sound_play_on_timer_start:(id)sender {
    [Preferences setBool:([self.sound_on_timer_start state] == NSOnState) forKey:PREF_SOUND_TIMER_START];
}

- (IBAction)save_sound_play_on_timer_finish:(id)sender {
    [Preferences setBool:([self.sound_on_timer_finish state] == NSOnState) forKey:PREF_SOUND_TIMER_FINISH];
}

- (IBAction)save_sound_play_tictac_during_pomodoro:(id)sender {
    [Preferences setBool:([self.sound_tictac_during_pomodoro state] == NSOnState) forKey:PREF_SOUND_TICTAC_POMODORO];
}

- (IBAction)save_sound_play_tictac_during_break:(id)sender {
    [Preferences setBool:([self.sound_tictac_during_break state] == NSOnState) forKey:PREF_SOUND_TICTAC_BREAK];
}

- (IBAction)save_general_show_in_status:(id)sender {
    [Preferences setInteger:self.general_show_in_status.indexOfSelectedItem forKey:PREF_GENERAL_SHOW_IN_STATUS];
}

- (IBAction)save_general_allow_pause:(id)sender {
    [Preferences setBool:([self.general_allow_pause state] == NSOnState) forKey:PREF_GENERAL_ALLOW_PAUSE];
}

@end

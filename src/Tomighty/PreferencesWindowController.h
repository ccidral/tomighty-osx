//
//  PreferencesWindowController.h
//  Tomighty
//
//  Created by Célio Cidral Jr on 28/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface PreferencesWindowController : NSWindowController

@property(weak) IBOutlet NSTextField *time_pomodoro;
@property(weak) IBOutlet NSTextField *time_shortBreak;
@property(weak) IBOutlet NSTextField *time_longBreak;
@property(weak) IBOutlet NSButton *sound_on_timer_start;
@property(weak) IBOutlet NSButton *sound_on_timer_finish;
@property(weak) IBOutlet NSButton *sound_tictac_during_pomodoro;
@property(weak) IBOutlet NSButton *sound_tictac_during_break;
@property(weak) IBOutlet NSPopUpButton *general_show_in_status;
@property(weak) IBOutlet NSButton *general_allow_pause;


- (IBAction)save_time_pomodoro:(id)sender;

- (IBAction)save_time_shortBreak:(id)sender;

- (IBAction)save_time_longBreak:(id)sender;

- (IBAction)save_sound_play_on_timer_start:(id)sender;

- (IBAction)save_sound_play_on_timer_finish:(id)sender;

- (IBAction)save_sound_play_tictac_during_pomodoro:(id)sender;

- (IBAction)save_sound_play_tictac_during_break:(id)sender;

- (IBAction)save_general_show_in_status:(id)sender;

- (IBAction)save_general_allow_pause:(id)sender;

@end

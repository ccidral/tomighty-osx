//
//  TYPreferencesWindowController.h
//  Tomighty
//
//  Created by Célio Cidral Jr on 12/03/14.
//  Copyright (c) 2014 Gig Software. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "TYHotkeyControl.h"

@interface TYPreferencesWindowController : NSWindowController

- (id)initWithPreferences:(id <TYPreferences>)preferences;

@property (weak) IBOutlet NSTextField *text_time_pomodoro;
@property (weak) IBOutlet NSTextField *text_time_short_break;
@property (weak) IBOutlet NSTextField *text_time_long_break;
@property (weak) IBOutlet NSTextField *text_time_cycle;
@property (weak) IBOutlet NSButton *check_play_sound_when_timer_starts;
@property (weak) IBOutlet NSButton *check_play_sound_when_timer_goes_off;
@property (weak) IBOutlet NSButton *check_play_ticktock_sound_during_pomodoro;
@property (weak) IBOutlet NSButton *check_play_ticktock_sound_during_break;
@property (weak) IBOutlet NSButton *check_show_notifications;
@property (weak) IBOutlet NSButton *check_enable_do_not_disturb_during_pomodoro;
@property (weak) IBOutlet NSButton *check_continuous_mode;
@property (weak) IBOutlet NSPopUpButton *popup_status_icon_time_format;
@property (weak) IBOutlet TYHotkeyControl *text_hotkey_start;
@property (weak) IBOutlet TYHotkeyControl *text_hotkey_stop;


- (IBAction)save_time_pomodoro:(id)sender;
- (IBAction)save_time_short_break:(id)sender;
- (IBAction)save_time_long_break:(id)sender;
- (IBAction)save_time_cycle:(id)sender;
- (IBAction)save_play_sound_when_timer_starts:(id)sender;
- (IBAction)save_play_sound_when_timer_goes_off:(id)sender;
- (IBAction)save_play_ticktock_sound_during_pomodoro:(id)sender;
- (IBAction)save_play_ticktock_sound_during_break:(id)sender;
- (IBAction)save_status_icon_time_format:(id)sender;
- (IBAction)save_hotkey_start:(id)sender;
- (IBAction)save_hotkey_stop:(id)sender;
- (IBAction)save_show_notifications:(id)sender;
- (IBAction)save_enable_do_not_disturb_during_pomodoro:(id)sender;

@end

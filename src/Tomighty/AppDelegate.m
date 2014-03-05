//
//  AppDelegate.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 23/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "AppDelegate.h"
#import "ImageLoader.h"
#import "Preferences.h"
#import "PreferencesWindowController.h"
#import "Sounds.h"
#import "StatusIcon.h"
#import "Timer.h"
#import "Tomighty.h"

@implementation AppDelegate {
    Tomighty *tomighty;
    Timer *timer;
    StatusIcon *statusIcon;
    PreferencesWindowController *preferencesWindow;
    Sounds *sounds;
    TimerContext *pomodoroContext;
    TimerContext *shortBreakContext;
    TimerContext *longBreakContext;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    tomighty = [[Tomighty alloc] init];
    timer = [[Timer alloc] initWithListener:self];
    statusIcon = [[StatusIcon alloc] initWithStatusMenu:[self statusMenu]];
    sounds = [[Sounds alloc] init];
    pomodoroContext = [[TimerContext alloc] initWithName:@"Pomodoro"];
    shortBreakContext = [[TimerContext alloc] initWithName:@"Short break"];
    longBreakContext = [[TimerContext alloc] initWithName:@"Long break"];

    [self initMenuItemsIcons];
    [self updateRemainingTime:0];
    [self updateStatusBarTitle:0 justStarted:NO];
    [self updateTimerControlMenuItems];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferencesChangedNotification:) name:PREF_CHANGED_NOTIFICATION object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PREF_CHANGED_NOTIFICATION object:nil];
}

- (void)preferencesChangedNotification:(NSNotification *)notif {
    NSString *changedKey = notif.userInfo[PREF_CHANGED_NOTIFICATION_ITEM_KEY];

    if ([changedKey isEqualToString:PREF_GENERAL_SHOW_IN_STATUS]) {
        [self updateStatusBarTitle:timer.secondsRemaining justStarted:NO];
    }

    if ([changedKey isEqualToString:PREF_SOUND_TICTAC_POMODORO] || [changedKey isEqualToString:PREF_SOUND_TICTAC_BREAK]) {
        [sounds stopTicTac];
        if (timer.context && [self shouldPlayTicTacSound:timer.context]) {
            [sounds startTicTac];
        }
    }

    if ([changedKey isEqualToString:PREF_GENERAL_ALLOW_PAUSE]) {
        [self updateTimerControlMenuItems];

        // unpause in case we were paused and pause menu item is hidden
        if (![Preferences boolForKey:PREF_GENERAL_ALLOW_PAUSE] && timer.paused) {
            timer.paused = NO;
        }
    }
}

- (void)initMenuItemsIcons {
    [self.remainingTimeMenuItem setImage:[ImageLoader loadIcon:@"clock"]];
    [self.stopTimerMenuItem setImage:[ImageLoader loadIcon:@"stop"]];
    [self.startPomodoroMenuItem setImage:[ImageLoader loadIcon:@"start-pomodoro"]];
    [self.startShortBreakMenuItem setImage:[ImageLoader loadIcon:@"start-short-break"]];
    [self.startLongBreakMenuItem setImage:[ImageLoader loadIcon:@"start-long-break"]];
    [self.pauseTimerMenuItem setImage:[ImageLoader loadIcon:@"pause"]];
}

- (IBAction)showPreferences:(id)sender {
    if (!preferencesWindow) {
        preferencesWindow = [[PreferencesWindowController alloc] init];
    }
    [preferencesWindow showWindow:nil];
    [NSApp activateIgnoringOtherApps:YES];
}

- (IBAction)startPomodoro:(id)sender {
    NSInteger minutes = [Preferences integerForKey:PREF_TIME_POMODORO];
    [self activateTimerMenuItem:self.startPomodoroMenuItem];
    [statusIcon pomodoro];
    [timer start:minutes context:pomodoroContext];
}

- (IBAction)startShortBreak:(id)sender {
    NSInteger minutes = [Preferences integerForKey:PREF_TIME_SHORT_BREAK];
    [self activateTimerMenuItem:self.startShortBreakMenuItem];
    [statusIcon shortBreak];
    [timer start:minutes context:shortBreakContext];
}

- (IBAction)startLongBreak:(id)sender {
    NSInteger minutes = [Preferences integerForKey:PREF_TIME_LONG_BREAK];
    [self activateTimerMenuItem:self.startLongBreakMenuItem];
    [statusIcon longBreak];
    [timer start:minutes context:longBreakContext];
}

- (IBAction)resetPomodoroCount:(id)sender {
    [tomighty resetPomodoroCount];
    [self updatePomodoroCountText];
    [self.resetPomodoroCountMenuItem setEnabled:NO];
}

- (void)stopTimer:(id)sender {
    [timer stop];
}

- (IBAction)pauseTimer:(id)sender {
    timer.paused = !timer.paused;
    [self updateTimerControlMenuItems];
}

- (void)timerTick:(NSInteger)secondsRemaining {
    [self updateRemainingTime:secondsRemaining];
    [self updateStatusBarTitle:secondsRemaining justStarted:NO];
}

- (void)timerStarted:(NSInteger)secondsRemaining context:(TimerContext *)context {
    [self updateRemainingTime:secondsRemaining];
    [self updateStatusBarTitle:secondsRemaining justStarted:YES];
    [self updateTimerControlMenuItems];

    if ([Preferences boolForKey:PREF_SOUND_TIMER_START]) {
        [sounds crank];
    }

    if ([self shouldPlayTicTacSound:context]) {
        [sounds startTicTac];
    }
}

- (void)timerStopped {
    [sounds stopTicTac];
    [statusIcon normal];
    [self updateRemainingTime:0];
    [self updateStatusBarTitle:0 justStarted:NO];
    [self updateTimerControlMenuItems];
    [self deactivateAllTimerMenuItems];
}

- (void)timerFinished:(TimerContext *)context {
    if ([Preferences boolForKey:PREF_SOUND_TIMER_FINISH]) {
        [sounds bell];
    }

    if (context == pomodoroContext) {
        [self incrementPomodoroCount];
    }

    [self showFinishNotification:context];
}

- (void)activateTimerMenuItem:(NSMenuItem *)menuItem {
    [self deactivateAllTimerMenuItems];
    [self activateTimerMenuItem:NSOnState menuItem:menuItem];
}

- (void)activateTimerMenuItem:(NSInteger)activate menuItem:(NSMenuItem *)menuItem {
    BOOL enabled = activate == NSOnState ? NO : YES;
    [menuItem setEnabled:enabled];
    [menuItem setState:activate];
}

- (void)deactivateAllTimerMenuItems {
    [self activateTimerMenuItem:NSOffState menuItem:self.startPomodoroMenuItem];
    [self activateTimerMenuItem:NSOffState menuItem:self.startShortBreakMenuItem];
    [self activateTimerMenuItem:NSOffState menuItem:self.startLongBreakMenuItem];
}

- (void)updateTimerControlMenuItems {
    [self.pauseTimerMenuItem setHidden:![Preferences boolForKey:PREF_GENERAL_ALLOW_PAUSE]];
    self.pauseTimerMenuItem.title = timer.paused ? @"Resume" : @"Pause";
    [self.stopTimerMenuItem setEnabled:timer.active];
    [self.pauseTimerMenuItem setEnabled:timer.active];
}

- (void)updateRemainingTime:(NSInteger)secondsRemaining {
    NSInteger minutes = secondsRemaining / 60;
    NSInteger seconds = secondsRemaining % 60;

    NSString *text = [NSString stringWithFormat:@"%02d:%02d", (int) minutes, (int) seconds];
    [self.remainingTimeMenuItem setTitle:text];
}

- (void)updateStatusBarTitle:(NSInteger)secondsRemaining justStarted:(BOOL)justStarted {
    // just started parameter is used to prevent flickering when starting timer and
    // we should display remaining minutes in status bar (it would show 26min for the
    // first second and then 25min otherwise)

    NSInteger showInStatus = [Preferences integerForKey:PREF_GENERAL_SHOW_IN_STATUS];
    if (showInStatus == 0) {
        [statusIcon setTitle:@""];
    } else if (secondsRemaining <= 0) {
        [statusIcon setTitle:@" Stopped"];
    } else {
        NSInteger minutes = secondsRemaining / 60;
        NSInteger seconds = secondsRemaining % 60;

        NSString *text = nil;
        if (showInStatus == 1) {
            text = [NSString stringWithFormat:@" %d m", (int) minutes + (justStarted ? 0 : 1)];
        } else if (showInStatus == 2) {
            text = [NSString stringWithFormat:@" %02d:%02d", (int) minutes, (int) seconds];
        }
        [statusIcon setTitle:text];
    }
}

- (void)updatePomodoroCountText {
    NSInteger pomodoroCount = tomighty.pomodoroCount;
    BOOL isPlural = pomodoroCount > 1;
    NSString *text =
            pomodoroCount > 0 ?
                    [NSString stringWithFormat:@"%d full pomodoro%@", (int) pomodoroCount, isPlural ? @"s" : @""]
                    : @"No full pomodoro yet";
    [self.pomodoroCountMenuItem setTitle:text];
}

- (void)incrementPomodoroCount {
    [tomighty incrementPomodoroCount];
    [self updatePomodoroCountText];
    [self.resetPomodoroCountMenuItem setEnabled:YES];
}

- (BOOL)shouldPlayTicTacSound:(TimerContext *)context {
    if (context == pomodoroContext)
        return [Preferences boolForKey:PREF_SOUND_TICTAC_POMODORO];
    else
        return [Preferences boolForKey:PREF_SOUND_TICTAC_BREAK];
}

- (void)showFinishNotification:(TimerContext *)context {
    NSString *title = [NSString stringWithFormat:@"%@ finished", [context name]];
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    [notification setTitle:title];

    // play notification sound only when not playing our sound. Notification sound was not defined in 10.7 so test for this too.
    if (![Preferences boolForKey:PREF_SOUND_TIMER_FINISH] && &NSUserNotificationDefaultSoundName)
        [notification setSoundName:NSUserNotificationDefaultSoundName];
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end

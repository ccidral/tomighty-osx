//
//  StatusItemManager.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 23/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "StatusIcon.h"
#import "ImageLoader.h"

@implementation StatusIcon {
    NSStatusItem *statusItem;
    NSImage *blackIcon;
    NSImage *whiteIcon;
    NSImage *redIcon;
    NSImage *greenIcon;
    NSImage *blueIcon;
}

- (id)initWithStatusMenu:(NSMenu *)statusMenu {
    self = [super init];

    if (self) {
        [self createIcons];
        [self createStatusItem:statusMenu];
    }

    return self;
}

- (void)createIcons {
    blackIcon = [ImageLoader loadIcon:@"status-normal"];
    whiteIcon = [ImageLoader loadIcon:@"status-white"];
    redIcon = [ImageLoader loadIcon:@"status-pomodoro"];
    greenIcon = [ImageLoader loadIcon:@"status-short-break"];
    blueIcon = [ImageLoader loadIcon:@"status-long-break"];
}

- (void)normal {
    [statusItem setImage:blackIcon];
}

- (void)pomodoro {
    [statusItem setImage:redIcon];
}

- (void)shortBreak {
    [statusItem setImage:greenIcon];
}

- (void)longBreak {
    [statusItem setImage:blueIcon];
}

- (void)createStatusItem:(NSMenu *)statusMenu {
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setHighlightMode:YES];
    [statusItem setImage:blackIcon];
    [statusItem setAlternateImage:whiteIcon];
    [statusItem setMenu:statusMenu];
}

- (void)setTitle:(NSString *)newTitle {
    [statusItem setTitle:newTitle];
}

@end

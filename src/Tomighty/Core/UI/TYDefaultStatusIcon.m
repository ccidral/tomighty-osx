//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import "TYDefaultStatusIcon.h"

NSString * const ICON_STATUS_IDLE = @"icon-status-idle";
NSString * const ICON_STATUS_POMODORO = @"icon-status-pomodoro";
NSString * const ICON_STATUS_SHORT_BREAK = @"icon-status-short-break";
NSString * const ICON_STATUS_LONG_BREAK = @"icon-status-long-break";
NSString * const ICON_STATUS_ALTERNATE = @"icon-status-alternate";

@implementation TYDefaultStatusIcon
{
    __strong NSStatusItem *statusItem;
    __strong NSMutableDictionary *iconImageCache;
    __strong TYImageLoader *imageLoader;
}

- (id)initWith:(NSMenu *)aMenu imageLoader:(TYImageLoader *)anImageLoader
{
    self = [super init];
    if(self)
    {
        imageLoader = anImageLoader;
        iconImageCache = [[NSMutableDictionary alloc] initWithCapacity:8];
        statusItem = [self createStatusItem:aMenu];
    }
    return self;
}

- (NSStatusItem *)createStatusItem:(NSMenu *)menu
{
    NSStatusItem *newStatusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
    
    [newStatusItem setHighlightMode:YES];
    [newStatusItem setImage:[self getIconImage:ICON_STATUS_IDLE]];
    [newStatusItem setAlternateImage:[self getIconImage:ICON_STATUS_ALTERNATE]];
    [newStatusItem setMenu:menu];
    [newStatusItem setTitle:@"00:00"];
    
    return newStatusItem;
}

- (void)setRemainingTimeText:(NSString *)text
{
    [statusItem setTitle:text];
}

- (void)changeIcon:(NSString *)iconName
{
    [statusItem setImage:[self getIconImage:iconName]];
}

- (NSImage *)getIconImage:(NSString *)iconName
{
    NSImage *image = [iconImageCache objectForKey:iconName];
    if(!image)
    {
        image = [imageLoader loadIcon:iconName];
        iconImageCache[iconName] = image;
    }
    
    image.template = YES;
    return image;
}

@end

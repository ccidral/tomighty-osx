//
//  Tomighty - http://www.tomighty.org
//
//  This software is licensed under the Apache License Version 2.0:
//  http://www.apache.org/licenses/LICENSE-2.0.txt
//

#import <Foundation/Foundation.h>

extern NSString * const ICON_STATUS_IDLE;
extern NSString * const ICON_STATUS_POMODORO;
extern NSString * const ICON_STATUS_SHORT_BREAK;
extern NSString * const ICON_STATUS_LONG_BREAK;

@protocol TYStatusIcon <NSObject>

- (void)changeIcon:(NSString *)iconName;
- (void)setRemainingTimeText:(NSString *)text;

@end

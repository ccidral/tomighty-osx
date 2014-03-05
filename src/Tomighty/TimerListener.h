//
//  TimerListener.h
//  Tomighty
//
//  Created by Célio Cidral Jr on 24/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerContext.h"

@protocol TimerListener <NSObject>

- (void)timerStarted:(NSInteger)secondsRemaining context:(TimerContext *)context;

- (void)timerStopped;

- (void)timerFinished:(TimerContext *)context;

- (void)timerTick:(NSInteger)secondsRemaining;

@end

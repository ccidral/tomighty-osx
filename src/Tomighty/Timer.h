//
//  Timer.h
//  Tomighty
//
//  Created by Célio Cidral Jr on 24/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TimerListener.h"

@class TimerContext;

@interface Timer : NSObject

@property(nonatomic, readonly) NSInteger secondsRemaining;
@property(nonatomic, readonly) TimerContext *context;

- (id)initWithListener:(id <TimerListener>)listener;

- (void)start:(NSInteger)minutes context:(TimerContext *)context;

- (void)stop;

@end

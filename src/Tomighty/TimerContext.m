//
//  TimerContext.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 29/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "TimerContext.h"

@implementation TimerContext

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

@end

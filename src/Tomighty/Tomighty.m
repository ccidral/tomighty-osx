//
//  Tomighty.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 29/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "Tomighty.h"

@implementation Tomighty

- (void)incrementPomodoroCount {
    _pomodoroCount++;

    // TODO : set this in preferences
    if (_pomodoroCount > 4) {
        _pomodoroCount = 1;
    }
}

- (void)resetPomodoroCount {
    _pomodoroCount = 0;
}

@end

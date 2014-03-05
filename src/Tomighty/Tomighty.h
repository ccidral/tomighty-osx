//
//  Tomighty.h
//  Tomighty
//
//  Created by Célio Cidral Jr on 29/07/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tomighty : NSObject

@property (nonatomic, readonly) NSInteger pomodoroCount;

- (void)incrementPomodoroCount;

- (void)resetPomodoroCount;

@end

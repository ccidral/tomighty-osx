//
//  ImageFactory.h
//  Tomighty
//
//  Created by Célio Cidral Jr on 05/11/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageLoader : NSObject

+ (NSImage *)loadIcon:(NSString *)name;

+ (NSImage *)loadTiffImage:(NSString *)name withSize:(int)size;

@end

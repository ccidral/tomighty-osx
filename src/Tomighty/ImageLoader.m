//
//  ImageFactory.m
//  Tomighty
//
//  Created by Célio Cidral Jr on 05/11/13.
//  Copyright (c) 2013 Célio Cidral Jr. All rights reserved.
//

#import "ImageLoader.h"

@implementation ImageLoader

int const ICON_SIZE = 16;

+ (NSImage *)loadIcon:(NSString *)name {
    return [self loadTiffImage:name withSize:ICON_SIZE];
}

+ (NSImage *)loadTiffImage:(NSString *)name withSize:(int)widthAndHeight {
    NSString *fileName = [NSString stringWithFormat:@"%@.tiff", name];
    NSImage *image = [NSImage imageNamed:fileName];

    NSSize size;
    size.width = widthAndHeight;
    size.height = widthAndHeight;

    [image setSize:size];

    return image;
}

@end

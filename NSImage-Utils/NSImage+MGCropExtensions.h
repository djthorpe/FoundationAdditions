//
//  NSImage+MGCropExtensions.h
//  ImageCropDemo
//
//  Created by Matt Gemmell on 16/03/2006.
//  Copyright 2006 Magic Aubergine. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (MGCropExtensions)

typedef enum {
    MGImageResizeCrop,
    MGImageResizeCropStart,
    MGImageResizeCropEnd,
    MGImageResizeScale
} MGImageResizingMethod;

-(NSImage *)imageToFitSize:(NSSize)size method:(MGImageResizingMethod)resizeMethod;
-(NSImage *)imageCroppedToFitSize:(NSSize)size;
-(NSImage *)imageScaledToFitSize:(NSSize)size;

@end

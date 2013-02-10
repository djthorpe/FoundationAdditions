//
//  NSImage+MGCropExtensions.m
//  ImageCropDemo
//
//  Created by Matt Gemmell on 16/03/2006.
//  Copyright 2006 Magic Aubergine. All rights reserved.
//

#import "NSImage+MGCropExtensions.h"

@implementation NSImage (MGCropExtensions)

- (NSImage *)imageToFitSize:(NSSize)size method:(MGImageResizingMethod)resizeMethod
{
    NSImage *result = [[NSImage alloc] initWithSize:size];
    float sourceWidth = [self size].width;
    float sourceHeight = [self size].height;
    float targetWidth = size.width;
    float targetHeight = size.height;
    BOOL cropping = !(resizeMethod == MGImageResizeScale);
    
    // Calculate aspect ratios
    float sourceRatio = sourceWidth / sourceHeight;
    float targetRatio = targetWidth / targetHeight;
    
    // Determine what side of the source image to use for proportional scaling
    BOOL scaleWidth = (sourceRatio <= targetRatio);
    // Deal with the case of just scaling proportionally to fit, without cropping
    scaleWidth = (cropping) ? scaleWidth : !scaleWidth;
    
    // Proportionally scale source image
    float scalingFactor, scaledWidth, scaledHeight;
    if (scaleWidth) {
        scalingFactor = 1.0 / sourceRatio;
        scaledWidth = targetWidth;
        scaledHeight = round(targetWidth * scalingFactor);
    } else {
        scalingFactor = sourceRatio;
        scaledWidth = round(targetHeight * scalingFactor);
        scaledHeight = targetHeight;
    }
    float scaleFactor = scaledHeight / sourceHeight;
    
    // Calculate compositing rectangles
    NSRect sourceRect, destRect;
    if (cropping) {
        destRect = NSMakeRect(0, 0, targetWidth, targetHeight);
        float destX, destY;
        if (resizeMethod == MGImageResizeCrop) {
            // Crop center
            destX = round((scaledWidth - targetWidth) / 2.0);
            destY = round((scaledHeight - targetHeight) / 2.0);
        } else if (resizeMethod == MGImageResizeCropStart) {
            // Crop top or left (prefer top)
            if (scaleWidth) {
		// Crop top
		destX = round((scaledWidth - targetWidth) / 2.0);
		destY = round(scaledHeight - targetHeight);
            } else {
		// Crop left
                destX = 0.0;
		destY = round((scaledHeight - targetHeight) / 2.0);
            }
        } else if (resizeMethod == MGImageResizeCropEnd) {
            // Crop bottom or right
            if (scaleWidth) {
		// Crop bottom
		destX = 0.0;
		destY = 0.0;
            } else {
		// Crop right
		destX = round(scaledWidth - targetWidth);
		destY = round((scaledHeight - targetHeight) / 2.0);
            }
        }
        sourceRect = NSMakeRect(destX / scaleFactor, destY / scaleFactor, 
                                targetWidth / scaleFactor, targetHeight / scaleFactor);
    } else {
        sourceRect = NSMakeRect(0, 0, sourceWidth, sourceHeight);
        destRect = NSMakeRect((targetWidth - scaledWidth) / 2.0, 
                              (targetHeight - scaledHeight) / 2.0, 
                              scaledWidth, scaledHeight);
    }
    
    // Composite image appropriately
    [result lockFocus];
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationHigh];
    [self drawInRect:destRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:1.0];
    [result unlockFocus];
    
    return [result autorelease];
}

- (NSImage *)imageCroppedToFitSize:(NSSize)size
{
    return [self imageToFitSize:size method:MGImageResizeCrop];
}

- (NSImage *)imageScaledToFitSize:(NSSize)size
{
    return [self imageToFitSize:size method:MGImageResizeScale];
}

@end

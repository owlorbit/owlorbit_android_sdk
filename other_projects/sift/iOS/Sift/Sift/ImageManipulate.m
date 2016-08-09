//
//  ImageManipulate.m
//  Owl Orbit
//
//  Created by Timmy Nguyen on 2/20/16.
//  Copyright © 2016 Tim Nuwin. All rights reserved.
//

#import "ImageManipulate.h"

@implementation ImageManipulate


+ (UIImage *)addBorderToImage:(UIImage *)image {
    CGImageRef bgimage = [image CGImage];
    float width = CGImageGetWidth(bgimage);
    float height = CGImageGetHeight(bgimage);
    
    // Create a temporary texture data buffer
    void *data = malloc(width * height * 4);
    
    // Draw image to buffer
    CGContextRef ctx = CGBitmapContextCreate(data,
                                             width,
                                             height,
                                             8,
                                             width * 4,
                                             CGImageGetColorSpace(image.CGImage),
                                             kCGImageAlphaPremultipliedLast);
    CGContextDrawImage(ctx, CGRectMake(0, 0, (CGFloat)width, (CGFloat)height), bgimage);
    
    //Set the stroke (pen) color
    

    CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
    
    //Set the width of the pen mark
    CGFloat borderWidth = (float)width*0.35;
    CGContextSetLineWidth(ctx, borderWidth);
    
    //Start at 0,0 and draw a square
    CGContextMoveToPoint(ctx, 0.0, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, height);
    CGContextAddLineToPoint(ctx, width, height);
    CGContextAddLineToPoint(ctx, width, 0.0);
    CGContextAddLineToPoint(ctx, 0.0, 0.0);
    
    //Draw it
    CGContextStrokePath(ctx);
    
    // write it to a new image
    CGImageRef cgimage = CGBitmapContextCreateImage(ctx);
    UIImage *newImage = [UIImage imageWithCGImage:cgimage];
    CFRelease(cgimage);
    CGContextRelease(ctx);
    
    // auto-released
    return newImage;
}

@end

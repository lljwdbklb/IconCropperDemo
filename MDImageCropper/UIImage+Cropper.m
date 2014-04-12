//
//  UIImage+Cropper.m
//  IconCropperDemo
//
//  Created by Jun on 14-4-12.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "UIImage+Cropper.h"

@implementation UIImage (Cropper)
- (UIImage *)croperImageWithCropperFrame:(CGRect)cropperFrame latestFrame:(CGRect)latestFrame{
    CGRect squareFrame = cropperFrame;
    CGFloat scaleRatio = latestFrame.size.width / self.size.width;
    CGFloat x = (squareFrame.origin.x - latestFrame.origin.x) / scaleRatio;
    CGFloat y = (squareFrame.origin.y - latestFrame.origin.y) / scaleRatio;
    CGFloat w = squareFrame.size.width / scaleRatio;
    CGFloat h = squareFrame.size.width / scaleRatio;
    if (latestFrame.size.width < cropperFrame.size.width) {
        CGFloat newW = self.size.width;
        CGFloat newH = newW * (cropperFrame.size.height / cropperFrame.size.width);
        x = 0;
        y = y + (h - newH) / 2;
        w = newH;
        h = newH;
    }
    if (latestFrame.size.height < cropperFrame.size.height) {
        CGFloat newH = self.size.height;
        CGFloat newW = newH * (cropperFrame.size.width / cropperFrame.size.height);
        x = x + (w - newW) / 2;
        y = 0;
        w = newH;
        h = newH;
    }
    CGRect myImageRect = CGRectMake(x, y, w, h);
    CGImageRef imageRef = self.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, myImageRect);
    CGSize size;
    size.width = myImageRect.size.width;
    size.height = myImageRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, myImageRect, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}
@end

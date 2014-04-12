//
//  UIView+Copper.m
//  IconCropperDemo
//
//  Created by Jun on 14-4-12.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "UIView+Cropper.h"

@implementation UIView (Cropper)
- (void)cropperWithFrame:(CGRect)copperFrame
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        copperFrame.origin.x,
                                        self.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        copperFrame.origin.x + copperFrame.size.width,
                                        0,
                                        self.frame.size.width - copperFrame.origin.x - copperFrame.size.width,
                                        self.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.frame.size.width,
                                        copperFrame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        copperFrame.origin.y + copperFrame.size.height,
                                        self.frame.size.width,
                                        self.frame.size.height - copperFrame.origin.y + copperFrame.size.height));
    maskLayer.path = path;
    self.layer.mask = maskLayer;
    CGPathRelease(path);
}

@end

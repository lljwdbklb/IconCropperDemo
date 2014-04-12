//
//  UIImage+Cropper.h
//  IconCropperDemo
//
//  Created by Jun on 14-4-12.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Cropper)
- (UIImage *)croperImageWithCropperFrame:(CGRect)cropperFrame latestFrame:(CGRect)latestFrame;
@end

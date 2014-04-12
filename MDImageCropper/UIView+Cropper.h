//
//  UIView+Copper.h
//  IconCropperDemo
//
//  Created by Jun on 14-4-12.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Cropper)
/**
 *  剪裁
 *
 *  @param copperFrame 在视图中剪裁的位置
 */
- (void)cropperWithFrame:(CGRect)copperFrame;
@end

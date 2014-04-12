//
//  MDCropTool.h
//  IconCropperDemo
//
//  Created by Jun on 14-4-12.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MDCropTool;

@protocol MDCropToolDelegate <NSObject>

- (void)cropTool:(MDCropTool *)cropTool clickedButtonAtIndex:(NSInteger)index;

@end

@interface MDCropTool : UIView
@property (weak, nonatomic)UIView *view;
@property (weak, nonatomic)id<MDCropToolDelegate> delegate;
@end

//
//  MDIconCropperController.h
//  IconCropperDemo
//
//  Created by Jun on 14-4-12.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MDIconCropperController;

@protocol MDIconCropperControllerDelegate <NSObject>

- (void)iconCropper:(MDIconCropperController *)iconCropper didFinished:(UIImage *)editedImage;

- (void)iconCropperDidCancel:(MDIconCropperController *)iconCropper;

@end

@interface MDIconCropperController : UIViewController

@property (weak, nonatomic)UIImage *image;
@property (assign, nonatomic)CGSize size;
@property (weak, nonatomic) id<MDIconCropperControllerDelegate> delegate;
- (id)initWithCopperImage:(UIImage *)image size:(CGSize)size;
@end

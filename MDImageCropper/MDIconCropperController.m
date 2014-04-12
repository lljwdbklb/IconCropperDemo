//
//  MDIconCropperController.m
//  IconCropperDemo
//
//  Created by Jun on 14-4-12.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "MDIconCropperController.h"

#import "UIView+Cropper.h"
#import "UIImage+Cropper.h"

#import "MDCropTool.h"
#import "UIImage+Ljj.h"

#define SCALE_FRAME_Y 100.0f
#define BOUNDCE_DURATION 0.3f

@interface MDIconCropperController () <MDCropToolDelegate>
{
    UIView *_overlayView;
    UIView *_ratioView;
    
    CGRect _cropperFrame;
    CGRect _oldFrame;
    CGRect _latestFrame;
    CGRect _largeFrame;
}
@property (weak, nonatomic) UIImageView *showImageView;
@end

@implementation MDIconCropperController

- (id)initWithCopperImage:(UIImage *)image size:(CGSize)size {
    if (self = [super init]) {
        self.image = image;
        self.size = size;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setupFrame];
    [self setupView];
}

#pragma mark - private

- (void)setupFrame {
    _cropperFrame = CGRectMake(0, self.view.center.y-self.view.frame.size.width/2, self.view.frame.size.width, self.view.frame.size.width);
    
    CGFloat oriWidth = _cropperFrame.size.width;
    CGFloat oriHeight = self.image.size.height * (oriWidth / self.image.size.width);
    CGFloat oriX = 0 + (_cropperFrame.size.width - oriWidth) / 2;
    CGFloat oriY = _cropperFrame.origin.y + (_cropperFrame.size.height - oriHeight) / 2;
    _oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    _latestFrame = _oldFrame;
    
    _largeFrame = CGRectMake(0, 0, 3.0 * _oldFrame.size.width, 3.0 * _oldFrame.size.height);
}
- (void)setupView {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [imageView setMultipleTouchEnabled:YES];
    [imageView setImage:self.image];
    [imageView setUserInteractionEnabled:YES];
    [self.view addSubview:imageView];
    self.showImageView = imageView;
    
    [self addGestureRecognizers];
    self.showImageView.frame = _oldFrame;
    
    _overlayView = [[UIView alloc] initWithFrame:self.view.bounds];
    _overlayView.alpha = .5f;
    _overlayView.backgroundColor = [UIColor blackColor];
    _overlayView.userInteractionEnabled = NO;
    _overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_overlayView];
    
    _ratioView = [[UIView alloc] initWithFrame:_cropperFrame];
    _ratioView.layer.borderColor = [UIColor yellowColor].CGColor;
    _ratioView.layer.borderWidth = 1.0f;
    _ratioView.autoresizingMask = UIViewAutoresizingNone;
    [self.view addSubview:_ratioView];
    
//    [self overlayClipping];
    [_overlayView cropperWithFrame:_ratioView.frame];
    
    
    MDCropTool *tool = [[MDCropTool alloc]init];
    [tool setView:self.view];
    [tool setDelegate:self];
    [self.view addSubview:tool];
}

- (void) addGestureRecognizers
{
    // add pinch gesture
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    // add pan gesture
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
}
// pinch gesture handler
- (void) pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImageView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGRect newFrame = self.showImageView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImageView.frame = newFrame;
            _latestFrame = newFrame;
        }];
    }
}

// pan gesture handler
- (void) panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImageView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        // calculate accelerator
        CGFloat absCenterX = _cropperFrame.origin.x + _cropperFrame.size.width / 2;
        CGFloat absCenterY = _cropperFrame.origin.y + _cropperFrame.size.height / 2;
        CGFloat scaleRatio = self.showImageView.frame.size.width / _cropperFrame.size.width;
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        // bounce to original frame
        CGRect newFrame = self.showImageView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImageView.frame = newFrame;
            _latestFrame = newFrame;
        }];
    }
}

- (CGRect)handleScaleOverflow:(CGRect)newFrame {
    // bounce to original frame
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width/2, newFrame.origin.y + newFrame.size.height/2);
    if (newFrame.size.width < _oldFrame.size.width) {
        newFrame = _oldFrame;
    }
    if (newFrame.size.width > _largeFrame.size.width) {
        newFrame = _largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width/2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height/2;
    return newFrame;
}

- (CGRect)handleBorderOverflow:(CGRect)newFrame {
    // horizontally
    if (newFrame.origin.x > _cropperFrame.origin.x) newFrame.origin.x = _cropperFrame.origin.x;
    if (CGRectGetMaxX(newFrame) < _cropperFrame.size.width) newFrame.origin.x = _cropperFrame.size.width - newFrame.size.width;
    // vertically
    if (newFrame.origin.y > _cropperFrame.origin.y) newFrame.origin.y = _cropperFrame.origin.y;
    if (CGRectGetMaxY(newFrame) < _cropperFrame.origin.y + _cropperFrame.size.height) {
        newFrame.origin.y = _cropperFrame.origin.y + _cropperFrame.size.height - newFrame.size.height;
    }
    // adapt horizontally rectangle
    if (self.showImageView.frame.size.width > self.showImageView.frame.size.height && newFrame.size.height <= _cropperFrame.size.height) {
        newFrame.origin.y = _cropperFrame.origin.y + (_cropperFrame.size.height - newFrame.size.height) / 2;
    }
    return newFrame;
}


#pragma mark - cropTool delegate
- (void)cropTool:(MDCropTool *)cropTool clickedButtonAtIndex:(NSInteger)index {
    if (index) {
        if ([self.delegate respondsToSelector:@selector(iconCropper:didFinished:)]) {
            UIImage *image =[[self.image croperImageWithCropperFrame:_cropperFrame latestFrame:_latestFrame] imageScaledToSize:self.size];;
//            image.size = self.size;
            [self.delegate iconCropper:self didFinished:image];
        }
    } else {
        if ([self.delegate respondsToSelector:@selector(iconCropperDidCancel:)]) {
            [self.delegate iconCropperDidCancel:self];
        }
    }
}

@end

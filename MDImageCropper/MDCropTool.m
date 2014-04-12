//
//  MDCropTool.m
//  IconCropperDemo
//
//  Created by Jun on 14-4-12.
//  Copyright (c) 2014年 Jun. All rights reserved.
//

#import "MDCropTool.h"

@interface MDCropTool ()
{
    UIView *_coverView;
    UIView *_contentView;
    
    NSArray *_items;
}

@end

@implementation MDCropTool

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupView];
    }
    return self;
}

- (void)setupView {
    _coverView = [[UIView alloc]initWithFrame:self.bounds];
    [_coverView setBackgroundColor:[UIColor blackColor]];
    _coverView.alpha = 0.5;
    [_coverView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self addSubview:_coverView];
    
    _contentView = [[UIView alloc]initWithFrame:self.bounds];
    [_contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self addSubview:_contentView];
    
    NSArray *titles = @[@"取消",@"选取"];
    
//    UIButton *cancel = [[UIButton alloc]init];
//    [cancel setTitle:@"取消" forState:UIControlStateNormal];
//    [_contentView addSubview:cancel];
//    
//    UIButton *done = [[UIButton alloc]init];
//    [done setTitle:@"选取" forState:UIControlStateNormal];
//    [_contentView addSubview:done];
    NSMutableArray * arrayM = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = idx;
        [_contentView addSubview:btn];
        [arrayM addObject:btn];
    }];
    _items = arrayM;
}
- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self autoSubsLayout];
}

- (void)setView:(UIView *)view {
    _view = view;
    CGFloat w = view.frame.size.width;
    CGFloat h = 44;
    CGFloat y = view.frame.size.height - h;
    CGFloat x = 0;
    self.frame = CGRectMake(x, y, w, h);
}

- (void)autoSubsLayout {
    int count = _items.count;
    [_items enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat w = self.frame.size.width / count;
        CGFloat h = self.frame.size.height;
        CGFloat y = 0;
        CGFloat x = idx * w;
        [obj setFrame:CGRectMake(x, y, w, h)];
    }];
}

#pragma mark - button target
- (void)clickBtn:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(cropTool:clickedButtonAtIndex:)]) {
        [self.delegate cropTool:self clickedButtonAtIndex:btn.tag];
    }
}


@end

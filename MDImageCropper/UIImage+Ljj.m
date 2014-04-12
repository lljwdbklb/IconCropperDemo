//
//  UIImage+Ljj.m
//  WeiBo
//
//  Created by Jun on 13-10-31.
//  Copyright (c) 2013年 Jun. All rights reserved.
//

#import "UIImage+Ljj.h"


@implementation UIImage (Ljj)

+(id)resizingImageWithNamed:(NSString *)named {
    return [self resizingImageWithNamed:named xPic:0.5 yPic:0.5];
}

+(id)resizingImageWithNamed:(NSString *)named xPic:(CGFloat)xPic yPic:(CGFloat)yPic{
    UIImage *image = [UIImage imageNamed:named];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * xPic topCapHeight:image.size.height * yPic];
    return image;
}

- (UIImage *)imageScaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}
@end

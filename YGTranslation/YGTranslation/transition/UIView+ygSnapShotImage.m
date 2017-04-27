//
//  UIView+ygSnapShotImage.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/27.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "UIView+ygSnapShotImage.h"

@implementation UIView (ygSnapShotImage)


- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

- (UIImage *)contentImage{
    return [UIImage imageWithCGImage:(__bridge CGImageRef)self.layer.contents];
}

- (void)setContentImage:(UIImage *)contentImage{
    self.layer.contents = (__bridge id)contentImage.CGImage;;
}

@end

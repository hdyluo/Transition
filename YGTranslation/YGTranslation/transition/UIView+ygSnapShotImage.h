//
//  UIView+ygSnapShotImage.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/27.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ygSnapShotImage)

@property (nonatomic, readonly) UIImage * snapshotImage;
@property (nonatomic, strong) UIImage * contentImage;

@end

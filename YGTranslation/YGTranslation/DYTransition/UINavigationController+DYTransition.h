//
//  UINavigationController+DYTransition.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/27.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYTransition.h"

@interface UINavigationController (DYTransition)

- (void)dy_add_custom_transition;           //添加自定义转场，全局的

- (void)dy_hideNavigationBarBackground;     //隐藏毛玻璃背景,全局的

- (void)dy_hideNavigationItem;              //隐藏navigationItem，全局的

- (UIView *)_dy_item_contentView;

- (UIView *)_dy_navBar_backgroundView;

@end

@interface UIViewController (_DYCustomNavigationItem)

@property (nonatomic,strong) UIView * dy_navigationItemView;

@end






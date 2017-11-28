//
//  UINavigationController+DYTransition.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/27.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYTransition.h"
#import "DYCustomNavigationItem.h"

@interface UINavigationController (DYTransition)

- (void)dy_add_custom_transition;           //添加自定义转场，全局的

- (void)dy_UseCustomNavigationItem;         //使用自定义导航item

@end

@interface UIViewController (_DYCustomNavigationItem)

@property (nonatomic,strong) DYCustomNavigationItem * dy_navigationItemView;

@end







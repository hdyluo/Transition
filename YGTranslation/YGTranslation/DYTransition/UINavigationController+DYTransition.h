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

- (void)dy_add_custom_transition;

- (void)hideNavigationBar;

- (void)dy_addTransition:(DYTransition *)transition;

@end



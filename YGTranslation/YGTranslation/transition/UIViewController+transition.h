//
//  UIViewController+transition.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/29.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGTransition.h"

@interface UIViewController (transition)

/**
 自定义modal转场

 @param controller 下级页面
 @param transition 转场对象
 */
- (void)yg_presentViewController:(UIViewController *)controller withTransition:(YGTransition *)transition;

/**
 添加去向交互转场

 @param interactor 交互对象
 @param block 页面跳转方式回调
 */
- (void)yg_addToInteractor:(YGInteractor *)interactor action:(void(^)())block;

/**
 添加返回交互转场

 @param interactor 交互对象
 @param block 页面跳转方式回调
 */
- (void)yg_addBackInteractor:(YGInteractor *)interactor action:(void(^)())block;

/**
 自定义navigation转场

 @param vc 下级页面
 @param trnasition 转场对象
 */
- (void)yg_pushViewController:(UIViewController *)vc withTransition:(YGTransition *)trnasition;

@end

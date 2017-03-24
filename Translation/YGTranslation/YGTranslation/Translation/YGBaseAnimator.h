//
//  YGBaseAnimator.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGBaseInteractor.h"

@interface YGBaseAnimator : NSObject<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate,UITabBarControllerDelegate,YGInteractorDelegate>


/**
 进入下级页面的时间
 */
@property (nonatomic,assign) NSTimeInterval toDuration;

/**
 返回上级页面的时间
 */
@property (nonatomic,assign) NSTimeInterval backDuration;

/**
 有些转场动画在手势驱动的情况下松开手指时没有动画过渡，可以用timer控制
 */
@property (nonatomic,assign) BOOL needInteractiveTimer;


/**
 *  配置To过程动画(push, present),自定义转场动画应该复写该方法
 */
- (void)yg_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;
/**
 *  配置back过程动画（pop, dismiss）,自定义转场动画应该复写该方法
 */
- (void)yg_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext;

@end

//
//  UINavigationController+DYTransition.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/27.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "UINavigationController+DYTransition.h"
#import <objc/runtime.h>

#define DY_NAV_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define DY_NAV_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@implementation UINavigationController (DYTransition)



const char * dy_nav_transition_key;
- (void)dy_add_custom_transition{
    DYTransition * transition = [[DYTransition alloc] init];
    //可恶的iOS11改了转场的默认实现，不能用transform了
    transition.toAnimator = [[DYTransitionAnimator alloc] init];
    transition.toAnimator.timeInterval = .3;
    __weak typeof(transition) weakTransition = transition;
    transition.toAnimator.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        DY_GENERATE_TRANSITION_CONTEXT
        [containView addSubview:toVC.view];
        toVC.view.frame = CGRectMake(DY_NAV_SCREEN_WIDTH, 0, toVC.view.frame.size.width, toVC.view.frame.size.height);
        [UIView animateWithDuration:weakTransition.toAnimator.timeInterval animations:^{
            fromVC.view.frame = CGRectMake(-DY_NAV_SCREEN_WIDTH * .35, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
            toVC.view.frame = CGRectMake(0, 0, toVC.view.frame.size.width, toVC.view.frame.size.height);
        } completion:^(BOOL finished) {
            [context completeTransition:![context transitionWasCancelled]];
        }];
    };
    
    transition.backAnimator = [[DYTransitionAnimator alloc] init];
    transition.backAnimator.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        DY_GENERATE_TRANSITION_CONTEXT
        [containView insertSubview:toVC.view belowSubview:fromVC.view];
        toVC.view.transform = CGAffineTransformMakeTranslation(-DY_NAV_SCREEN_WIDTH * .35, 0);
        UIView * extraView = [UIView new];
        extraView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
        extraView.frame = containView.frame;
        [containView insertSubview:extraView belowSubview:fromVC.view];
        
        UIView * shadowView = [UIView new];
        shadowView.backgroundColor = [UIColor whiteColor];
        shadowView.frame = fromVC.view.frame;
        [containView insertSubview:shadowView belowSubview:fromVC.view];
        shadowView.layer.shadowOpacity = 0.3;
        shadowView.layer.shadowRadius = 4;
        shadowView.layer.shadowOffset = CGSizeMake(-5, 5);
        shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        
        
        [UIView animateWithDuration:.5 animations:^{
            fromVC.view.frame = CGRectMake(DY_NAV_SCREEN_WIDTH, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
            shadowView.frame = fromVC.view.frame;
            toVC.view.transform = CGAffineTransformIdentity;
            extraView.alpha = 0;
        } completion:^(BOOL finished) {
            [shadowView removeFromSuperview];
            [extraView removeFromSuperview];
            BOOL isCanceled = [context transitionWasCancelled];
            [context completeTransition:!isCanceled];
            if (isCanceled) {
                toVC.view.transform = CGAffineTransformIdentity;
                [toVC.view removeFromSuperview];
               
            }
        }];
    };
    transition.backInteractor = [[DYTransitionInteractor alloc] initWithDirection:DYInteractorDirectionRight];
    transition.backInteractor.speedControl = 1.3;                   //手势1cm 页面1.3cm
    transition.backInteractor.edgeSpacing = DY_NAV_SCREEN_WIDTH;    //全屏侧滑
    transition.backInteractor.canOverPercent = .4;                  //滑动百分比是 %40就可以完成转场，默认情况下，滑动速率超过1000也会完成转场
    
    __weak typeof(self) weakSelf = self;
    transition.backInteractor.transitionAction = ^{
        NSLog(@"返回");
        if (self.viewControllers.count > 1) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf popViewControllerAnimated:YES];
        }
    };
    
    [self.view addGestureRecognizer:transition.backInteractor.panGesture];
    [self.interactivePopGestureRecognizer requireGestureRecognizerToFail:transition.backInteractor.panGesture];
    self.delegate = transition;
    objc_setAssociatedObject(self, &dy_nav_transition_key, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)hideNavigationBar{
    self.navigationBar.hidden = YES;
}

- (void)dy_addTransition:(DYTransition *)transition{
    
}

@end



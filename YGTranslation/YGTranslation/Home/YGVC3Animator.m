//
//  YGVC3Animator.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/27.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "YGVC3Animator.h"

@implementation YGVC3Animator

- (instancetype)initWithType:(NSInteger)type{
    if (self = [super init]) {
        self.timeInterval = .5;
        if (type == 0) {
            [self addToAnimator];
        }else{
            [self addBackAnimator];
        }
    }
    return self;
}


- (void)addToAnimator{
    __weak typeof(self) weakSelf = self;
    self.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        UIViewController * fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController * toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView * containView = [context containerView];
        [containView addSubview:toVC.view];
        toVC.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
        [UIView animateWithDuration:.3 animations:^{
            fromVC.view.transform = CGAffineTransformMakeTranslation(-100, 0);
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
             [context completeTransition:![context transitionWasCancelled]];
        }];
    };
}

- (void)addBackAnimator{
    __weak typeof(self) weakSelf = self;
    self.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        UIViewController * fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController * toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView * containView = [context containerView];
       // [containView addSubview:toVC.view];                             //对于fullscreenmodal转场来说，转场开始tovc.view会自动加入到containView中，对于Navigation转场来说，需要手动加入
        [containView insertSubview:toVC.view belowSubview:fromVC.view];
        [UIView animateWithDuration:weakSelf.timeInterval animations:^{
            fromVC.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            BOOL isCanceled = [context transitionWasCancelled];
            [context completeTransition:!isCanceled];
            if (isCanceled) {
                [toVC.view removeFromSuperview];
            }
        }];
    };
}

@end

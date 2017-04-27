//
//  YGVC1Animator.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/26.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "YGVC1Animator.h"

@implementation YGVC1Animator


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
        toVC.view.transform = CGAffineTransformMakeTranslation(fromVC.view.frame.size.width, 0);
        [UIView animateWithDuration:weakSelf.timeInterval animations:^{
            fromVC.view.transform = CGAffineTransformMakeTranslation(-[UIScreen mainScreen].bounds.size.width, 0);
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
        [containView addSubview:toVC.view];
        [UIView animateWithDuration:weakSelf.timeInterval animations:^{
            fromVC.view.transform = CGAffineTransformMakeTranslation([UIScreen mainScreen].bounds.size.width, 0);
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
                       [context completeTransition:![context transitionWasCancelled]];
        }];
    };
}


@end

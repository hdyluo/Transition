//
//  YGVC1Animator.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/26.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "YGVC1Animator.h"
#import "UIView+Snapshot.h"

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
        toVC.view.transform = CGAffineTransformMakeTranslation(-200, 0);
        UIImage * snapShot = [fromVC.view snapshotImage];
        UIView * extraView = [[UIImageView alloc] initWithImage:snapShot];
        extraView.frame = CGRectMake(200, 0, snapShot.size.width, snapShot.size.height);
        [toVC.view addSubview:extraView];
        [UIView animateWithDuration:weakSelf.timeInterval animations:^{
            fromVC.view.transform = CGAffineTransformMakeTranslation(200, 0);
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
            fromVC.view.transform = CGAffineTransformMakeTranslation(-200, 0);
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

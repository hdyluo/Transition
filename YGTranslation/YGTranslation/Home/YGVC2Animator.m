//
//  YGVC2Animator.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/27.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "YGVC2Animator.h"
#import "UIView+Snapshot.h"

@implementation YGVC2Animator

- (instancetype)initWithType:(NSInteger)type{
    if (self = [super init]) {
        self.timeInterval = .8;
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
        UIImage * snapShot = [fromVC.view snapshotImage];
        UIView * extraView = [[UIImageView alloc] initWithImage:snapShot];
        extraView.frame = fromVC.view.bounds;
        [containView insertSubview:extraView belowSubview:toVC.view];
        
        UIView * backgroundView = [[UIView alloc] init];
        backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        backgroundView.frame = fromVC.view.bounds;
        backgroundView.tag = 100;
        [containView insertSubview:backgroundView aboveSubview:extraView];
        
        toVC.view.frame = CGRectMake(0, 0, 300, 200);
        toVC.view.center = containView.center;
        
       // containView.alpha = 0;
        toVC.view.transform = CGAffineTransformMakeScale(.6, .6);
        toVC.view.alpha = 0;
        backgroundView.alpha = 0;
        [UIView animateWithDuration:weakSelf.timeInterval delay:0 usingSpringWithDamping:.6 initialSpringVelocity:.2 options:UIViewAnimationOptionCurveLinear animations:^{
            toVC.view.transform = CGAffineTransformIdentity;
            toVC.view.alpha = 1;
            backgroundView.alpha = 1;
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
        //[containView addSubview:toVC.view];
        [containView insertSubview:toVC.view atIndex:0];
        __block UIView * bgView = nil;
        [containView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.tag == 100) {
                bgView = obj;
                *stop = YES;
            }
        }];
        [UIView animateWithDuration:.3 animations:^{
            fromVC.view.alpha = 0;
            bgView.alpha = 0;
            fromVC.view.transform = CGAffineTransformMakeScale(.8, .8);
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

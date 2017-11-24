//
//  DYVC1.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/24.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYVC1.h"
#import "UIViewController+DYTransition.h"

@interface DYVC1 ()


@end

@implementation DYVC1

- (void)dealloc{
    NSLog(@"%@释放",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    [self addBackAction];
}

- (void)addBackAction{
    DYTransitionAnimator * animator = [[DYTransitionAnimator alloc] init];
    animator.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        UIViewController * fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController * toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView * containView = [context containerView];
        [containView addSubview:toVC.view];                             //对于fullscreenmodal转场来说，转场开始tovc.view会自动加入到containView中，对于Navigation转场来说，需要手动加入
        [UIView animateWithDuration:.5 animations:^{
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
    DYTransitionInteractor * interactor = [[DYTransitionInteractor alloc] initWithDirection:DYInteractorDirectionLeft];
    __weak typeof(self) weakSelf = self;
    interactor.transitionAction = ^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    };
    [self dy_setBackAnimator:animator interactor:interactor WithType:DYTransitionTypeDismiss];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

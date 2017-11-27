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



@implementation UIViewController  (_DYCustomNavigationItem)

const char * dy_nav_custom_item_key;
- (void)setDy_navigationItemView:(UIView *)dy_navigationItemView{
    objc_setAssociatedObject(self, &dy_nav_custom_item_key, dy_navigationItemView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIView * barBackgroundView = [self.navigationController _dy_navBar_backgroundView];
//    UIView * itemView = [self.navigationController _dy_item_contentView];
    if (barBackgroundView) {
        dy_navigationItemView.frame = barBackgroundView.bounds;         //第一次初始化的时候，这个frame不正确，所以需要添加自动布局，让它和background重合
        [barBackgroundView addSubview:dy_navigationItemView];
    }
}

- (UIView *)dy_navigationItemView{
    return objc_getAssociatedObject(self, &dy_nav_custom_item_key);
}

- (void)dy_addCustomItem:(UIView *)itemView{
    self.dy_navigationItemView = itemView;
}

@end




@implementation UINavigationController (DYTransition)

const char * dy_nav_transition_key;
- (void)dy_add_custom_transition{
    DYTransition * transition = [[DYTransition alloc] init];
    transition.toAnimator = [[DYTransitionAnimator alloc] init];
    transition.toAnimator.timeInterval = .3;
    __weak typeof(transition) weakTransition = transition;
    transition.toAnimator.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        DY_GENERATE_TRANSITION_CONTEXT
        [containView addSubview:toVC.view];
        toVC.view.frame = CGRectMake(DY_NAV_SCREEN_WIDTH, 0, toVC.view.frame.size.width, toVC.view.frame.size.height);
        [UIView animateWithDuration:weakTransition.toAnimator.timeInterval animations:^{
            fromVC.view.frame = CGRectMake(-DY_NAV_SCREEN_WIDTH * .35, fromVC.view.frame.origin.y, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
            toVC.view.frame = CGRectMake(0, toVC.view.frame.origin.y, toVC.view.frame.size.width, toVC.view.frame.size.height);
            if (fromVC.dy_navigationItemView) {
//                fromVC.dy_navigationItemView.frame =
            }
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
            fromVC.view.frame = CGRectMake(DY_NAV_SCREEN_WIDTH, fromVC.view.frame.origin.y, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
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
    transition.backInteractor.speedControl = 1.3;                   //手势滑动1cm 页面滑动1.3cm
    transition.backInteractor.edgeSpacing = DY_NAV_SCREEN_WIDTH;    //全屏侧滑
    transition.backInteractor.canOverPercent = .4;                  //滑动百分比是 %40就可以完成转场，默认情况下，滑动速率超过1000也会完成转场
    
    __weak typeof(self) weakSelf = self;
    transition.backInteractor.transitionAction = ^{
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

- (void)dy_hideNavigationBarBackground{
    UIView * barBackground = [self _dy_navBar_backgroundView];
    [barBackground.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj_1, NSUInteger idx_1, BOOL * _Nonnull stop_1) {
        obj_1.hidden = YES;
    }];
}

- (void)dy_hideNavigationItem{
    [self _dy_item_contentView].hidden = YES;
}

- (void)dy_addCustomNavigationItem:(UIView *)itemView keepSystemItems:(BOOL)needKeepSysItems{
     UIView * barBackgroundView = [self _dy_navBar_backgroundView];
    if (barBackgroundView) {
        if (needKeepSysItems) {
            itemView.frame = barBackgroundView.bounds;
            [barBackgroundView addSubview:itemView];
        }else{
             itemView.frame = barBackgroundView.frame;
            [self.navigationBar addSubview:itemView];
        }
        
    }
}


- (UIView *)_dy_item_contentView{
    __block UIView * itemContentView = nil;
    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"_UINavigationBarContentView"]) {
            itemContentView = obj;
            * stop = YES;
        }
    }];
    return itemContentView;
}

- (UIView *)_dy_navBar_backgroundView{
    __block UIView * barBackgroundView = nil;
    [self.navigationBar.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([NSStringFromClass([obj class]) isEqualToString:@"_UIBarBackground"]) {
            barBackgroundView = obj;
            * stop = YES;
        }
    }];
    return barBackgroundView;
}


@end




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

// 判断是否是iPhone X
#define DY_IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define DY_STATUS_BAR_HEIGHT (DY_IS_iPhoneX ? 44.f : 20.f)
// 导航栏高度
#define DY_NAVIGATION_BAR_HEIGHT (DY_IS_iPhoneX ? 88.f : 64.f)
// tabBar高度
#define DY_TAB_BAR_HEIGHT (DY_IS_iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define DY_HOME_INDICATOR_HEIGHT (DY_IS_iPhoneX ? 34.f : 0.f)


@implementation UIViewController  (_DYCustomNavigationItem)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method sourceMethod = class_getInstanceMethod(self, @selector(viewWillLayoutSubviews));
        Method targetMethod = class_getInstanceMethod(self, @selector(dy_viewWillLayoutSubviews));
        method_exchangeImplementations(sourceMethod, targetMethod);
        
        Method sourceSetTitleMethod = class_getInstanceMethod(self, @selector(setTitle:));
        Method targetSetTitleMethod = class_getInstanceMethod(self, @selector(dy_setTitle:));
        method_exchangeImplementations(sourceSetTitleMethod, targetSetTitleMethod);
        
    });
}

- (void)dy_viewWillLayoutSubviews{
    if (self.dy_navigationItemView) {
        [self.view bringSubviewToFront:self.dy_navigationItemView];
    }
    [self dy_viewWillLayoutSubviews];
}

- (void)dy_setTitle:(NSString *)title{
    [self dy_setTitle:title];
}

const char * dy_nav_custom_item_key;
- (void)setDy_navigationItemView:(UIView *)dy_navigationItemView{
    UIView * lastView =  objc_getAssociatedObject(self, &dy_nav_custom_item_key);
    if (lastView) {
        [lastView removeFromSuperview];
    }
    objc_setAssociatedObject(self, &dy_nav_custom_item_key, dy_navigationItemView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    dy_navigationItemView.frame = CGRectMake(0, 0, DY_NAV_SCREEN_WIDTH, DY_NAVIGATION_BAR_HEIGHT);
    [self.view addSubview:dy_navigationItemView];
}

- (UIView *)dy_navigationItemView{
    return objc_getAssociatedObject(self, &dy_nav_custom_item_key);
}


@end




@implementation UINavigationController (DYTransition)

const char * dy_nav_transition_key;
- (void)dy_add_custom_transition{
    DYTransition * transition = [[DYTransition alloc] init];
    transition.toAnimator = [[DYTransitionAnimator alloc] init];
    transition.toAnimator.timeInterval = .3;
    __weak typeof(transition) weakTransition = transition;
    __weak typeof(self) weakSelf = self;
    transition.toAnimator.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        DY_GENERATE_TRANSITION_CONTEXT
        [containView addSubview:toVC.view];
        toVC.view.frame = CGRectMake(DY_NAV_SCREEN_WIDTH, 0, toVC.view.frame.size.width, toVC.view.frame.size.height);
        [UIView animateWithDuration:weakTransition.toAnimator.timeInterval animations:^{
            fromVC.view.frame = CGRectMake(-DY_NAV_SCREEN_WIDTH * .35, fromVC.view.frame.origin.y, fromVC.view.frame.size.width, fromVC.view.frame.size.height);
            toVC.view.frame = CGRectMake(0, toVC.view.frame.origin.y, toVC.view.frame.size.width, toVC.view.frame.size.height);
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
        shadowView.layer.shadowOpacity = 0.6;
        shadowView.layer.shadowRadius = 4;
        shadowView.layer.shadowOffset = CGSizeMake(-5, 5);
        shadowView.layer.shadowColor = [UIColor grayColor].CGColor;
        
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

- (void)dy_UseCustomNavigationItem{
    self.navigationBar.hidden = YES;    //额
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




//
//  UIViewController+YGTranslation.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "UIViewController+YGTranslation.h"
#import <objc/runtime.h>


@implementation UIViewController (YGTranslation)

- (void)yg_presentViewController:(UIViewController *)viewController withAnimator:(YGBaseAnimator *)animator{
    
}

#pragma  mark - 神奇移动相关

- (void)yg_addMagicMoveStartViewGroup:(NSArray<UIView *> *)group{
    
}

- (void)yg_addMagicMoveEndViewGroup:(NSArray<UIView *> *)group{
    
}

- (void)yg_changeMagicMoveStartViewGroup:(NSArray<UIView *> *)group{
    
}

#pragma mark - 手势相关
- (void)yg_registerToInteractiveTransitionWithDirection:(YGInteractiveGestureType)direction transitonBlock:(void(^)(CGPoint startPoint))tansitionConfig edgeSpacing:(CGFloat)edgeSpacing{
    if (!tansitionConfig) {
        return;
    }
    YGBaseInteractor * interactor = [YGBaseInteractor interactorWithGestureType:direction config:tansitionConfig edgeSpacing:edgeSpacing];
    [interactor addGestureForView:self.view to:YES];
    objc_setAssociatedObject(self, &YGWToInteractiveKey, interactor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)yg_registerBackInteractiveTransitionWithDirection:(YGInteractiveGestureType)direction transitonBlock:(void(^)(CGPoint startPoint))tansitionConfig edgeSpacing:(CGFloat)edgeSpacing{
    if (!tansitionConfig) {
        return;
    }
    YGBaseInteractor * interactor = [YGBaseInteractor interactorWithGestureType:direction config:tansitionConfig edgeSpacing:edgeSpacing];
    [interactor addGestureForView:self.view to:NO];
    objc_setAssociatedObject(self, &YGWAnimatorKey, <#id value#>, <#objc_AssociationPolicy policy#>)
}

@end

NSString *const YGWToInteractiveKey = @"YGWToInteractiveKey";
NSString *const YGWAnimatorKey = @"YGWAnimatorKey";


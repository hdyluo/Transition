//
//  UIViewController+YGTranslation.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGBaseAnimator.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YGTranslation)

- (void)yg_presentViewController:(UIViewController *)viewController withAnimator:(YGBaseAnimator *)animator;

#pragma  mark - 神奇移动相关

- (void)yg_addMagicMoveStartViewGroup:(NSArray<UIView *> *)group;

- (void)yg_addMagicMoveEndViewGroup:(NSArray<UIView *> *)group;

- (void)yg_changeMagicMoveStartViewGroup:(NSArray<UIView *> *)group;

#pragma mark - 手势相关
- (void)yg_registerToInteractiveTransitionWithDirection:(YGInteractiveGestureType)direction transitonBlock:(void(^)(CGPoint startPoint))tansitionConfig edgeSpacing:(CGFloat)edgeSpacing;

- (void)yg_registerBackInteractiveTransitionWithDirection:(YGInteractiveGestureType)direction transitonBlock:(void(^)(CGPoint startPoint))tansitionConfig edgeSpacing:(CGFloat)edgeSpacing;

@end

UIKIT_EXTERN NSString *const YGWToInteractiveKey;
UIKIT_EXTERN NSString *const YGWAnimatorKey;

NS_ASSUME_NONNULL_END

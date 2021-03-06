//
//  DYTransitionAnimator.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DY_GENERATE_TRANSITION_CONTEXT   UIViewController * fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];\
                                         UIViewController * toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];\
                                         UIView * containView = [context containerView];

@interface DYTransitionAnimator : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic,assign) NSTimeInterval timeInterval;           //动画时间

@property (nonatomic,copy) void (^animatorBlock)(id<UIViewControllerContextTransitioning> context);

@end

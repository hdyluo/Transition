//
//  DYTransitionAnimator.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYTransitionAnimator.h"

@implementation DYTransitionAnimator


- (void)dealloc{
    NSLog(@"动画控制器释放");
}

- (instancetype)init{
    if (self = [super init]) {
        self.timeInterval = .5;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return self.timeInterval;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    if (self.animatorBlock) {
        self.animatorBlock(transitionContext);
    }
}

- (void)animationEnded:(BOOL) transitionCompleted{
    
}

@end

//
//  YGBaseAnimator.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "YGBaseAnimator.h"


typedef void(^YGTransitionAnimationConfig) (id<UIViewControllerContextTransitioning> transitionContext);

@interface _YGTranslation : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype) initWithDuration:(NSTimeInterval)duration animationBlock:(YGTransitionAnimationConfig)config;

@end

@implementation _YGTranslation{
    NSTimeInterval _duration;
    YGTransitionAnimationConfig _config;
}

- (instancetype)initWithDuration:(NSTimeInterval)duration animationBlock:(void (^)(id<UIViewControllerContextTransitioning>))config{
    if (self = [super init]) {
        _duration = duration;
        _config = config;
    }
    return self;
}


- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return  _duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    //将转场动画的实现交给 config 回调， config 回调在animator 里配置
    if (_config) {
        _config(transitionContext);
    }
}

@end





@interface YGBaseAnimator ()

@property (nonatomic,strong) YGBaseInteractor * toInteractor;
@property (nonatomic,strong) YGBaseInteractor * backInteractor;
@property (nonatomic,strong) _YGTranslation * toTransition;
@property (nonatomic,strong) _YGTranslation * backTransition;

@property (nonatomic,assign) UINavigationControllerOperation operation;
@property (nonatomic,assign) BOOL toType;

@end

@implementation YGBaseAnimator

- (instancetype)init{
    if (self = [super init]) {
        self.toDuration = self.backDuration = .5f;
    }
    return self;
}



- (void)yg_setToAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
}

- (void)yg_setBackAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    
}

#pragma mark - setter

- (void)setToInteractor:(YGBaseInteractor *)toInteractor{
    _toInteractor = toInteractor;
    _toInteractor.delegate = self;
    _toInteractor.timerEnable = _needInteractiveTimer;
}

- (void)setBackInteractor:(YGBaseInteractor *)backInteractor{
    _backInteractor = backInteractor;
    _backInteractor.delegate = self;
    _backInteractor.timerEnable = _needInteractiveTimer;
}

#pragma mark - <UIViewControllerTransitioningDelegate>

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.toTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.backTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.backInteractor.interaction ? self.backInteractor : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator{
    return self.toInteractor.interaction ? self.toInteractor : nil;
}

#pragma mark - <UINavigationControllerDelegate>

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC{
    _operation = operation;
    return operation == UINavigationControllerOperationPush ? self.toTransition : self.backTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController{
    YGBaseInteractor * inter = _operation == UINavigationControllerOperationPush ? self.toInteractor : self.backInteractor;
    return inter.interaction ? inter : nil;
}

#pragma mark - 初始化
- (_YGTranslation *)toTransition{
    if (!_toTransition) {
        _toTransition = [[_YGTranslation alloc] initWithDuration:_toDuration animationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
            [self yg_setToAnimation:transitionContext];
        }];
    }
    return _toTransition;
}

- (_YGTranslation *)backTransition{
    if (!_backTransition) {
        _backTransition = [[_YGTranslation alloc] initWithDuration:_backDuration animationBlock:^(id<UIViewControllerContextTransitioning> transitionContext) {
            [self yg_setBackAnimation:transitionContext];
        }];
    }
    return _backTransition;
}

@end

//
//  YGTransition.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/29.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "YGTransition.h"

@interface YGTransition ()<YGInteractorStateDelegate>{
    UINavigationControllerOperation _operation;
}

@end

@implementation YGTransition

- (void)dealloc{
    NSLog(@"转场控制器释放");
}

#pragma mark - interactor delegate

-(void)interactDidBeginWith:(YGInteractor *)interactor{
    NSLog(@"手势要开始");
    if (interactor.tag == 0) {          //去向手势,需要在里面实现 push,present
        if (self.toInteractBlock) {
            self.toInteractBlock();
        }
    }else{                              //回来手势,需要在里面实现 pop,dismiss
        if (self.backInteractBlock) {
            self.backInteractBlock();
        }
    }
}


#pragma mark - setter

- (void)setBackInteractor:(YGInteractor *)backInteractor{
    _backInteractor = backInteractor;
    _backInteractor.delegate = self;
    _backInteractor.tag = 1;
}

- (void)setToInteractor:(YGInteractor *)toInteractor{
    _toInteractor = toInteractor;
    _toInteractor.delegate = self;
    _toInteractor.tag = 0;
}

#pragma mark - modal转场动画控制
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return _toAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return _backAnimator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return _toInteractor.canInteracive ? _toInteractor : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
    return _backInteractor.canInteracive ? _backInteractor : nil;
}

//- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0){
//    return nil;
//}

#pragma mark - navigationCotroller 转场动画

- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    if (_operation == UINavigationControllerOperationPush) {
        return _toInteractor.canInteracive ? _toInteractor : nil;
    }
    return _backInteractor.canInteracive ? _backInteractor : nil;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    _operation = operation;
    if (_operation == UINavigationControllerOperationPush) {
        return _toAnimator;
    }else{
        return _backAnimator;
    }
}
@end

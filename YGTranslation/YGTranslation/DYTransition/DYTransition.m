//
//  DYTransition.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYTransition.h"

@interface DYTransition (){
    UINavigationControllerOperation _operation;
}
@end

@implementation DYTransition

- (void)dealloc{
    NSLog(@"转场控制器释放");
}


#pragma mark - modal转场动画控制
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.toAnimator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return self.backAnimator;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return self.toInteractor.canInteracive ? self.toInteractor : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
        return self.backInteractor.canInteracive ? self.backInteractor : nil;
}


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

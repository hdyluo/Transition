//
//  UIViewController+DYTransition.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "UIViewController+DYTransition.h"
#import <objc/runtime.h>

@implementation UIViewController (DYTransition)



const char * dy_transition_weak_key;
- (void)setDy_transition:(DYTransition *)dy_transition{
    objc_setAssociatedObject(self, &dy_transition_weak_key, dy_transition, OBJC_ASSOCIATION_ASSIGN);
}
- (DYTransition *)dy_transition{
    return objc_getAssociatedObject(self, &dy_transition_weak_key);
}




- (void)dy_pushWithAnimatorTo:(UIViewController *)vc{
    DYTransition * transition = objc_getAssociatedObject(self, &dy_transitionKey);
    if (!transition) {
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    self.navigationController.delegate = transition;
    vc.dy_transition = transition;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dy_presentWithAnimatorTo:(UIViewController *)vc{
    DYTransition * transition = objc_getAssociatedObject(self, &dy_transitionKey);
    if (!transition) {
        NSLog(@"需要先调用dy_addToAnimator");
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    vc.transitioningDelegate = transition;
    vc.dy_transition = transition;
    [self presentViewController:vc animated:YES completion:nil];
}

const char * dy_transitionKey;
- (void)dy_addToAnimator:(DYTransitionAnimator *)animator interactor:(DYTransitionInteractor *)interactor {
    DYTransition * transition = [[DYTransition alloc] init];
    transition.toInteractor = interactor;
    transition.toAnimator = animator;
    objc_setAssociatedObject(self, &dy_transitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (transition.toInteractor) {
        [self.view addGestureRecognizer:transition.toInteractor.panGesture];
    }
}

- (void)dy_setBackAnimator:(DYTransitionAnimator *)animator interactor:(DYTransitionInteractor *)interactor WithType:(DYTransitionType)type {
    
    if (!self.dy_transition) {
        DYTransition * transition = [[DYTransition alloc] init];
        transition.backInteractor = interactor;
        transition.backAnimator = animator;
        objc_setAssociatedObject(self, &dy_transitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//避免释放
        if (interactor) {
            [self.view addGestureRecognizer:interactor.panGesture];
        }
        if (type == DYTransitionTypePop) {
            self.navigationController.delegate = transition;
        }else if(type == DYTransitionTypeDismiss){
            self.transitioningDelegate = transition;
        }
        return;
    }
    
    self.dy_transition.backInteractor = interactor;
    self.dy_transition.backAnimator = animator;
    if (self.dy_transition.backInteractor) {
        [self.view addGestureRecognizer:interactor.panGesture];
    }
}

@end

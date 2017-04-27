//
//  UIViewController+transition.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/29.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "UIViewController+transition.h"
#import <objc/runtime.h>

const char * kTransitionKey;            //给下级页面关联的转场对象的key

const char * kToInteractorKey;          //去向手势关联对象

const char * kBackInteractorKey;        //回来手势关联对象

@implementation UIViewController (transition)

- (void)yg_presentViewController:(UIViewController *)vc withTransition:(YGTransition *)transition{
    // vc.modalPresentationStyle = UIModalPresentationCustom;                                            //如果指定为custom的话手势驱动只能驱动fromVC.view,-----------大坑
    vc.transitioningDelegate = transition;
    [self _yg_setTransitionWithVC:vc transition:transition];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)yg_pushViewController:(UIViewController *)vc withTransition:(YGTransition *)transition{
    self.navigationController.delegate = transition;
    [self _yg_setTransitionWithVC:vc transition:transition];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)_yg_setTransitionWithVC:(UIViewController *)vc transition:(YGTransition *)transition{
    objc_setAssociatedObject(vc, &kTransitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);       //给 toVC关联一个转场对象,避免delegate 释放，delegate 是弱引用类型的 --------大坑
    [transition setValue:objc_getAssociatedObject(self, kToInteractorKey) forKey:@"toInteractor"];
    [transition setValue:objc_getAssociatedObject(vc, kBackInteractorKey) forKey:@"backInteractor"];
}

- (void)yg_addToInteractor:(YGInteractor *)interactor action:(void (^)())block {
    objc_setAssociatedObject(self, kToInteractorKey, interactor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);                //为当前对象关联去向手势
    interactor.transitionAction = block;
}

- (void)yg_addBackInteractor:(YGInteractor *)interactor action:(void (^)())block{                                   //为当前对象关联返回手势
    objc_setAssociatedObject(self, kBackInteractorKey, interactor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    interactor.transitionAction = block;
}






@end

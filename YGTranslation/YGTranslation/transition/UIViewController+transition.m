//
//  UIViewController+transition.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/29.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "UIViewController+transition.h"
#import <objc/runtime.h>

const char * kTransitionKey;

@implementation UIViewController (transition)

- (void)yg_readyForPresentWithToVC:(UIViewController *)vc withTransition:(YGTransition *)transition{
   // vc.modalPresentationStyle = UIModalPresentationCustom;            //如果指定为custom的话手势驱动只能驱动fromVC.view,-----------大坑
    vc.transitioningDelegate = transition;
    objc_setAssociatedObject(vc, &kTransitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);    //给 toVC关联一个转场对象,避免delegate 释放，delegate 是弱引用类型的 --------大坑
    __weak typeof(self) weakSelf = self;
    __weak typeof(vc) weakVC = vc;
    transition.toInteractBlock = ^{
        [weakSelf presentViewController:weakVC animated:YES completion:nil];                //必须全部是weak属性，-----------------超级大坑
    };
    
    transition.backInteractBlock = ^{
        NSLog(@"执行退出操作");
        [weakVC dismissViewControllerAnimated:YES completion:nil];
    };
}


- (void)yg_readyForPushWithToVC:(UIViewController *)vc withTransition:(YGTransition *)transition{
    if (!self.navigationController) {
        NSLog(@"导航栏都没有，你跳转个蛋啊");
        return;
    }
    self.navigationController.delegate = transition;
    objc_setAssociatedObject(vc, &kTransitionKey, transition, OBJC_ASSOCIATION_RETAIN_NONATOMIC);    //给 toVC关联一个转场对象,避免释放
    __weak typeof(self) weakSelf = self;
    __weak typeof(vc) weakVC = vc;
    transition.toInteractBlock = ^{
        [weakSelf.navigationController pushViewController:weakVC animated:YES];
    };
    transition.backInteractBlock = ^{
        [weakVC.navigationController popViewControllerAnimated:YES];
    };
}


@end

//
//  UIViewController+DYTransition.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYTransition.h"

@interface UIViewController (DYTransition)

@property (nonatomic,weak) DYTransition * dy_transition;

//- (void)dy_addTransition:(DYTransition *)transition;   //添加push转场的时候,delegate指向自己,在delloc的时候需要把delegate取消，下级页面的转场对象也是这个transition.(只有在参与push的对象才能调用)
                                                       //添加present转场的时候，delegate指向下级页面。(只有在参与present的才能调用)


- (void)dy_addToAnimator:(DYTransitionAnimator *)animator interactor:(DYTransitionInteractor *)interactor ; //action 里必须是dy_push 或者dy_present

- (void)dy_setBackAnimator:(DYTransitionAnimator *)animator interactor:(DYTransitionInteractor *)interactor WithType:(DYTransitionType)type;            //这是交给下级页面做的。

- (void)dy_presentWithAnimatorTo:(UIViewController *)vc;

- (void)dy_pushWithAnimatorTo:(UIViewController *)vc;




@end

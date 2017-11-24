//
//  DYTransition.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
// 职责是：为当前控制器添加交互和动画，作为ViewController的转场delegate //由于转场对象需要被两个控制器持有

#import <UIKit/UIKit.h>
#import "DYTransitionAnimator.h"
#import "DYTransitionInteractor.h"


typedef NS_ENUM(NSInteger,DYTransitionType) {
    DYTransitionTypePush = 0,
    DYTransitionTypePop,
    DYTransitionTypePresent,
    DYTransitionTypeDismiss
    
};


@interface DYTransition : NSObject<UIViewControllerTransitioningDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) DYTransitionAnimator * toAnimator;
@property (nonatomic, strong) DYTransitionAnimator * backAnimator;
@property (nonatomic, strong) DYTransitionInteractor * toInteractor;
@property (nonatomic, strong) DYTransitionInteractor * backInteractor;

@end

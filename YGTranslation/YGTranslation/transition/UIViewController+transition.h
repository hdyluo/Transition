//
//  UIViewController+transition.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/29.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YGTransition.h"

@interface UIViewController (transition)


- (void)yg_readyForPresentWithToVC:(UIViewController *)vc withTransition:(YGTransition *)transition;

- (void)yg_readyForPushWithToVC:(UIViewController *)vc withTransition:(YGTransition *)transition;


//- (void)yg_readyForPresentWithToClass:(Class)vcClass withTransition:(YGTransition *)transition;

@end

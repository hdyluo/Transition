//
//  DYTransitionInteractor.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,DYInteractorDirection) {
    DYInteractorDirectionTop = 0,           //向上滑
    DYInteractorDirectionLeft,              //向左滑
    DYInteractorDirectionBottom,            //向下滑
    DYInteractorDirectionRight              //向右滑
};

@interface DYTransitionInteractor : UIPercentDrivenInteractiveTransition

@property (nonatomic,assign) BOOL canInteracive;
@property (nonatomic,strong) UIPanGestureRecognizer * panGesture;           //手势
@property (nonatomic,assign) CGFloat speedControl;             // 滑动百分比，默认滑一厘米 视图变化一厘米。
@property (nonatomic,assign) CGFloat edgeSpacing;               //距离屏幕边界距离，必须小于这个距离才能滑动
@property (nonatomic,assign) CGFloat canOverPercent;           //可以结束的百分比，默认0.5
@property (nonatomic,assign) CGFloat canOverVelocity;           //可以结束的速率,默认1000这个不要改
@property (nonatomic,assign) DYInteractorDirection interactorDirection; //滑动方向
@property (nonatomic,copy) void(^transitionAction)();           //转场方式，block需要执行push或者present,pop,dismiss


- (instancetype)initWithDirection:(DYInteractorDirection)direction;

@end

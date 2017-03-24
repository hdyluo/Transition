//
//  YGBaseInteractor.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/24.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>


@class YGBaseInteractor;

@protocol YGInteractorDelegate <NSObject>

@optional

- (void)interactiveTransitionWillBegin:(YGBaseInteractor *) interactor;

/**
 交互进行中

 @param interactor 交互控制器
 @param percent 百分比
 */
- (void)interactiveTransitioning:(YGBaseInteractor *)interactor percent:(CGFloat)percent;

/**
 松开手势交给定时器做剩余动画

 @param interactor 交互控制器
 */
- (void)interactiveTimerWillBeginAnimation:(YGBaseInteractor *)interactor;

/**
 交互转场结束需要调用

 @param interactor 交互控制器
 @param flag 成功失败标志
 @param percent 百分比
 */
- (void)interactiveTransitionDone:(YGBaseInteractor *) interactor isSuccess:(BOOL)flag percent:(CGFloat)percent;

@end

typedef NS_ENUM(NSInteger,YGInteractiveGestureType) {
    YGInteractiveGestureTypeLeft = 0,
    YGInteractiveGestureTypeRight,
    YGInteractiveGestureTypeUp,
    YGInteractiveGestureTypeDown
};

typedef void(^YGInteractorConfig)(CGPoint startPoint);

@interface YGBaseInteractor : UIPercentDrivenInteractiveTransition

@property (nonatomic,assign,readonly) BOOL interaction;

@property (nonatomic,assign) BOOL timerEnable;

@property (nonatomic,weak) id<YGInteractorDelegate> delegate;

/**
 手势百分比基准，默认横向侧滑的是view.width   纵向侧滑是 view.height,这个会影响侧滑速率
 */
@property (nonatomic,assign) CGFloat percentBase;


+ (instancetype)interactorWithGestureType:(YGInteractiveGestureType)gestureType
                                   config:(YGInteractorConfig) config
                              edgeSpacing:(CGFloat)spacing;

- (void)addGestureForView:(UIView *)view to:(BOOL)flag;

@end

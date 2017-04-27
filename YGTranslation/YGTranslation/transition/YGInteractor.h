//
//  YGInteractor.h
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/29.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,YGInteractorDirection) {
    YGInteractorDirectionLeft,                              //从右向左滑
    YGInteractorDirectionRight,                             //从左向右滑
    YGInteractorDirectionTop,                               //从下向上滑
    YGInteractorDirectionBottom                             //从上向下滑
};

@class YGInteractor;
@protocol YGInteractorStateDelegate <NSObject>

@required
- (void)interactDidBeginWith:(YGInteractor *)interactor;

@end

@interface YGInteractor : UIPercentDrivenInteractiveTransition

@property (nonatomic,assign) BOOL canInteracive;            //是否可交互标志位,实现这个协议的目的是为了调用系统转场函数，present...   dismiss...  push... pop...

@property (nonatomic,assign) CGFloat speedControl;             // 1:正常速率  线性正比

@property (nonatomic,assign) CGFloat canOverPercent;           //可以结束的百分比，默认0.5

@property (nonatomic,assign) NSInteger tag;

@property (nonatomic,weak) id<YGInteractorStateDelegate> delegate;

- (instancetype)initWithDirection:(YGInteractorDirection)direction edgeSpacing:(CGFloat)spacing forView:(UIView *)view ;


@end

//
//  DYTransitionInteractor.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/23.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYTransitionInteractor.h"

@interface DYTransitionInteractor()<UIGestureRecognizerDelegate>{
    CGFloat _percent;                   //手势滑动百分比
    CGPoint _startPoint;                //手势开始的点
}

@end

@implementation DYTransitionInteractor

- (void)dealloc{
    NSLog(@"交互控制器释放");
}

- (instancetype)initWithDirection:(DYInteractorDirection)direction{
    if (self = [super init]) {
        self.canInteracive  = NO;
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureChanged:)];
        self.panGesture.delegate = self;
        self.speedControl = 1.0;
        self.edgeSpacing = 50;
        self.canOverPercent =.5f;
        self.canOverVelocity = 1000;
        self.interactorDirection = direction;
    }
    return self;
}

- (void)gestureChanged:(UIPanGestureRecognizer *)panGesture{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
            _startPoint = [panGesture translationInView:panGesture.view];                       //不能用localtionInView   -------------超级大坑
            _percent = 0;
            self.canInteracive = YES;
            if (self.transitionAction) {
                self.transitionAction();
            }
            break;
        case UIGestureRecognizerStateChanged:
            [self _calculatePercentWithGesture];
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStatePossible:
            [self _calculateEndWithGesture];
            self.canInteracive = NO;
            break;
        default:
            break;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //连续多次滑动会影响结束或取消过程,判断当前有速度的情况下禁止再加入滑动手势
    if (self.percentComplete != 0) {
        return NO;
    }
    CGPoint startPoint = [gestureRecognizer locationInView:nil];
    switch (self.interactorDirection) {
        case DYInteractorDirectionTop:{                              //向上滑
            if (startPoint.y + self.edgeSpacing < [UIScreen mainScreen].bounds.size.height) {
                return NO;
            }
        }
            break;
        case DYInteractorDirectionLeft:{                            //向左滑
            if (startPoint.x + self.edgeSpacing < [UIScreen mainScreen].bounds.size.width) {
                return NO;
            }
        }
            break;
        case DYInteractorDirectionRight:{                           //向右滑
            if (startPoint.x > self.edgeSpacing) {
                return NO;
            }
        }
            break;
        case DYInteractorDirectionBottom:{                          //向下滑
            if (startPoint.y > self.edgeSpacing) {
                return NO;
            }
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)_calculatePercentWithGesture{
    UIView * view = self.panGesture.view;
    CGPoint point = [self.panGesture translationInView:view];
    switch (self.interactorDirection) {
        case DYInteractorDirectionTop:
              _percent = (_startPoint.y - point.y) / view.frame.size.height;
            break;
        case DYInteractorDirectionLeft:
             _percent = (_startPoint.x - point.x) / view.frame.size.width;
            break;
        case DYInteractorDirectionBottom:
             _percent = (point.y - _startPoint.y)/ view.frame.size.height;
            break;
        case DYInteractorDirectionRight:
            _percent = (point.x - _startPoint.x) / view.frame.size.width;
            break;
        default:
            break;
    }
    _percent = _percent * self.speedControl;        //根据速率计算当前percent
    _percent = _percent < 0 ? 0:_percent;
    _percent = _percent > 1 ? 1:_percent;
    
    [self updateInteractiveTransition:_percent];
}

- (void)_calculateEndWithGesture{
    CGPoint velocity = [self.panGesture velocityInView:self.panGesture.view];
    NSLog(@"%@",NSStringFromCGPoint([self.panGesture velocityInView:self.panGesture.view]));
    //速率大于1000直接完成，速率
    
    switch (self.interactorDirection) {
        case DYInteractorDirectionTop:{
            if (velocity.y < -1000) {
                [self finishInteractiveTransition];
            }else{
                if (_percent > self.canOverPercent) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
            }
        }
            break;
        case DYInteractorDirectionLeft:{
            if (velocity.x < -1000) {
                [self finishInteractiveTransition];
            }else{
                if (_percent > self.canOverPercent) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
            }
        }
            break;
        case DYInteractorDirectionBottom:{
            if (velocity.y > 1000) {
                [self finishInteractiveTransition];
            }else{
                if (_percent > self.canOverPercent) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
            }
        }
            break;
        case DYInteractorDirectionRight:{ //向右滑
            if (velocity.x > 1000) {
                 [self finishInteractiveTransition];
            }else{
                if (_percent > self.canOverPercent) {
                    [self finishInteractiveTransition];
                }else{
                    [self cancelInteractiveTransition];
                }
            }
        }
            break;
        default:
            break;
    }
}

@end

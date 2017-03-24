//
//  YGBaseInteractor.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/3/24.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "YGBaseInteractor.h"
#import <objc/runtime.h>


@interface YGBaseInteractor ()<UIGestureRecognizerDelegate>

@property (nonatomic,assign) YGInteractiveGestureType               gestureType;

@property (nonatomic,copy) YGInteractorConfig                       config;

@property (nonatomic,strong) CADisplayLink *                        timer;

@property (nonatomic,assign) CGFloat                                percent;

@property (nonatomic,assign) CGFloat                                timeDis;

@property (nonatomic,assign) BOOL                                   vertical;           //标识是不是竖直手势

@property (nonatomic,assign) CGFloat                                edgeSpacing;

@end

@implementation YGBaseInteractor

+ (instancetype)interactorWithGestureType:(YGInteractiveGestureType)gestureType config:(YGInteractorConfig)config edgeSpacing:(CGFloat)spacing{
    YGBaseInteractor * interactor = [[YGBaseInteractor alloc] init];
    return interactor;
}

- (instancetype)initWithGesture:(YGInteractiveGestureType)gestureType config:(YGInteractorConfig)config edgeSpacing:(CGFloat)spacing{
    if (self = [super init]) {
        self.gestureType = gestureType;
        self.config = config;
        self.edgeSpacing = spacing;
        self.vertical = (gestureType == YGInteractiveGestureTypeUp || gestureType == YGInteractiveGestureTypeDown);
    }
    return self;
}

- (void)addGestureForView:(UIView *)view to:(BOOL)flag{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
    //为drawerAnimator记录pan手势
    pan.delegate = self;
    NSString * panType = flag ? @"yg_interactiveToPan" : @"yg_interactiveBackPan";
    objc_setAssociatedObject(pan, "yg_interactivePanKey", panType, OBJC_ASSOCIATION_RETAIN_NONATOMIC);//给手势关联一个对象，在手势回到的时候可以取到这个对象
    [view addGestureRecognizer:pan];
}

#pragma mark  - 手势回调
- (void)handleGesture:(UIPanGestureRecognizer *)gesture{
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            if (self.delegate && [self.delegate respondsToSelector:@selector(interactiveTransitionWillBegin:)]) {
                [self.delegate interactiveTransitionWillBegin:self];
            }
            CGPoint startPoint = [gesture locationInView:gesture.view];
            _interaction = YES;
            if (self.config) {
                self.config(startPoint);
            }
            [self _cacularMovePercentForGesture:gesture];
            break;
        case UIGestureRecognizerStateChanged:
            [self _cacularMovePercentForGesture:gesture];
            [self _updateWithPercent:_percent];
            break;
        case UIGestureRecognizerStateEnded:
            if (!self.timerEnable) {
                _percent > 0.5 ? [self _finish] :[self _cancel];
            }
            BOOL canEnd = [self _canEndInteractiveWithPercent:_percent];
            if (canEnd){
                return;
            }
            //开启timer
            [self _endTranslationWithTimerWithPercent:_percent];
            break;
        default:
            break;
    }
}


#pragma mark - 手势驱动计算

- (void)_cacularMovePercentForGesture:(UIPanGestureRecognizer *)panGesture{
    CGFloat baseValue = self.percentBase > 0 ? self.percentBase : (self.vertical ? panGesture.view.frame.size.height : panGesture.view.frame.size.width);
    switch (self.gestureType) {
        case YGInteractiveGestureTypeUp:{
            CGFloat transitionY = -[panGesture translationInView:panGesture.view].y;
            _percent += transitionY / baseValue;
        }
            break;
        case YGInteractiveGestureTypeDown:{
            CGFloat transitionY = [panGesture translationInView:panGesture.view].y;
            _percent += transitionY / baseValue;
        }
            break;
        case YGInteractiveGestureTypeLeft:{
            CGFloat transitionX = -[panGesture translationInView:panGesture.view].x;
            _percent += transitionX / baseValue;
        }
            break;
        case YGInteractiveGestureTypeRight:{
            CGFloat transitionX = [panGesture translationInView:panGesture.view].x;
            _percent += transitionX / baseValue;

        }
            break;
        default:
            break;
    }
    [panGesture setTranslation:CGPointZero inView:panGesture.view];
}

- (void)_updateWithPercent:(CGFloat)percent{
    [self updateInteractiveTransition:percent];
    if (self.delegate && [self.delegate respondsToSelector:@selector(interactiveTransitioning:percent:)]) {
        [self.delegate interactiveTransitioning:self percent:percent];
    }
}

- (void)_finish{
    if (self.delegate && [self.delegate respondsToSelector:@selector(interactiveTransitionDone:isSuccess:percent:)]) {
        [self.delegate interactiveTransitionDone:self isSuccess:YES percent:_percent];
    }
    [self finishInteractiveTransition];
    _percent = 0.0;
    _interaction = NO;
}
- (void)_cancel{
    if (self.delegate && [self.delegate respondsToSelector:@selector(interactiveTransitionDone:isSuccess:percent:)]) {
        [self.delegate interactiveTransitionDone:self isSuccess:NO percent:_percent];
    }
    [self cancelInteractiveTransition];
    _percent = 0.0;
    _interaction = NO;
}

- (BOOL)_canEndInteractiveWithPercent:(CGFloat)percent{
    BOOL canEnd = NO;
    if (percent >= 1) {
        [self _finish];
        canEnd = YES;
    }
    if (percent <= 0) {
        [self _cancel];
        canEnd = YES;
    }
    
    return canEnd;
}

- (void)_endTranslationWithTimerWithPercent:(CGFloat)percent{
    //根据失败还是成功设置刷新间隔
    if (percent > 0.5) {
        _timeDis = (1 - percent) / ((1 - percent) * 60);
    }else{
        _timeDis = percent / (percent * 60);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(interactiveTimerWillBeginAnimation:)]) {
        [self.delegate interactiveTimerWillBeginAnimation:self];
    }
    //开启timer
    [self _startTimer];
}

- (void)_startTimer{
    if (_timer) {
        return;
    }
    _timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(_timerEvent)];
    [_timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)_timerEvent{
    if (_percent > 0.5) {
        _percent += _timeDis;
    }else{
        _percent -= _timeDis;
    }
    //通过timer不断刷新转场进度
    [self _updateWithPercent:_percent];
    BOOL canEnd = [self _canEndInteractiveWithPercent:_percent];
    if (canEnd) {
        [self _stopTimer];
    }
}
- (void)_stopTimer{
    if (!_timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}
#pragma mark - 手势代理

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (self.edgeSpacing <= 0) {
        return YES;
    }
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    BOOL canGesture = NO;
    switch (self.gestureType) {
        case YGInteractiveGestureTypeUp:
            canGesture = point.y >= gestureRecognizer.view.frame.size.height - self.edgeSpacing;
            break;
        case YGInteractiveGestureTypeDown:
            canGesture = point.y <= self.edgeSpacing;
            break;
        case YGInteractiveGestureTypeLeft:
            canGesture = point.x >= gestureRecognizer.view.frame.size.width - self.edgeSpacing;
            break;
        case YGInteractiveGestureTypeRight:
            canGesture = point.x <= self.edgeSpacing;
            break;
        default:
            break;
    }
    if (!canGesture) {
        NSLog(@"手势出发点不符合edge spacing");
    }
    return canGesture;
}


@end

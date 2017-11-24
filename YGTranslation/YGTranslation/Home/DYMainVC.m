//
//  DYMainVC.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/24.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYMainVC.h"
#import "UIViewController+transition.h"
#import "YGVC1Animator.h"
#import "YGVC2Animator.h"
#import "YGVC3Animator.h"
#import "UIView+Snapshot.h"
#import "UIViewController+DYTransition.h"


@interface DYMainVC ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray * _titles;
    NSArray * _vcs;
}

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) YGTransition * transition;

@end

@implementation DYMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];   
    _titles = @[@"左滑或点击弹出抽屉",@"点击弹出警告框",@"modal转场3",@"modal转场4"];
    _vcs = @[@"DYVC1",@"DYVC2",@"DYVC3",@"DYVC4"];
    [self.view addSubview:self.tableView];
//    [self addtransition];
    [self dy_transitionWithVC:nil];
}

- (void)addtransition{
    YGInteractor * toInteractor = [[YGInteractor alloc] initWithDirection:YGInteractorDirectionRight edgeSpacing:0 forView:self.view];
    __weak typeof(self) weakSelf = self;
    [self yg_addToInteractor:toInteractor action:^{
        UIViewController * toVC = [[NSClassFromString(@"DYVC1") alloc] init];
        [weakSelf _transitionWithVC:toVC];
    }];
}

#pragma mark - delegate and datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController * vc = [NSClassFromString(_vcs[indexPath.row]) new];
    switch (indexPath.row) {
        case 0:{
//            [self _transitionWithVC:vc];
            UIViewController * toVC = [[NSClassFromString(@"DYVC1") alloc] init];
            [self dy_presentWithAnimatorTo:toVC];
        }
            break;
        case 1:{
            [self _alertWithVC:vc];
        }
            break;
        case 2:
            [self _pushWithVC:vc];
            break;
        case 3:
            break;
        default:
            break;
    }
}

- (void)dy_transitionWithVC:(UIViewController *)vc{
    DYTransitionAnimator * animator = [[DYTransitionAnimator alloc] init];
    animator.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        UIViewController * fromVC = [context viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController * toVC = [context viewControllerForKey:UITransitionContextToViewControllerKey];
        UIView * containView = [context containerView];
        [containView addSubview:toVC.view];
        toVC.view.transform = CGAffineTransformMakeTranslation(-200, 0);
        UIImage * snapShot = [fromVC.view snapshotImage];
        UIView * extraView = [[UIImageView alloc] initWithImage:snapShot];
        extraView.frame = CGRectMake(200, 0, snapShot.size.width, snapShot.size.height);
        [toVC.view addSubview:extraView];
        [UIView animateWithDuration:.5 animations:^{
            fromVC.view.transform = CGAffineTransformMakeTranslation(200, 0);
            toVC.view.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [context completeTransition:![context transitionWasCancelled]];
        }];
    };
    DYTransitionInteractor * interacotr = [[DYTransitionInteractor alloc] initWithDirection:DYInteractorDirectionRight];
    interacotr.speedControl = 1.5;
    __weak typeof(self) weakSelf = self;
    interacotr.transitionAction = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
         UIViewController * toVC = [[NSClassFromString(@"DYVC1") alloc] init];
        [strongSelf dy_presentWithAnimatorTo:toVC];
    };
    [self dy_addToAnimator:animator interactor:interacotr];
}


- (void)_transitionWithVC:(UIViewController *)vc{
    YGTransition * transition = [[YGTransition alloc] init];
    YGVC1Animator * toAnimator = [[YGVC1Animator alloc] initWithType:0];
    transition.toAnimator = toAnimator;
    YGVC1Animator * backAnimator = [[YGVC1Animator alloc] initWithType:1];
    transition.backAnimator = backAnimator;
    
    [self yg_presentViewController:vc withTransition:transition];
//    [self yg_pushViewController:vc withTransition:transition];
}

- (void)_alertWithVC:(UIViewController *)vc{
    YGVC2Animator * toAnimator = [[YGVC2Animator alloc] initWithType:0];
    YGVC2Animator * backAnimator = [[YGVC2Animator alloc] initWithType:1];
    YGTransition * transition = [[YGTransition alloc] init];
    transition.toAnimator  = toAnimator;
    transition.backAnimator = backAnimator;
    
    [self yg_presentCustomViewController:vc withTransition:transition];
}

- (void)_pushWithVC:(UIViewController *)vc{
    YGTransition * transition = [[YGTransition alloc] init];
    YGVC3Animator * toAnimator = [[YGVC3Animator alloc] initWithType:0];
    transition.toAnimator = toAnimator;
    YGVC3Animator * backAnimator = [[YGVC3Animator alloc] initWithType:1];
    transition.backAnimator = backAnimator;
    
    //   [self yg_presentViewController:vc withTransition:transition];
    [self yg_pushViewController:vc withTransition:transition];
}


#pragma mark - 初始化

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end

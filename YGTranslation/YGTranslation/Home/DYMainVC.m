//
//  DYMainVC.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/24.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYMainVC.h"
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

@end

@implementation DYMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];   
    _titles = @[@"左滑或点击弹出抽屉",@"自定义导航栏转场",@"modal转场3",@"modal转场4"];
    _vcs = @[@"DYVC1",@"DYVC2",@"DYVC3",@"DYVC4"];
    [self.view addSubview:self.tableView];
    [self addTransition];
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
            [self dy_presentWithAnimatorTo:vc];
        }
            break;
        case 1:{
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}

- (void)addTransition{
    DYTransitionAnimator * animator = [[DYTransitionAnimator alloc] init];
    animator.animatorBlock = ^(id<UIViewControllerContextTransitioning> context) {
        DY_GENERATE_TRANSITION_CONTEXT
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
    interacotr.speedControl = 1.5;              //管用
    interacotr.edgeSpacing = [UIScreen mainScreen].bounds.size.width * .6;               //管用
//    interacotr.canOverPercent = .3;             //管用
    __weak typeof(self) weakSelf = self;
    interacotr.transitionAction = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
         UIViewController * toVC = [[NSClassFromString(@"DYVC1") alloc] init];
        [strongSelf dy_presentWithAnimatorTo:toVC];
    };
    [self dy_addToAnimator:animator interactor:interacotr];
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

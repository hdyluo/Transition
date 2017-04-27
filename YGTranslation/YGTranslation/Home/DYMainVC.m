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
    _titles = @[@"modal转场1",@"modal转场2",@"modal转场3",@"modal转场4"];
    _vcs = @[@"DYVC1",@"DYVC2",@"DYVC3",@"DYVC4"];
    [self.view addSubview:self.tableView];
    [self addtransition];
    
}

- (void)addtransition{
    YGInteractor * toInteractor = [[YGInteractor alloc] initWithDirection:YGInteractorDirectionLeft edgeSpacing:0 forView:self.view];
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
            [self _transitionWithVC:vc];
        }
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}


- (void)_transitionWithVC:(UIViewController *)vc{
    YGTransition * transition = [[YGTransition alloc] init];
    YGVC1Animator * toAnimator = [[YGVC1Animator alloc] initWithType:0];
    transition.toAnimator = toAnimator;
    YGVC1Animator * backAnimator = [[YGVC1Animator alloc] initWithType:1];
    transition.backAnimator = backAnimator;
    
    YGInteractor * interactor = [[YGInteractor alloc] initWithDirection:YGInteractorDirectionRight edgeSpacing:0 forView:vc.view];
    __weak typeof(vc) weakVC = vc;
//    [vc yg_addBackInteractor:interactor action:^{                           //给vc关联个返回手势
//        [weakVC dismissViewControllerAnimated:YES completion:nil];
//    }];
//    [self yg_presentViewController:vc withTransition:transition];
    
    [vc yg_addBackInteractor:interactor action:^{
        [weakVC.navigationController popViewControllerAnimated:YES];
    }];
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

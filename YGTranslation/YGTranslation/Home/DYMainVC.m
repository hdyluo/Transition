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
    
    YGInteractor * backInteractor = [[YGInteractor alloc] initWithDirection:YGInteractorDirectionRight edgeSpacing:0 forView:vc.view];
    transition.backInteractor = backInteractor;
    backInteractor.canOverPercent = 0.3;
    
    
    [self yg_readyForPresentWithToVC:vc withTransition:transition];
    [self presentViewController:vc animated:YES completion:nil];
    
 //   [self yg_readyForPushWithToVC:vc withTransition:transition];
 //   [self.navigationController pushViewController:vc animated:YES];
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

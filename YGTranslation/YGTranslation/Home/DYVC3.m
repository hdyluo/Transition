//
//  DYVC3.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/24.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYVC3.h"
#import "UIViewController+transition.h"

@interface DYVC3 ()

@end

@implementation DYVC3

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    self.title = @"第三个页面";
    [self _addBackInteractor];
}

- (void)_addBackInteractor{
    YGInteractor * interactor = [[YGInteractor alloc] initWithDirection:YGInteractorDirectionRight edgeSpacing:0 forView:self.view];
    __weak typeof(self) weakSelf = self;
    [self yg_addBackInteractor:interactor action:^{
        // [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

@end

//
//  DYVC1.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/24.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYVC1.h"
#import "UIViewController+transition.h"

@interface DYVC1 ()


@end

@implementation DYVC1

- (void)dealloc{
    
    NSLog(@"%@释放",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    
    YGInteractor * interactor = [[YGInteractor alloc] initWithDirection:YGInteractorDirectionLeft edgeSpacing:0 forView:self.view];
    __weak typeof(self) weakSelf = self;
    [self yg_addBackInteractor:interactor action:^{
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}


@end
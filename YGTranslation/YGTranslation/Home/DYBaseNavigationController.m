//
//  DYBaseNavigationController.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/27.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYBaseNavigationController.h"
#import "UINavigationController+DYTransition.h"

@interface DYBaseNavigationController ()

@end

@implementation DYBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dy_add_custom_transition];                        //添加自定义转场
    [self dy_UseCustomNavigationItem];
//    self.navigationBar.prefersLargeTitles = YES;
}


@end

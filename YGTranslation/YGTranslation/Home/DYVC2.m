//
//  DYVC2.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/4/24.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYVC2.h"
#import "UINavigationController+DYTransition.h"

@interface DYVC2 ()

@end

@implementation DYVC2

- (void)dealloc{
    NSLog(@"%@释放",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
//    UIView * testView = [UIView new];
//    testView.backgroundColor = [UIColor redColor];
    self.title = @"pageTwo";
    [self dy_addCustomItem:[UIView new]];
    self.dy_navigationItemView.backgroundColor = [UIColor greenColor];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

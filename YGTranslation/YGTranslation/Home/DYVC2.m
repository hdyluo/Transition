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
    
    self.dy_navigationItemView = [DYCustomNavigationItem new];
    self.dy_navigationItemView.backgroundColor = [UIColor redColor];
    self.title = @"pageTwo";
}
- (void)btnClicked{
    NSLog(@"点击了按钮");
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  DYCustomNavigationItem.m
//  YGTranslation
//
//  Created by 黄德玉 on 2017/11/28.
//  Copyright © 2017年 黄德玉. All rights reserved.
//

#import "DYCustomNavigationItem.h"

@implementation DYCustomNavigationItem

- (instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.backBtn];
        [self _dy_layout];
    }
    return self;
}

- (void)_dy_layout{
    NSLayoutConstraint * centerLC = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:centerLC];
    [self.titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:200]];
    [self.titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
    NSLayoutConstraint * titleBottomLC = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [self addConstraint:titleBottomLC];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.backBtn attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backBtn attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    [self.backBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.backBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    [self.backBtn addConstraint:[NSLayoutConstraint constraintWithItem:self.backBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:44]];
}

#pragma mark - 初始化


- (UILabel *)titleLabel{
    if (!_titleLabel) {
        
        _titleLabel = [UILabel new];
        _titleLabel.text = @"你好";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        _backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _backBtn;
}


@end

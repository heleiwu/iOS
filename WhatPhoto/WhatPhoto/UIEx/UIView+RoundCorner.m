//
//  UIView+RoundCorner.m
//  WhatPhoto
//
//  Created by heleiwu on 9/8/14.
//  Copyright (c) 2014 heleiwu. All rights reserved.
//

#import "UIView+RoundCorner.h"

@implementation UIView (RoundCorner)

- (void)setRoundCorner:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

@end

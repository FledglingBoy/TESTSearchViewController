//
//  UIView+UIViewEx.h
//  TuTu
//
//  Created by zhang xiangying on 13-9-13.
//  Copyright (c) 2013年 ChenHongbin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewEx)


@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat top;

@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat left;

@property (nonatomic, assign) CGFloat right;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat centerX;

@property (nonatomic, assign) CGFloat centerY;

- (void)GetFrame:(CGRect)frame;
- (void)autoSetFrame:(CGRect)frame;
- (void)removeAllSubviews;


@end

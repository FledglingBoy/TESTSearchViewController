//
//  AJLoadingView.h
//  Ehome
//
//  Created by 曾文辉 on 2017/9/28.
//  Copyright © 2017年 ajhy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AJLoadingViewBlock)();

@interface AJLoadingView : UIView

@property(nonatomic,assign)BOOL isShowing;
@property(nonatomic,strong)AJLoadingViewBlock block;

-(void)showLoadingView:(NSInteger)type andRootView:(UIView*)view;
-(void)showLoadingView:(UIView *)view;
-(void)hidenLoadingView;
-(void)updateViewType:(NSInteger)type;

@end

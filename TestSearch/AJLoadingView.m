//
//  AJLoadingView.m
//  Ehome
//
//  Created by 曾文辉 on 2017/9/28.
//  Copyright © 2017年 ajhy. All rights reserved.
//

#import "AJLoadingView.h"

@interface AJLoadingView()
@property (nonatomic, strong) UIView *showView;
//@property(nonatomic,strong)UIImageView *animationView;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UIButton *btn;

@end

@implementation AJLoadingView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        self.showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height)];
        self.showView.backgroundColor = [UIColor whiteColor];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, AUTO(135), AUTO(115))];
        self.imageView.centerX = SCREEN_WIDTH/2;
        self.imageView.centerY = (self.showView.height-AUTO(115)-AUTO(30))/2;
        [self.showView addSubview:self.imageView];
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.bottom, SCREEN_WIDTH, AUTO(30))];
        self.label.font = FONT(15);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.textColor = COLORAPPBLACK;
        [self.showView addSubview:self.label];
        self.btn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, self.label.bottom, SCREEN_WIDTH/3, AUTO(25))];
        [self.btn setTitle:@"重试" forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor whiteColor]];
        [self.btn setTitleColor:UIColorFromRGB(0xfe6666) forState:UIControlStateNormal];
        self.btn.titleLabel.font = FONT(14);
        [self.btn addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchUpInside];
        [self.showView addSubview:self.btn];
        [self addSubview:self.showView];
        
    }
    return self;
}

-(void)showLoadingView:(UIView *)view
{
    [self showLoadingView:0 andRootView:view];
}


-(void)showLoadingView:(NSInteger)type andRootView:(UIView*)view
{
    if(self.isShowing)
    {
        return;
    }
    self.isShowing = YES;
    [self updateViewType:type];
    [view addSubview:self];
    //    [[[UIApplication sharedApplication] delegate].window addSubview:self];
}

-(void)updateViewType:(NSInteger)type
{
    if(type==0)
    {
        NSArray * imgsArr = @[[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"4.jpg"],[UIImage imageNamed:@"5.jpg"],[UIImage imageNamed:@"6.jpg"],[UIImage imageNamed:@"7.jpg"]];
        // 设置动画图片数组
        [_imageView setAnimationImages:imgsArr];
        // 设置动画持续时间
        [_imageView setAnimationDuration:0.5];
        // 设置动画重复次数  (当值为0时，表示无限次)
        _imageView.animationRepeatCount = 0;
        // 开始动画
        [_imageView startAnimating];
        self.label.text = @"正在努力加载";
        self.btn.hidden = YES;
        self.btn.enabled = NO;
        
    } else if(type==1)
    {
        if([self.imageView isAnimating])
        {
            [_imageView stopAnimating];
        }
        [self.imageView setImage:[UIImage imageNamed:@"aj_loading_empty_data"]];
        self.label.text = @"暂无数据";
        self.btn.hidden = YES;
        self.btn.enabled = NO;
        
    } else if(type==2)
    {
        if([self.imageView isAnimating])
        {
            [_imageView stopAnimating];
        }
        [self.imageView setImage:[UIImage imageNamed:@"aj_loading_empty_data"]];
        self.label.text = @"网络不给力...";
        self.btn.hidden = NO;
        self.btn.enabled = YES;
    }
}

-(void)hidenLoadingView
{
    if(self.isShowing)
        [self removeFromSuperview];
    self.isShowing = NO;
}


-(void)btnDown:(UIButton *)btn
{
    [self hidenLoadingView];
    if(self.block)
        _block();
}

@end

//
//  ZYJUINavigationController.m
//  Ehome
//
//  Created by 曾文辉 on 2016/11/14.
//  Copyright © 2016年 zyj. All rights reserved.
//

#import "ZYJUINavigationController.h"
//#import "ZYJQyLiveViewController.h"

@interface ZYJUINavigationController ()

@end

@implementation ZYJUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    
    return [[self.viewControllers lastObject] shouldAutorotate];
//   if ([[self.viewControllers lastObject]isKindOfClass:[ZYJQyLiveViewController class]]) {
//        return YES;
//    }
//    
//    return NO;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
//    if ([[self.viewControllers lastObject]isKindOfClass:[ZYJQyLiveViewController class]]) {
//        return UIInterfaceOrientationMaskAll;
//    }
//    
//    return UIInterfaceOrientationMaskPortrait;
}

//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    
//    if ([[self.viewControllers lastObject]isKindOfClass:[ZYJQyLiveViewController class]]) {
//        return UIInterfaceOrientationLandscapeRight;
//    }
//    
//    return UIInterfaceOrientationPortrait;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  AJHYSearchTransitionAnimator.m
//  RabbitClose
//
//  Created by 曾文辉 on 2017/10/17.
//  Copyright © 2017年 曾文辉. All rights reserved.
//

#import "AJHYSearchTransitionAnimator.h"
#import "AJHYSearchViewController.h"

@implementation AJHYSearchTransitionAnimator



//| ----------------------------------------------------------------------------
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return .35;
}


//| ----------------------------------------------------------------------------
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = transitionContext.containerView;
    
    // For a Presentation:
    //      fromView = The presenting view.
    //      toView   = The presented view.
    // For a Dismissal:
    //      fromView = The presented view.
    //      toView   = The presenting view.
    UIView *fromView;
    UIView *toView;
    
    // In iOS 8, the viewForKey: method was introduced to get views that the
    // animator manipulates.  This method should be preferred over accessing
    // the view of the fromViewController/toViewController directly.
    // It may return nil whenever the animator should not touch the view
    // (based on the presentation style of the incoming view controller).
    // It may also return a different view for the animator to animate.
    //
    // Imagine that you are implementing a presentation similar to form sheet.
    // In this case you would want to add some shadow or decoration around the
    // presented view controller's view. The animator will animate the
    // decoration view instead and the presented view controller's view will
    // be a child of the decoration view.
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromViewController];
    CGRect toFrame = [transitionContext finalFrameForViewController:toViewController];
    
    //    fromView.frame = [transitionContext initialFrameForViewController:fromViewController];
    //    toView.frame = [transitionContext finalFrameForViewController:toViewController];
    
    if(_isFromeSearch)
    {
        fromView.alpha = 1.0f;
        toView.alpha = 0.0f;
        fromView.frame = fromFrame;
        NSLog(@"%.2lf,%.2lf,%.2lf,%.2lf",fromFrame.origin.x,fromFrame.origin.y,fromFrame.size.width,fromFrame.size.height);
        toView.frame = CGRectOffset(toFrame, 0,
                                    -64);
    } else
    {
        fromView.alpha = 1.0f;
        toView.alpha = 0.0f;
        fromView.frame = fromFrame;
        NSLog(@"%.2lf,%.2lf,%.2lf,%.2lf",fromFrame.origin.x,fromFrame.origin.y,fromFrame.size.width,fromFrame.size.height);
        toView.frame = CGRectOffset(toFrame, 0,
                                    44);
    }
    // We are responsible for adding the incoming view to the containerView
    // for the presentation/dismissal.
    [containerView addSubview:toView];
    
    NSTimeInterval transitionDuration = [self transitionDuration:transitionContext];
    
    [UIView animateWithDuration:transitionDuration animations:^{
        
        if(self.isFromeSearch)
        {
            fromView.alpha = 1.0f;
            toView.alpha = 1.0;
            fromView.frame = CGRectOffset(fromFrame, 0, 44);
        } else
        {
            fromView.alpha = 0.0f;
            toView.alpha = 1.0;
            fromView.frame = CGRectOffset(fromFrame, 0, -64);
        }
        toView.frame = toFrame;
    } completion:^(BOOL finished) {
        // When we complete, tell the transition context
        // passing along the BOOL that indicates whether the transition
        // finished or not.
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!wasCancelled];
    }];
}







@end

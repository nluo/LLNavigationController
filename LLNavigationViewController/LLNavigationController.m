//
//  ViewController.m
//  LLNavigationViewController
//
//  Created by Nick Luo on 11/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import "LLNavigationController.h"
#import "TestViewController.h"

#define TRANSITION_TIME .4f

@interface LLNavigationController () <UINavigationBarDelegate, UIBarPositioningDelegate>

@property (strong, nonatomic, readwrite) UIViewController *currentContentViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) BOOL transitionInProgress;

@end

@implementation LLNavigationController

@synthesize currentContentViewController = _currentContentViewController, containerView = _containerView, transitionInProgress = _transitionInProgress;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationBar.delegate = self;
    
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
         self.edgesForExtendedLayout = UIRectEdgeNone;
    }
   
    
    @try {
         [self performSegueWithIdentifier:@"SetRootViewController" sender:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Please make sure you have connected your initial view controller to the navigation controller and set the identifier to SetRootViewController. The exception is %@", exception);
        abort();
    }
    
    self.navigationBar.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self pushViewController:viewController animated:animated completion:nil];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)())completion
{
    
    if (_transitionInProgress) return;
    
    _transitionInProgress = YES;
    
    UIViewController *currentViewController = self.topViewController;
    [self addChildViewController:viewController];
    
    
    // Used when setting root view controller
    if (self.childViewControllers.count == 1) {
        viewController.view.frame = self.containerView.frame;
        [self.view addSubview:viewController.view];
        
        [self.navigationBar pushNavigationItem:viewController.navigationItem animated:NO];
        
        [viewController didMoveToParentViewController:self];
        _transitionInProgress = NO;
        return;
    }
    
    // the off-screen rect where we transition from
    CGRect offScreen = self.containerView.frame;
    
    offScreen.origin.x += offScreen.size.width;
    viewController.view.frame = offScreen;
    
    
    // Disable the current view controller interaction to prevent user click multiple times of the cell and consequently trigger the push view controler multiple times
    self.currentContentViewController.view.userInteractionEnabled = NO;
    // transition to the new view controller
    
    
    [self.navigationBar pushNavigationItem:viewController.navigationItem animated:animated];
    
    NSTimeInterval duration = animated? TRANSITION_TIME: 0;
    
    [self
     transitionFromViewController:currentViewController
     toViewController:viewController
     duration:duration
     options:UIViewAnimationOptionCurveEaseInOut
     animations:^{
         
         viewController.view.frame = self.containerView.frame;
     }
     completion:^(BOOL finished) {
         
         if (finished) {
             // enable the interaction again
             self.currentContentViewController.view.userInteractionEnabled = YES;
             
             self.currentContentViewController = viewController;

             [viewController didMoveToParentViewController:self];
             
             _transitionInProgress = NO;
             
             
             if (completion) completion();
         }
        
     }
     ];
    
    if (animated == NO) {
        [viewController didMoveToParentViewController:self];
        _transitionInProgress = NO;
    }
}

- (UIViewController *)topViewController
{
    return self.childViewControllers.lastObject;
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [self popViewControllerAnimated:animated withCompletion:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated withCompletion:(void(^)())completion
{
    if (_transitionInProgress) return nil;
    
    _transitionInProgress = YES;
    
    if (self.childViewControllers.count == 1) {
        return nil;
    }
    
    UIViewController *currentViewController = self.topViewController;
    UIViewController *toViewController = [self.childViewControllers objectAtIndex:(self.childViewControllers.count-2)];
    
    CGRect currentViewControllerSlideBackFrame = CGRectOffset(self.containerView.frame, CGRectGetWidth(self.view.frame), 0);
    CGRect toViewControllerInitialFrame = CGRectOffset(self.containerView.frame, -CGRectGetWidth(self.containerView.bounds), 0);
    
    [toViewController willMoveToParentViewController:self];

    
    toViewController.view.frame = toViewControllerInitialFrame;
    
    NSTimeInterval duration = animated? TRANSITION_TIME: 0;
    
    [self transitionFromViewController:currentViewController
                      toViewController:toViewController
                              duration:duration
                               options:UIViewAnimationOptionCurveEaseOut
                            animations:^{
                                currentViewController.view.frame = currentViewControllerSlideBackFrame;
                                toViewController.view.frame = self.containerView.frame;
                            } completion:^(BOOL finished) {
                                
                                [currentViewController willMoveToParentViewController:nil];
                                [currentViewController removeFromParentViewController];
            
                                self.currentContentViewController = toViewController;
                                
                                [toViewController didMoveToParentViewController:self];
                                if (completion) completion();
                                
                                _transitionInProgress = NO;

                            }];
    
    return toViewController;
}

- (NSArray *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    if (_transitionInProgress) return nil;
    
    _transitionInProgress = YES;

    if ([self.childViewControllers indexOfObject:viewController] == NSNotFound) {
        return nil;
    }
    
    if (self.childViewControllers.count == 1) {
        return nil;
    }
    
    _transitionInProgress = YES;
    // Create the view controllers that will be returned in this method
    NSArray *viewControllers = [[NSMutableArray alloc] init];
    viewControllers = [self.childViewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange([self.childViewControllers indexOfObject:viewController], self.childViewControllers.count-1)]];
    
    
    UIViewController *toViewController = viewController;
    UIViewController *currentViewController = self.topViewController;
    
    
    CGRect currentViewControllerSlideBackFrame = CGRectOffset(self.containerView.frame, CGRectGetWidth(self.view.frame), 0);
    CGRect toViewControllerInitialFrame = CGRectOffset(self.containerView.frame, -CGRectGetWidth(self.containerView.bounds), 0);
    
    toViewController.view.frame = toViewControllerInitialFrame;
    [currentViewController willMoveToParentViewController:nil];
    
    NSTimeInterval duration = animated ? TRANSITION_TIME : 0.f;
    
    
    [self transitionFromViewController:currentViewController
                      toViewController:toViewController
                              duration:duration
                               options:0
                            animations:^{
                                [self popToRootNavigationItem];
                                toViewController.view.frame = self.containerView.frame;
                                currentViewController.view.frame = currentViewControllerSlideBackFrame;
                            }
                            completion:^(BOOL finished) {
                                [currentViewController removeFromParentViewController];
                                [currentViewController.view removeFromSuperview];
                                
                                while (![self.topViewController isEqual:toViewController]) {
                                    UIViewController *tmp = self.topViewController;
                                    [tmp willMoveToParentViewController:nil];
                                    [tmp removeFromParentViewController];
                                }
                                
                                NSLog(@"the child VCs are %@",self.childViewControllers);

                                
                                [toViewController didMoveToParentViewController:self];
                                _transitionInProgress = NO;
                            }];
    
    
    return viewControllers;
    
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    
    if (_transitionInProgress) return nil;
    
    _transitionInProgress = YES;
    
    // if only 1 controller left we return nil
    if ([self.childViewControllers count] == 1) {
        return nil;
    }
    
    _transitionInProgress = YES;
    // Create the view controllers that will be returned in this method
    NSArray *viewControllers = [[NSMutableArray alloc] init];
    viewControllers = [self.childViewControllers objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1, self.childViewControllers.count-1)]];
    
    
    UIViewController *rootViewController = [self.childViewControllers objectAtIndex:0];
    UIViewController *currentViewController = self.topViewController;
    
    
    CGRect currentViewControllerSlideBackFrame = CGRectOffset(self.containerView.frame, CGRectGetWidth(self.view.frame), 0);
    CGRect toViewControllerInitialFrame = CGRectOffset(self.containerView.frame, -CGRectGetWidth(self.containerView.bounds), 0);
    
    rootViewController.view.frame = toViewControllerInitialFrame;
    [currentViewController willMoveToParentViewController:nil];
    
    NSTimeInterval duration = animated ? TRANSITION_TIME : 0.f;
    

    [self transitionFromViewController:currentViewController
                      toViewController:rootViewController
                              duration:duration
                               options:0
                            animations:^{
                                [self popToRootNavigationItem];
                                rootViewController.view.frame = self.containerView.frame;
                                currentViewController.view.frame = currentViewControllerSlideBackFrame;
                            }
                            completion:^(BOOL finished) {
                                [currentViewController removeFromParentViewController];
                                [currentViewController.view removeFromSuperview];
                                
                                while (self.childViewControllers.count > 1) {
                                    UIViewController *tmp = [self.childViewControllers lastObject];
                                    [tmp willMoveToParentViewController:nil];
                                    [tmp removeFromParentViewController];
                                }
                                
                                NSLog(@"the child VCs are %@",self.childViewControllers);
                               
                                self.currentContentViewController = rootViewController;
                                
                                [rootViewController didMoveToParentViewController:self];
                                _transitionInProgress = NO;
                            }];
    
    
    return viewControllers;
}


// A recursion method to pop the navigation item
- (void)popToRootNavigationItem
{
    NSArray *navigationItems = self.navigationBar.items;
    
    if (navigationItems.count == 1) {
        return;
    }
    
    if (navigationItems.count == 2) {
        [self.navigationBar popNavigationItemAnimated:YES];
    } else {
        [self.navigationBar popNavigationItemAnimated:NO];
    }

    [self popToRootNavigationItem];
}

#pragma mark UINavigationBar Delegate

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
{
    return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item
{
    
}
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{
    if (!_transitionInProgress) {
        [self popViewControllerAnimated:YES];
    }

    return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    
}

#pragma mark - UIBarPosition Delegate

- (UIBarPosition)positionForBar:(id <UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end

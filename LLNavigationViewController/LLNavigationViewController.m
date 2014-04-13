//
//  ViewController.m
//  LLNavigationViewController
//
//  Created by Nick Luo on 11/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import "LLNavigationViewController.h"
#import "TestViewController.h"

#define TRANSITION_TIME 0.4f

@interface LLNavigationViewController () <UINavigationBarDelegate>

@property (strong, nonatomic, readwrite) UIViewController *currentContentViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) BOOL transitionInProgress;

@end

@implementation LLNavigationViewController

@synthesize currentContentViewController = _currentContentViewController, containerView = _containerView, transitionInProgress = _transitionInProgress;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [self initWithNibName:nil bundle:nil];
    
    if (self) {
        [self addChildViewController:rootViewController];
        self.currentContentViewController = rootViewController;
        
        [rootViewController didMoveToParentViewController:self];
        
        [self.view addSubview:rootViewController.view];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    NSLog(@"push view controller");
    [self addChildViewController:viewController];
    
//    _transitionInProgress = YES;
    // the off-screen rect where we transition from
    CGRect offScreen = self.containerView.bounds;
    
    offScreen.origin.x += offScreen.size.width;
    viewController.view.frame = offScreen;
    
    
    // Disable the current view controller interaction to prevent user click multiple times of the cell and consequently trigger the push view controler multiple times
    self.currentContentViewController.view.userInteractionEnabled = NO;
    // transition to the new view controller
    
//    NSString *newVCTitle = viewController.title;
    
//    if (!newVCTitle) {
//        newVCTitle = [self navBarTitle].title;
//    }
    
//    UINavigationItem *newNavItem = [[UINavigationItem alloc] initWithTitle:newVCTitle]; //[self.navBarTitle title]
//    newNavItem.rightBarButtonItems = [self.navBarTitle rightBarButtonItems];
//    newNavItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
//    [self.navBar pushNavigationItem:newNavItem animated:YES];
    
    
    [self.navigationBar pushNavigationItem:viewController.navigationItem animated:YES];
    
    [self
     transitionFromViewController:self.currentContentViewController
     toViewController:viewController
     duration:TRANSITION_TIME
     options:UIViewAnimationOptionCurveEaseOut
     animations:^{
         
         viewController.view.frame = self.containerView.bounds;
     }
     completion:^(BOOL finished) {
         
         // enable the interaction again
         self.currentContentViewController.view.userInteractionEnabled = YES;
         
         self.currentContentViewController = viewController;
         //[self configureBackButton];
         [viewController didMoveToParentViewController:self];
         
//         _transitionInProgress = NO;
     }
     ];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [self popViewControllerAnimated:animated withCompletion:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated withCompletion:(void(^)())completion
{
    if (self.childViewControllers.count == 1) {
        return nil;
    }
    
    _transitionInProgress = YES;
    
    UIViewController *currentViewController = self.currentContentViewController;
    UIViewController *toViewController = [self.childViewControllers objectAtIndex:(self.childViewControllers.count-2)];
    
    [self.view bringSubviewToFront:currentViewController.view];
    
    CGRect currentViewControllerSlideBackFrame = CGRectOffset(currentViewController.view.frame, CGRectGetWidth(self.view.frame), 0);
    CGRect toViewControllerInitialFrame = CGRectOffset(currentViewController.view.frame, -CGRectGetWidth(self.view.frame), 0);
    
    [toViewController willMoveToParentViewController:self];
    
    toViewController.view.frame = toViewControllerInitialFrame;
    
    [self.containerView insertSubview:toViewController.view belowSubview:currentViewController.view];
    
    NSTimeInterval animTime = animated ? TRANSITION_TIME : 0;
    
    [UIView animateWithDuration:animTime animations:^(void){
        currentViewController.view.frame = currentViewControllerSlideBackFrame;
        toViewController.view.frame = self.containerView.bounds;
        
        
    } completion:^(BOOL finished) {
        
        [currentViewController removeFromParentViewController];
        [currentViewController.view removeFromSuperview];

        self.currentContentViewController = toViewController;

        [toViewController didMoveToParentViewController:self];
        if (completion) completion();

        _transitionInProgress = NO;
        
    }];
    
    return toViewController;
}

- (void)popToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self setRootViewController:segue.destinationViewController];
}

- (void)setRootViewController: (UIViewController *)rootViewController
{
    [self addChildViewController:rootViewController];
    [rootViewController didMoveToParentViewController:self];
    self.currentContentViewController = rootViewController;
    
    self.navigationItem.title = rootViewController.title;
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
    [self popViewControllerAnimated:YES];
    
    return YES;
}
- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    
}

@end

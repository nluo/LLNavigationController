//
//  ViewController.m
//  LLNavigationViewController
//
//  Created by Nick Luo on 11/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import "ViewController.h"
#import "TestViewController.h"

#define TRANSITION_TIME 0.4f

@interface ViewController ()

@property (strong, nonatomic, readwrite) UIViewController *currentContentViewController;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation ViewController

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
    
    for (UINavigationItem *item in self.navigationBar.items) {
        
            NSLog(@"the navigation bar items are %@", item);
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self setRootViewController:segue.destinationViewController];
}

- (void)setRootViewController: (UIViewController *)rootViewController
{
    [self addChildViewController:rootViewController];
    [rootViewController didMoveToParentViewController:self];
    self.currentContentViewController = rootViewController;
    
    [self.navigationBar pushNavigationItem:rootViewController.navigationItem animated:YES];
}

@end

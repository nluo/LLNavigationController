//
//  ViewController.h
//  LLNavigationViewController
//
//  Created by Nick Luo on 11/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (nonatomic, readonly, retain) UIViewController *topViewController;


- (id)initWithRootViewController: (UIViewController *)rootViewController;


/**
 Push the child view controller into its parent stack and updates the display
 
 @param childController the child controller to push in
 
 @discussion  Push the child view controller into its parent stack and updates the display, the animation will be the same as what the UINavigationController pushViewController uses
 */


- (void)pushViewController:(UIViewController *)viewController;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void(^)())completion;


- (void) popToViewController: (UIViewController *)viewController animated:(BOOL)animated;

- (NSArray *) popToRootViewControllerAnimated: (BOOL)animated;

- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (UIViewController *)popViewControllerAnimated:(BOOL)animated withCompletion:(void(^)())completion;

@end

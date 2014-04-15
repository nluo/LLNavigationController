//
//  BaseViewController.m
//  LLNavigationViewController
//
//  Created by Nick Luo on 13/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import "BaseViewController.h"
#import "LLNavigationController.h"
#import "UIViewController+LLNavigation.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"VC %lu", (unsigned long)self.llNavigationController.childViewControllers.count];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)pushViewController:(id)sender {
    LLNavigationController *nav = (LLNavigationController *)self.parentViewController;
    BaseViewController *base = [self.storyboard instantiateViewControllerWithIdentifier:@"BaseVC"];
    
    [nav pushViewController:base animated:YES];
}
- (IBAction)popToRootViewController:(id)sender {
    LLNavigationController *nav = (LLNavigationController *)self.parentViewController;
    [nav popToRootViewControllerAnimated:YES];

}

- (IBAction)popToViewController:(id)sender {
    NSLog(@"pop to  view controller");
    LLNavigationController *nav = (LLNavigationController *)self.parentViewController;
    UIViewController *rootViewController = nav.childViewControllers[1];
    
    [nav popToViewController:rootViewController animated:YES];
}
@end

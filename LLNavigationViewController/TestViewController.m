//
//  TestViewController.m
//  LLNavigationViewController
//
//  Created by Nick Luo on 13/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import "TestViewController.h"
#import "BaseViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    // Do any additional setup after loading the view from its nib.
    NSLog(@"hey");
    self.title = @"hello";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)press:(id)sender {
    NSLog(@"pressed %@", self.LLNav);
    BaseViewController *base = [[BaseViewController alloc] initWithNibName:nil bundle:nil];

    [self.LLNav pushViewController:base animated:YES comple	tion:nil];
}


- (ViewController *)LLNav {

    return (ViewController *)self.parentViewController;
}
@end
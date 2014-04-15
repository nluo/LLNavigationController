//
//  pushViewControllerSegue.m
//  LLNavigationViewController
//
//  Created by Nick Luo on 15/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import "pushViewControllerSegue.h"
#import "LLNavigationViewController.h"

@implementation pushViewControllerSegue

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[LLNavigationViewController class]]) {
        
        [(LLNavigationViewController *)self.sourceViewController pushViewController:(UIViewController *)self.destinationViewController animated:NO];
    } else {
        
        UIViewController *temp = self.sourceViewController;
        [(LLNavigationViewController *)temp.parentViewController pushViewController:(UIViewController *)self.destinationViewController animated:YES];
    }
    
}

@end

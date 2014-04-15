//
//  pushViewControllerSegue.m
//  LLNavigationViewController
//
//  Created by Nick Luo on 15/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import "pushViewControllerSegue.h"
#import "LLNavigationController.h"

@implementation pushViewControllerSegue

- (void)perform {
    if ([self.sourceViewController isKindOfClass:[LLNavigationController class]]) {
        
        [(LLNavigationController *)self.sourceViewController pushViewController:(UIViewController *)self.destinationViewController animated:NO];
    } else {
        
        UIViewController *temp = self.sourceViewController;
        [(LLNavigationController *)temp.parentViewController pushViewController:(UIViewController *)self.destinationViewController animated:YES];
    }
    
}

@end

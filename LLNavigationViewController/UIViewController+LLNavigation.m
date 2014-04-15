//
//  UIViewController+LLNavigation.m
//  LLNavigationController
//
//  Created by Nick Luo on 16/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import "UIViewController+LLNavigation.h"

@implementation UIViewController (LLNavigation)

- (LLNavigationController *)llNavigationController
{
    return (LLNavigationController *)self.parentViewController;
}

@end

//
//  TestViewController.h
//  LLNavigationViewController
//
//  Created by Nick Luo on 13/04/2014.
//  Copyright (c) 2014 Nick Luo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLNavigationViewController.h"

@interface TestViewController : UIViewController

@property (readonly,nonatomic, getter = LLNav) LLNavigationViewController *LLNav;

@end

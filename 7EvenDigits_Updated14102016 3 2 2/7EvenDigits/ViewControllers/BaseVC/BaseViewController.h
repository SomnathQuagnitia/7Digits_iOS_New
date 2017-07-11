//
//  BaseViewController.h
//  7EvenDigits
//
//  Created by Krishna on 11/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;
@class AppDelegate;

@interface BaseViewController : UIViewController
{
    AppDelegate *objAppDelegate;
    MenuViewController *objMenuViewController;
    //UIButton *overlappingView;
}
@property (nonatomic,strong)    MenuViewController *objMenuViewController;

- (void)slideViewWithAnimation;
@end

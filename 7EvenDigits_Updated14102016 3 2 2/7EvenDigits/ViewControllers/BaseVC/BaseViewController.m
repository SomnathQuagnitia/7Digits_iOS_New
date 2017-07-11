//
//  BaseViewController.m
//  7EvenDigits
//
//  Created by Krishna on 11/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "BaseViewController.h"
#import "MenuViewController.h"
#import "AppDelegate.h"

@interface BaseViewController ()

@end

@implementation BaseViewController
@synthesize objMenuViewController;

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
    objAppDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //overlappingView = [[UIButton alloc] initWithFrame:CGRectZero];
    //[overlappingView addTarget:self action:@selector(slideViewWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)slideViewWithAnimation
{
    if (objMenuViewController == nil)
    {
        objMenuViewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:[NSBundle mainBundle]];
    }
    objMenuViewController.perentClass = self;
    objMenuViewController.perentView = self.view;
    objMenuViewController.navigationBar = self.navigationController.navigationBar;
    UINavigationBar *navigationBar = (UINavigationBar *)self.navigationController.navigationBar;
    if (self.view.frame.origin.x == 0)
    {
//        self.view.userInteractionEnabled = FALSE;
        [objMenuViewController.view setFrame:CGRectMake(-objMenuViewController.view.frame.size.width,0,objMenuViewController.view.frame.size.width,SCREEN_HEIGHT)];
        [navigationBar setFrame:CGRectMake(0, 20, navigationBar.frame.size.width, navigationBar.frame.size.height)];
        [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:objMenuViewController.view cache:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
        [self.view setFrame:CGRectMake(objMenuViewController.view.frame.size.width, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [navigationBar setFrame:CGRectMake(objMenuViewController.view.frame.size.width, 20, navigationBar.frame.size.width, navigationBar.frame.size.height)];
        [objMenuViewController.view setFrame:CGRectMake(0,0,objMenuViewController.view.frame.size.width,SCREEN_HEIGHT)];
        if ([objMenuViewController.view isDescendantOfView:objAppDelegate.window])
        {
            [objMenuViewController.view removeFromSuperview];
        }
        //overlappingView.tag = 999;
        [objAppDelegate.window addSubview:objMenuViewController.view];
        
        

        
        [UIView commitAnimations];
    }
    else
    {
        //if ([overlappingView isDescendantOfView:objAppDelegate.window])
        //{
        //    [overlappingView removeFromSuperview];
        //}
        
//        self.view.userInteractionEnabled = TRUE;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.7f];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:objMenuViewController.view cache:YES];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.view cache:YES];
        [objMenuViewController.view setFrame:CGRectMake(-objMenuViewController.view.frame.size.width,0,objMenuViewController.view.frame.size.width,SCREEN_HEIGHT)];
        [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [navigationBar setFrame:CGRectMake(0, 20, navigationBar.frame.size.width, navigationBar.frame.size.height)];
        [UIView commitAnimations];
    }
}

@end

//
//  SplashViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize loginViewController;
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
//    loginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
//    [loginViewController firstimagetouch];

    self.navigationController.navigationBarHidden=YES;
    
    timer=[NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(touch) userInfo:nil repeats:NO];
}

-(void)touch
{
//    [self.navigationController pushViewController:loginViewController animated:YES];
    loginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.navigationController pushViewController:loginViewController animated:YES];
//    [self dismissViewControllerAnimated:NO completion:nil];
    [timer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

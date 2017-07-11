//
//  HomeViewController.m
//  7EvenDigits
//
//  Created by Neha_Mac on 10/12/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "HomeViewController.h"
#import "Constant.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

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
    self.navigationController.navigationBarHidden=YES;
    objAppDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden =true;
}
- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden =true;
    [self callMenuVC];
}
-(void)callMenuVC
{
    [self slideViewWithAnimation];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

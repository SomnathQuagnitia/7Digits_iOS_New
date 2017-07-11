//
//  AboutUsViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "AboutUsViewController.h"
#import "MenuViewController.h"
#import "HomeViewController.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    self.title=@"About Us";
    
    self.navigationController.navigationBarHidden=NO;

//   self.aboutUsWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, 320, 450)];
//    self.aboutUsWebView.delegate=self;
//    [self.aboutUsWebView setUserInteractionEnabled:YES];
//    self.aboutUsWebView.scrollView.scrollEnabled = TRUE;
//    self.aboutUsWebView.scrollView.scrollEnabled=YES;
//    [self.view addSubview: self.aboutUsWebView];
    
    
    UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=menuBarBtn;
}
- (NSURLRequest *)setDocFileFromMainBundleWithFileName:(NSString *)fileName
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSURL *targetURL = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    return request;
}

#pragma mark UIWebView Delegate
- (BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    if ( inType == UIWebViewNavigationTypeLinkClicked )
    {
        //[[UIApplication sharedApplication] openURL:[inRequest URL]];
        [[UIApplication sharedApplication] openURL:[inRequest URL] options:@{} completionHandler:nil];

        return NO;
    }
    return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    if ([self setDocFileFromMainBundleWithFileName:@"AboutUs"] != nil)
    {
        [self.aboutUsWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"AboutUs" ofType:@"html"]isDirectory:NO]]];
        [self.aboutUsWebView.scrollView setScrollEnabled:YES];
        self.aboutUsWebView.scrollView.showsHorizontalScrollIndicator = NO;
        self.aboutUsWebView.scrollView.showsVerticalScrollIndicator = NO;
        //        [InfoWebViewObj loadRequest:[self setDocFileFromMainBundleWithFileName:@"page1"]];
    }
   
}


#pragma mark==Navigate to home view
-(void)handelHome
{
    //[self slideViewWithAnimation];
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

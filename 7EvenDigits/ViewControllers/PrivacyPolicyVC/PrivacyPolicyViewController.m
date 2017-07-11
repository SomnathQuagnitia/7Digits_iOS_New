//
//  PrivacyPolicyViewController.m
//  7EvenDigits
//
//  Created by Krishna on 09/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

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
    
    self.navigationController.navigationBarHidden=NO;
    
     self.title=@"Privacy Policy";
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
}
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
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
         [[UIApplication sharedApplication] openURL:[inRequest URL] options:@{} completionHandler:nil];
          //[[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}


- (void)viewWillAppear:(BOOL)animated
{
    if ([self setDocFileFromMainBundleWithFileName:@"PrivcyPolicy"] != nil)
    {
        [self.privacyPolicyWebView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"PrivcyPolicy" ofType:@"html"]isDirectory:NO]]];
        [self.privacyPolicyWebView.scrollView setScrollEnabled:YES];
        //        [InfoWebViewObj loadRequest:[self setDocFileFromMainBundleWithFileName:@"page1"]];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  LoginViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "LoginViewController.h"
#import "Parameters.h"
#import "ForgetPasswordVC.h"
#import "RegistrationViewController.h"
#import "ForgetPasswordVC.h"
#import "InboxDetailsViewController.h"
#import "SplashViewController.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize textFieldForPassword,textFieldForUserName,splashViewController;

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
 

    textFieldForUserName.text=@"";
    textFieldForPassword.text=@"";


    self.title=@"Login";
    self.navigationController.navigationBarHidden=YES;
    
    [Parameters addPaddingView:textFieldForUserName];
    [Parameters addPaddingView:textFieldForPassword];
    
    vidIDArr = [[NSArray alloc]initWithObjects:@"FIXQB3NAhR4?autoplay=1&amp;rel=0",@"7ERpVgQTogw?autoplay=1&amp;rel=0",@"rjYSG2i0k_M?autoplay=1&amp;rel=0",@"NvZOSPMGpiQ?autoplay=1&amp;rel=0", nil];
    
    pageControl.numberOfPages = vidIDArr.count;
    int x = 0;
    int constantDist = 0;
    CGFloat width = 0;
    
    if (SCREEN_HEIGHT< 568.0)//iphone 4
    {
        x = 25;
        width = 275;
        scrollAndVideoheight = 140;
        constantDist=23;
    }
    if (SCREEN_HEIGHT == 568.0)//iphone 5
    {
        x = 25;
        width = 275;
        scrollAndVideoheight = 140;
        constantDist=23;
    }
    if (SCREEN_HEIGHT == 667.0)//iphone 6
    {
        x = 36;
        width = 325;
        scrollAndVideoheight = 250;
        constantDist=25;
    }
    if (SCREEN_HEIGHT > 667.0)//iphone  6+
    {
        x = 40;
        width = 350;
        scrollAndVideoheight = 300;
        constantDist=35;
    }
    
    [self setScrollView];
    
    for(int i=0; i<vidIDArr.count; i++) {
        UIWebView *webView =[[UIWebView alloc]initWithFrame:CGRectMake(x, 0, width, scrollAndVideoheight)];
        [self setupVideo:webView videoID:[vidIDArr objectAtIndex:i]];
        [scrollWebView addSubview:webView];
        x=x+constantDist+constantDist+width;
    }
    
 }
-(void)setScrollView
{
    CGSize size = [self getScreenSize];
    int y = 350;
    
    if (SCREEN_HEIGHT< 568.0)//iphone 4
    {
        y = 320;
    }
    scrollWebView.frame = CGRectMake(0,y, SCREEN_WIDTH, scrollAndVideoheight);
    scrollWebView.delegate = self;
    scrollWebView.pagingEnabled = YES;
    scrollWebView.showsHorizontalScrollIndicator = NO;
    scrollWebView.showsVerticalScrollIndicator = NO;
    scrollWebView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, size.height);
    [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}

- (void)scrollingTimer {
    // access the scroll view with the tag
    // get the current offset ( which page is being displayed )
    CGFloat contentOffset = scrollWebView.contentOffset.x;
    // calculate next page to display
    int nextPage = (int)(contentOffset/SCREEN_WIDTH)+1;
    [self setAnimation:scrollWebView];
    if( nextPage!= 4)
    {
        [scrollWebView scrollRectToVisible:CGRectMake(nextPage*SCREEN_WIDTH, 0, SCREEN_WIDTH, scrollWebView.frame.size.height) animated:YES];
        pageControl.currentPage = nextPage;
    }
    else
    {
        [scrollWebView scrollRectToVisible:CGRectMake(0, 0, SCREEN_WIDTH, scrollWebView.frame.size.height) animated:NO];
        pageControl.currentPage = 0;
    }
}
- (void)setAnimation:(UIView *)view
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [view.layer addAnimation:transition forKey:@"transition"];
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
     CGSize size = [self getScreenSize];
    CGFloat pageWidth = size.width;
    int page = floor((scrollWebView.contentOffset.x+24 - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}
-(CGSize )getScreenSize
{
    CGSize size;
    if (SCREEN_HEIGHT < 490) { //iphone 4
        size.width =280;
        size.height= 140 ;
    }
    if (SCREEN_HEIGHT > 490 && SCREEN_HEIGHT < 560)
    {
        size.width =280;
        size.height= 140 ; //iphone 5
    }
    if (SCREEN_HEIGHT > 560 )
    {
        size.width =280;
        size.height= 170 ; //iphone 6
    }
    return size;
}
- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = scrollWebView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    scrollWebView.frame = CGRectMake(25, scrollWebView.frame.origin.y, scrollWebView.frame.size.width, scrollWebView.frame.size.height);
    frame.size  = scrollWebView.frame.size;
    [scrollWebView scrollRectToVisible:frame animated:YES];
}

 

-(void)touchDetected
{
    splashViewController=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:nil];
    [self presentViewController:splashViewController animated:NO completion:nil];

}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden=YES;
    [textFieldForPassword resignFirstResponder];
    [textFieldForUserName resignFirstResponder];

    textFieldForUserName.text=@"";
    textFieldForPassword.text=@"";
    

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)firstimagetouch
{
//     CGSize size = [self getScreenSize];
    
//    self.webViewForVideo11.frame = CGRectMake(25, scrollWebView.frame.origin.y, scrollWebView.frame.size.width, size.height);
//    self.webViewForVideo12.frame = CGRectMake(25, scrollWebView.frame.origin.y, scrollWebView.frame.size.width, size.height);
//    self.webViewForVideo21.frame = CGRectMake(25, scrollWebView.frame.origin.y, scrollWebView.frame.size.width, size.height);
//    self.webViewForVideo22.frame = CGRectMake(25, scrollWebView.frame.origin.y, scrollWebView.frame.size.width, size.height);
//    
//    
//    [self setupVideo:self.webViewForVideo11 videoID:@"FIXQB3NAhR4?autoplay=1&amp;rel=0"];
//    [self setupVideo:self.webViewForVideo12 videoID:@"7ERpVgQTogw?autoplay=1&amp;rel=0"];
//    [self setupVideo:self.webViewForVideo21 videoID:@"rjYSG2i0k_M?autoplay=1&amp;rel=0"];
//    [self setupVideo:self.webViewForVideo22 videoID:@"NvZOSPMGpiQ?autoplay=1&amp;rel=0"];   
}


-(IBAction)handleJoinNow:(id)sender
{
    RegistrationViewController *regVC=[[RegistrationViewController alloc]initWithNibName:@"RegistrationViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:regVC animated:YES];
    
}
-(IBAction)handleSignIn:(id)sender
{
    [currentTextFeild resignFirstResponder];
    
    if([self checkTextfield])
    {
        appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
        
        if (appDeleagated.internetStatus==0)
        {
              [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
        }
        else
        {
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];

            if (serviceIntegration != nil)
            {
                serviceIntegration = nil;
            }
            serviceIntegration = [[ServerIntegration alloc]init];
            
            
            if(appDeleagated.iOSDeviceToken.length>0 )
            {
            
                [serviceIntegration LoginWebService:self UserName:textFieldForUserName.text Password:textFieldForPassword.text DeviceId:appDeleagated.iOSDeviceToken IsBackground:@"False" :@selector(receivedResponseDataLogin:)];
            }
            else
            {
            
                [serviceIntegration LoginWebService:self UserName:textFieldForUserName.text Password:textFieldForPassword.text DeviceId:@"" IsBackground:@"False" :@selector(receivedResponseDataLogin:)];
            }
        }
    }
}

-(IBAction)handleForgotPassword:(id)sender
{
    ForgetPasswordVC *forgetPasswordVC=[[ForgetPasswordVC alloc]initWithNibName:@"ForgetPasswordVC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}

- (IBAction)handlePinterestLink:(id)sender
{
    NSString *pinterestUrlString = @"https://www.pinterest.com/7evendigits/";
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pinterestUrlString]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pinterestUrlString] options:@{} completionHandler:nil];
}

- (IBAction)handleTwitterLink:(id)sender
{
    NSString *twitterUrlString  = @"https://twitter.com/7evendigits";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterUrlString] options:@{} completionHandler:nil];
}

- (IBAction)handleFacebookLink:(id)sender
{
    NSString *facebookUrlString = @"https://www.facebook.com/7evendigits";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookUrlString] options:@{} completionHandler:nil];
}

-(IBAction)handleForgotUsername:(id)sender
{
    ForgotUserNameViewController *usernameVC=[[ForgotUserNameViewController alloc]initWithNibName:@"ForgotUserNameViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:usernameVC animated:YES];
}

#pragma mark== Validate TextFields
-(BOOL)checkTextfield
{
    if (textFieldForUserName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:sEnterUserName maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if (textFieldForPassword.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:sEnterPassword maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    return YES;
}

#pragma mark==Text Field Delegates
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextFeild=textField;
    [Parameters moveTextFieldUpForView:self.view forTextField:textField forSubView:self.view];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 50; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)setupVideo:(UIWebView *)viewVideoWebView videoID:(NSString *)videoId
{
    @try
    {
//        if (SCREEN_HEIGHT > 560 )
//        {
//            scrollWebView.frame = CGRectMake(scrollWebView.frame.origin.x, scrollWebView.frame.origin.y+10,SCREEN_WIDTH, 260);
//            if(viewVideoWebView.frame.origin.x == 24)
//            {
////                viewVideoWebView.frame = CGRectMake(viewVideoWebView.frame.origin.x+50, viewVideoWebView.frame.origin.y, 375, 260);
//                [self.webViewForVideo11 setFrame:CGRectMake(self.webViewForVideo11.frame.origin.x, self.webViewForVideo11.frame.origin.y, 375, 260)];
//            }
//            else if(viewVideoWebView.frame.origin.x == 345)
//            {
//                 self.webViewForVideo12.frame = CGRectMake(self.webViewForVideo12.frame.origin.x+25, self.webViewForVideo11.frame.origin.y, 375, 260);
//            }
//            else if(viewVideoWebView.frame.origin.x == 665)
//            {
//                self.webViewForVideo21.frame = CGRectMake(self.webViewForVideo12.frame.origin.x+25, self.webViewForVideo11.frame.origin.y, 375, 260);
//            }
//            else if(viewVideoWebView.frame.origin.x == 985)
//            {
//                self.webViewForVideo22.frame = CGRectMake(self.webViewForVideo12.frame.origin.x+25, self.webViewForVideo11.frame.origin.y, 375, 260);
//            }
//        }
        // NSString *videoId = [hookMessage getString:@"system_youtube"];
        BOOL valid = [self isValidVideo:videoId];
        if (valid)
        {

        NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"ini tial-scale = 1.0, user-scalable = no, width = %f\"/></head><body style=\"background:#FFF;margin-top:0px;margin-left:0px\"><div><object width=\"%f\" height=\"%f\"> <embed src=\"https://www.youtube.com/v/%@\" type=\"application/x-shockwave-flash\" wmode=\"black\" allowscriptaccess=\"always\" width=\"%f\" height=\"%f\"></embed></object></div></body></html>",viewVideoWebView.frame.size.width,viewVideoWebView.frame.size.width,viewVideoWebView.frame.size.height,videoId,viewVideoWebView.frame.size.width,viewVideoWebView.frame.size.height];
            
            //NSString *htmlString = [NSString stringWithFormat:@"<iframe width=\"%f\" height=\"%f\" src=\"http://www.youtube.com/embed/%@\" frameborder=\"0\"></iframe>",viewVideoWebView.frame.size.width,viewVideoWebView.frame.size.height,videoId];
           
            
            viewVideoWebView.scrollView.scrollEnabled = NO;
            [viewVideoWebView loadHTMLString:htmlString baseURL:nil];
        }
        else
        {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"NoYoutubeVideo" ofType:@"png"];
            [viewVideoWebView loadHTMLString:[NSString stringWithFormat:@"<html><head></head><body style=\"margin:0\">  <img src=\"file://%@\" \"width=\"%0.0f\" height=\"%0.0f\"> </body></html>",path,viewVideoWebView.frame.size.width, viewVideoWebView.frame.size.height] baseURL:nil];
        }
    }
    @catch (NSException *ex)
    {
		//[DebugHelper handleException:__FILE__ function:NSStringFromSelector(_cmd) exception:ex];
    }
}
- (BOOL)isValidVideo:(NSString *)videoId
{
    @try
    {
        NSString *apiMethodStr = [NSString stringWithFormat:@"http://www.youtube-nocookie.com/embed/%@?v=2&alt=json", videoId];
        NSString *fetchedProperies = [NSString stringWithContentsOfURL:[NSURL URLWithString:apiMethodStr] encoding:NSUTF8StringEncoding error:nil];
        return fetchedProperies != nil;
    }
    @catch (NSException *ex)
    {
		//[DebugHelper handleException:__FILE__ function:NSStringFromSelector(_cmd) exception:ex];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Service IntegrationDelegate
- (void)receivedResponseDataLogin:(NSDictionary *)responseDict
{
    NSLog(@"%@",responseDict);
    
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD dismiss];
        CURRENT_USER_ID = [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"UserId"]];
        CURRENT_USER_NAME= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"UserName"]];
        CURRENT_USER_IMAGE= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"Image"]];
        
        NSUserDefaults *applicationUserDefault;
        
        applicationUserDefault = [NSUserDefaults standardUserDefaults];
        [applicationUserDefault setValue:textFieldForUserName.text forKey:@"CURRENT_USER_NAME"];
        [applicationUserDefault setValue:textFieldForPassword.text forKey:@"CURRENT_USER_PASSWORD"];
        [applicationUserDefault setValue:CURRENT_USER_ID forKey:@"CURRENT_USER_ID"];
        [applicationUserDefault setValue:CURRENT_USER_IMAGE forKey:@"CURRENT_USER_IMAGE"];
        [applicationUserDefault synchronize];
        

        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [Parameters moveTextFieldDownforView:self.view];
    
    return YES;
}

@end

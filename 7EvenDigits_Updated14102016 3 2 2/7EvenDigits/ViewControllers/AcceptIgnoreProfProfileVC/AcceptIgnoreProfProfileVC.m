//
//  AcceptIgnoreProfProfileVC.m
//  7EvenDigits
//
//  Created by Neha_Mac on 30/06/15.
//  Copyright (c) 2015 Quagnitia Systems. All rights reserved.
//

#import "AcceptIgnoreProfProfileVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AcceptIgnoreProfProfileVC ()

@end

@implementation AcceptIgnoreProfProfileVC

@synthesize professionalProfileArray,fullNameLabel,userIdLabel,notesDetailWebView,titleLabel,companyLabel,userImage,digitsButton,addressTextView,playVideoUrl,playBtn,acceptBtn,ignoreBtn;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    playVideoUrl = [[NSString alloc]init];
    VideoData = [[NSData alloc]init];
    
    self.navigationController.navigationBarHidden = NO;
    [profileScrollView setContentSize:CGSizeMake(0, 950)];
    
    self.title=@"Professional Profile";
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    stringForTitle=self.title;
    
    currentUserProfileId = [[professionalProfileArray objectAtIndex:0] valueForKey:@"ProfileId"];
    
    [self setNavigationBarButtons];
    [Parameters addBorderToView:acceptBtn];
    [Parameters addBorderToView:ignoreBtn];
    
    //    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(handelUpdate)];
    //
    //
    //    [rightBarBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
    //                                         [UIFont fontWithName:@"Helvetica Neue" size:16], NSFontAttributeName,
    //                                         [UIColor whiteColor], NSForegroundColorAttributeName,
    //                                         nil]
    //                               forState:UIControlStateNormal];
    //
    //
    //    self.navigationItem.rightBarButtonItem=rightBarBtn;
    [self callViewProfileWS];
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)callViewProfileWS
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
        [serviceIntegration ViewInboxOtherUserProfile:self profileId:[[professionalProfileArray objectAtIndex:0] valueForKey:@"ProfileId"] :@selector(receivedResponseViewProfileProfWS:)];
        
    }
}
- (void)receivedResponseViewProfileProfWS:(NSArray *)responseDict
{
    [SVProgressHUD dismiss];
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        professionalProfileArray = [[NSMutableArray alloc]init];
        [professionalProfileArray addObject:responseDict];
        [self setProfessionalProfileData];
    }
    else
    {
        
    }
}


-(void)setProfessionalProfileData
{
    self.fullNameLabel.text= [NSString stringWithFormat:@"%@ %@",[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"FirstName" ],[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"LastName"]];
    self.userIdLabel.text=[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserName"];
    self.titleLabel.text =[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserTitle"];
    self.companyLabel.text =[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserCompany"];
    
    //    self.addressTextView.text =[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserAddress"];
    
    if([[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserAddress"] isEqualToString:@"(null)"])
    {
        self.addressTextView.text =@"";
    }
    else
    {
        
        addressString = [[NSMutableString alloc]init];
        NSString *str = [[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserAddress"];
        if (str.length > 0)
        {
            NSArray *arr = [str componentsSeparatedByString:@"\n"];
            if (arr.count > 0)
            {
                if (arr.count == 1) {
                    
                    if (![[arr objectAtIndex:0] isEqualToString:@"Address1"])
                    {
                        [addressString appendFormat:@"%@\n",[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]]];
                    }
                }
                else if (arr.count == 2)
                {
                    if (![[arr objectAtIndex:0] isEqualToString:@"Address1"])
                    {
                        [addressString appendFormat:@"%@\n",[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]]];
                    }
                    
                    if (![[arr objectAtIndex:1] isEqualToString:@"Address2"]) {
                        [addressString appendFormat:@"%@\n",[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]]];
                    }
                }
                else if (arr.count == 3) {
                    if (![[arr objectAtIndex:0] isEqualToString:@"Address1"])
                    {
                        [addressString appendFormat:@"%@\n",[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]]];
                    }
                    
                    if (![[arr objectAtIndex:1] isEqualToString:@"Address2"]) {
                        [addressString appendFormat:@"%@\n",[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]]];
                    }
                    
                    if (![[arr objectAtIndex:2] isEqualToString:@"Address3"]) {
                        [addressString appendFormat:@"%@",[NSString stringWithFormat:@"%@",[arr objectAtIndex:2]]];
                    }
                }
                if (addressString.length > 0)
                {
                    self.addressTextView.text = addressString;
                }
            }
            else
            {
                self.addressTextView.text = [[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserAddress"];
            }
        }
        else
        {
            self.addressTextView.text = @"";
        }
    }
    
    [self.addressTextView setFont:[UIFont systemFontOfSize:16]];
    self.emailLabel.text =[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"EmailId"];
    
    [self.digitsButton setTitle:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"PhoneNumber" ] forState:UIControlStateNormal];
    [self.mobileButton setTitle:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"MobileNumber" ] forState:UIControlStateNormal];
    [self.workButton setTitle:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"WorkNumber" ] forState:UIControlStateNormal];
    [self.notesDetailWebView setUserInteractionEnabled:NO];
    
    //for emogies
    //    NSString *usernote = [Parameters insertNewLineInText:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserNotes" ]];
    
    NSString *notesStr = [Parameters decodeDataForEmogies:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserNotes" ]];
    if(![notesStr isEqual:[NSNull null]])
    {
        
        [self.notesDetailWebView loadHTMLString:[Parameters insertNewLineInText:notesStr] baseURL:nil];
    }
    
    self.notesDetailWebView.delegate = self;
    CGFloat height = [[self.notesDetailWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight;"] floatValue];
    
    [profileDataScrollView setContentSize:CGSizeMake(0, height+100)];
    
    
    [self.digitsButton addTarget:self action:@selector(handleCallButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileImageName" ]];
    
    if ([urlStr hasSuffix:@"default_Contact.png"] || [urlStr hasSuffix:@"noimage.png"])
    {
        self.userImage.image = [UIImage imageNamed:@"default_profile_img.png"];
    }
    else
    {
        // if (([urlStr rangeOfString:@".png"].location == NSNotFound) & ([urlStr rangeOfString:@".jpg"].location == NSNotFound))
        if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
        {
            NSURL *url = [NSURL URLWithString:[[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileImageName" ] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                if (data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.userImage.image = [[UIImage alloc]initWithData:data];
                    });
                }
            });
            
            [self.userImage hnk_setImageFromURL:url];
        }
        else
        {
            self.userImage.image = [UIImage imageNamed:@"default_profile_img.png"];
        }
    }
    
    
    NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileVideoImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    if (videoImageStr!=nil && videoImageStr.length > 0 && ![videoImageStr isEqualToString:@"<null>"]) {
        NSURL *url = [NSURL URLWithString:[[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileVideoImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    videoImage.image = [[UIImage alloc]initWithData:data];
                });
            }
        });
        
        [videoImage hnk_setImageFromURL:url];
    }
    else
    {
        videoImage.image = [UIImage imageNamed:@"novideo_default_img-2"];
    }
    
     MyVideoUrl = [[NSURL alloc] initWithString:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileVideo" ]];
    NSString *videoUrlStr = [NSString stringWithFormat:@"%@",[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileVideo" ]];
    
    if (videoUrlStr!=nil && videoUrlStr.length > 0 && ![videoUrlStr isEqualToString:@"<null>"]) {
        videoUrlStr = [videoUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        playVideoUrl = [NSString stringWithFormat:@"%@",videoUrlStr];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:playVideoUrl]];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    videoPlayforAccept = [[NSString alloc]init];
                    videoPlayforAccept = [self getaVideoPathFromUrl:data];
                });
            }
        });
        
        playBtn.hidden = NO;
        playBtnImage.hidden = NO;
    }
    else
    {
        playBtn.hidden = YES;
        playBtnImage.hidden = YES;
    }
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGFloat height = [[self.notesDetailWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    notesDetailWebView.frame = CGRectMake(notesDetailWebView.frame.origin.x, notesDetailWebView.frame.origin.y, notesDetailWebView.frame.size.width, height);
    [profileScrollView setContentSize:CGSizeMake(0,650+height)];
}
- (IBAction)handleCallButton:(UIButton *)sender {
    {
        if( sender.titleLabel.text != nil)
        {
            NSString *number = [Parameters removeSpecialCharactresFromNumber:sender.titleLabel.text];
            NSString *tempPhoneNumber = [[@"tel://"stringByAppendingString:number]stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tempPhoneNumber]])
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempPhoneNumber] options:@{} completionHandler:nil];
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"Your device is not able to make calls" maskType:SVProgressHUDMaskTypeBlack];
            }
        }
    }
}
-(void)setNavigationBarButtons
{
    UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=menuBarBtn;
}
-(void)handelHome
{
    //[self slideViewWithAnimation];
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)AcceptProfile:(id)sender
{
    [self callCheckContactAddedForAcceptProfileWs];
}
-(void)callCheckContactAddedForAcceptProfileWs
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
        [serviceIntegration CheckContactAddedForAcceptProfile:self userId:CURRENT_USER_ID profileId:currentUserProfileId :@selector(receivedResponseCHeckContactExistAcceptProfileWS:)];
    }
}
- (void)receivedResponseCHeckContactExistAcceptProfileWS:(NSArray *)responseDict
{
    
    
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        if ([[responseDict valueForKey:@"exist"]isEqualToString:@"true"])
        {
            [SVProgressHUD dismiss];
            isContactProfileExist = @"true";
            [self showOverwriteAlert];
        }
        else{
            //isContactProfileExist = @"false";
            //  [self callAcceptProfileWs];
            NSString *string = @"Profile has been added to your Contact list and Chat Box";
            [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
            [self performSelector:@selector(moveToTheView) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

-(void)showOverwriteAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Accepting this profile will override any existing profile for this user. Do you still want to proceed?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Accept"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self callAcceptProfileWs];
                                   }];
        [alertVC addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Ignore"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self IgnoreProfile:nil];
                                       }];
        
        [alertVC addAction:cancelAction];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Accepting this profile will override any existing profile for this user. Do you still want to proceed?" delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:@"Ignore", nil];
        alrt.tag = 1;
        [alrt show];
    }
}

-(void)callAcceptProfileWs
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
        [serviceIntegration AcceptUserProfile:self userId:CURRENT_USER_ID isOverrride:isContactProfileExist profileId:currentUserProfileId :@selector(receivedResponseAcceptProfileProfWS:)];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if (buttonIndex == 0)
        {
            [self callAcceptProfileWs];
        }
        else
        {
            [self IgnoreProfile:nil];
        }
    }
    else
    {
        if (buttonIndex == 0)
        {
            [self callAcceptProfileWs];
        }
        else
        {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)receivedResponseAcceptProfileProfWS:(NSArray *)responseDict
{
    
    
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        NSString *string = @"Profile has been updated to your Contact list and Chat Box";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToTheView) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}
-(IBAction)IgnoreProfile:(id)sender
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
        [serviceIntegration IgnoreUserProfile:self profileId:currentUserProfileId :@selector(receivedResponseIgnoreProfProfileWS:)];
    }
}
- (void)receivedResponseIgnoreProfProfileWS:(NSArray *)responseDict
{
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        NSString *string = @"Profile will not be added to your contact list";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToTheView) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}
-(void)moveToTheView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - video integration in view
-(IBAction)playButtonClicked:(id)sender
{
//    NSString *videoPath = [self getaVideoPathFromUrl:VideoData];
    if (videoPlayforAccept) {
        videoPlayer =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPlayforAccept]];
        [videoPlayer prepareToPlay];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doneButtonClick:)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];
        
        [[videoPlayer view] setFrame:[[self view] bounds]];
        videoPlayer.controlStyle = MPMovieControlStyleDefault;
        videoPlayer.shouldAutoplay = YES;
        [self.view addSubview:videoPlayer.view];
        [videoPlayer setFullscreen:YES animated:YES];
        [videoPlayer play];
    }
    else
    {
        player = [AVPlayer playerWithURL:MyVideoUrl];
        NSLog(@"%@",MyVideoUrl);
        // create a player view controller
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        [self presentViewController:controller animated:YES completion:nil];
        controller.player = player;
        playerItem = player.currentItem;
        [player play];
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:nil];
        [player addObserver:self forKeyPath:@"rate" options:0 context:nil];
        [player play];

    }
}

-(void)doneButtonClick:(NSNotification*)aNotification{
    MPMoviePlayerController *players = [aNotification object];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerWillExitFullscreenNotification
     object:players];
    
    if ([players respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [players.view removeFromSuperview];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (!player)
    {
        return;
    }
    
    
    else if (object == playerItem && [keyPath isEqualToString:@"playbackBufferFull"])
    {
        if (playerItem.playbackBufferFull) {
            //Your code here
            //            if ([keyPath isEqualToString:@"rate"]){
            //                if(player.rate==1){
            ////                    [player pause];
            //
            //                }
            //                else{
            [player play];
            //                }
            //            }
            
        }
    }
    else if (object == playerItem && [keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (playerItem.playbackBufferEmpty) {
            //Your code here
            //            if ([keyPath isEqualToString:@"rate"]){
            //                if(player.rate==1){
            //                   [player pause];
            //
            //                }
            //                else{
            [player play];
            //                }
            //            }
            //
        }
    }
    
    else if (object == playerItem && [keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if (playerItem.playbackLikelyToKeepUp)
        {
            [player play];
        }
    }
}

-(NSString*)getaVideoPathFromUrl:(NSData*)video
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *uniqueString = [CommonNotification createRandomName];
    NSString *videopath= [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@.mov",documentsDirectory,uniqueString]];
    success = [video writeToFile:videopath atomically:NO];
//    NSLog(@"video path --> %@",videopath);
    return videopath;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 

@end

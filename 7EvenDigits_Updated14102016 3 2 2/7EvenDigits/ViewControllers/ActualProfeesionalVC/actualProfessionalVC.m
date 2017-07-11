//
//  actualProfessionalVC.m
//  7EvenDigits
//
//  Created by nikhil on 11/21/16.
//  Copyright © 2016 Quagnitia Systems. All rights reserved.
//

#import "actualProfessionalVC.h"

@interface actualProfessionalVC ()

@end

@implementation actualProfessionalVC
@synthesize professionalProfileArray,fullNameLabel,userIdLabel,notesDetailWebView,titleLabel,companyLabel,userImage,digitsButton,addressTextView,viewForProfileData,playButton,videoUrl,privateStatusBtn,publicStatusBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    videoUrl = [[NSString alloc]init];
    playVideoData = [[NSData alloc]init];
    self.navigationController.navigationBarHidden = NO;
    [profileScrollView setContentSize:CGSizeMake(0, 650)];
    
    if ([stringForTitle isEqualToString:@"Professional Profile"])
    {
        [viewForProfileData setFrame:CGRectMake(0, 80, 320, 311)];
              stringForTitle=@"Update Profile";
        
        
        UIBarButtonItem *homeBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handleHome)];
        
        self.navigationItem.leftBarButtonItem=homeBarBtn;
        
    }
    else
    {
        
        [viewForProfileData setFrame:CGRectMake(0, 20, 320, 311)];
       stringForTitle=@"Update Contact";
        
        
        
        UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
        self.navigationItem.leftBarButtonItem=leftBarBtn;
        
    }
    sendProfilePressed = @"No";
    
    self.title=@"Professional Profile";
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(handelUpdate)];
    
    
    [rightBarBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"Helvetica Neue" size:16], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    
    
    self.navigationItem.rightBarButtonItem=rightBarBtn;
    
    //Set the data for a professional profile
    [self setProfessionalProfileData];
    sendProfilePressed = @"No";
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)handleHome
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    
}
-(void)setProfessionalProfileData
{
    if([[[professionalProfileArray objectAtIndex:0] valueForKey:@"Yes"] isEqualToString:@"YES"])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    int checkstatus = [[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"IsPublic"] intValue];
    NSLog(@"Status is %ld",(long)checkstatus);
    if(checkstatus == 1)
    {
        
        [self.publicStatusBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
        [self.privateStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        
        [self.privateStatusBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
        [self.publicStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
        
    }

    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    //    if([self.title isEqualToString:@"Professional Profile"])
    //    {
    NSLog(@"%@",professionalProfileArray);
    self.fullNameLabel.text= [NSString stringWithFormat:@"%@ %@",[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"FirstName" ],[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"LastName"]];
    self.userIdLabel.text=[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserName"];
    self.titleTextView.text = [[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserTitle"];
    self.companyTextView.text =[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserCompany"];
    
    [self.titleTextView setFont:[UIFont systemFontOfSize:16]];
    [self.companyTextView setFont:[UIFont systemFontOfSize:16]];
    
    if(self.titleTextView.text.length > 10)
    {
        self.titleTextView.userInteractionEnabled = YES;
    }
    else
    {
        self.titleTextView.userInteractionEnabled = NO;
    }
    
    if(self.companyTextView.text.length > 10)
    {
        self.companyTextView.userInteractionEnabled = YES;
    }
    else
    {
        self.companyTextView.userInteractionEnabled = NO;
    }
    
   if([[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserAddress"] isEqualToString:@"(null)"])
    {
        self.addressTextView.text =@"";
    }
    else
    {
        addressString = [[NSMutableString alloc]init];
        NSString *str = [[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"UserAddress"];
        
        if (str.length > 0)
        {
            NSArray *arr = [str componentsSeparatedByString:@"\n"];
            if (arr.count > 0)
            {
                if (arr.count == 1)
                {
                    
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
                else if (arr.count == 3)
                {
                    if (![[arr objectAtIndex:0] isEqualToString:@"Address1"])
                    {
                        [addressString appendFormat:@"%@\n",[NSString stringWithFormat:@"%@",[arr objectAtIndex:0]]];
                    }
                    
                    if (![[arr objectAtIndex:1] isEqualToString:@"Address2"])
                    {
                        [addressString appendFormat:@"%@\n",[NSString stringWithFormat:@"%@",[arr objectAtIndex:1]]];
                    }
                    
                    if (![[arr objectAtIndex:2] isEqualToString:@"Address3"])
                    {
                        NSString *str1 = [NSString stringWithFormat:@"%@",[arr objectAtIndex:2]];
                        [addressString appendFormat:@"%@",str1];
                    }
                }
               if (addressString.length > 0)
               {
                    self.addressTextView.text = addressString;
               }
            }
            else
            {
                self.addressTextView.text = [[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserAddress"];
            }
        }
        else
        {
            self.addressTextView.text = @"";
        }
    }
    
    [self.addressTextView setFont:[UIFont systemFontOfSize:16]];
   
    self.emailLabel.text =[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"EmailId"];
    
    
    [self.mobileButton setTitle:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"MobileNumber"] forState:UIControlStateNormal];
    [self.workButton setTitle:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"WorkNumber"] forState:UIControlStateNormal];
    
    
    [self.digitsButton addTarget:self action:@selector(handleCallButton:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileImageName"]];
    if ([urlStr hasSuffix:@"default_Contact.png"] || [urlStr hasSuffix:@"noimage.png"] )
    {
        self.userImage.image = [UIImage imageNamed:@"default_profile_img.png"];
    }
    else
    {
        if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
        {
            NSURL *url = [NSURL URLWithString:[[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileImageName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            
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
        else {
            self.userImage.image = [UIImage imageNamed:@"default_profile_img.png"];
        }
    }
    
    NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileVideoImage"]];
    
    if (videoImageStr!=nil && videoImageStr.length > 0 && ![videoImageStr isEqualToString:@"<null>"]) {
        NSURL *url = [NSURL URLWithString:[[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileVideoImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.placeholderImageForVideo.image = [[UIImage alloc]initWithData:data];
                });
            }
        });
        
        [self.placeholderImageForVideo hnk_setImageFromURL:url];
    }
    else
    {
        self.placeholderImageForVideo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
    }
    
    
    MyVideoUrl = [[NSURL alloc] initWithString:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileVideo"]];
    NSString *videoUrlStr = [NSString stringWithFormat:@"%@",[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileVideo"]];
    
    if (videoUrlStr!=nil && videoUrlStr.length > 0 && ![videoUrlStr isEqualToString:@"<null>"]) {
        videoUrlStr = [videoUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        videoUrl = [NSString stringWithFormat:@"%@",videoUrlStr];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    videoPlayFromFile = [[NSString alloc]init];
                    videoPlayFromFile = [self getaVideoPathFromUrl:data];
                });
            }
        });
        
        playButton.hidden = NO;
        playImage.hidden = NO;
    }
    else
    {
        playButton.hidden = YES;
        playImage.hidden = YES;
    }
    
    
    [self.notesDetailWebView setUserInteractionEnabled:YES];
    NSString *notesStr = [Parameters decodeDataForEmogies:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserNotes"]];
    
    if(![notesStr isEqual:[NSNull null]])
    {
        [self.notesDetailWebView loadHTMLString:[Parameters insertNewLineInText:notesStr] baseURL:nil];
    }
    
    //    NSString *usernote = [Parameters insertNewLineInText:[[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserNotes"]];
    
    self.notesDetailWebView.scrollView.scrollEnabled = YES;
    self.notesDetailWebView.scrollView.showsHorizontalScrollIndicator = NO;
    self.notesDetailWebView.scrollView.bounces = YES;
    self.notesDetailWebView.delegate = self;
    
    [SVProgressHUD dismiss];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[self.notesDetailWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    notesDetailWebView.frame = CGRectMake(notesDetailWebView.frame.origin.x, notesDetailWebView.frame.origin.y, notesDetailWebView.frame.size.width, height);
    [profileScrollView setContentSize:CGSizeMake(0, 700+height)];
}

- (IBAction)handleCallButton:(UIButton *)sender
{
    if(sender.titleLabel.text.length > 0)
    {
        
        NSString *number = [Parameters removeSpecialCharactresFromNumber:sender.titleLabel.text];
        
        NSString *tempPhoneNumber = [[@"tel://"stringByAppendingString:number]stringByReplacingOccurrencesOfString:@" " withString:@""];
        //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:tempPhoneNumber]]
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tempPhoneNumber]])
        {
           [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempPhoneNumber] options:@{} completionHandler:nil];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"Your device is not able to make calls" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}

-(IBAction)handelSend:(id)sender
{
    [Parameters addPaddingView:usernameTextField];
    popUpBackgroundView.layer.cornerRadius = 3.0;
    userNameExistLabel.text = @"";
    usernameTextField.text =@"";
    checkUserExistPopUpView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:checkUserExistPopUpView];
}

-(void)handelUpdate
{
    if(!editProfessionalProfile)
    {
        editProfessionalProfile=[[EditProfessionalProfile alloc]initWithNibName:@"EditProfessionalProfile" bundle:[NSBundle mainBundle]];
    }
    
    
    if([stringForTitle isEqualToString:@"Update Profile"] || [editProfessionalProfile.isEditingMyProfile isEqualToString:@"Yes"])
    {
        editProfessionalProfile=[[EditProfessionalProfile alloc]initWithNibName:@"EditProfessionalProfile" bundle:[NSBundle mainBundle]];
        editProfessionalProfile.isEditingMyProfile = @"Yes";
    }
    else
    {
        editProfessionalProfile=[[EditProfessionalProfile alloc]initWithNibName:@"EditProfessionalProfile" bundle:[NSBundle mainBundle]];
        editProfessionalProfile.isEditingMyProfile = @"No";
    }
    
    editProfessionalProfile.editProfessionalProfileArray = [[NSMutableArray alloc]init];
    [editProfessionalProfile.editProfessionalProfileArray addObject:[[professionalProfileArray objectAtIndex:0] valueForKey:@"userDTO"]];
    
    editProfessionalProfile.videoImageFromBack = [[UIImage alloc]init];
    editProfessionalProfile.userImage = [[UIImage alloc]init];
    
    editProfessionalProfile.videoImageFromBack = self.placeholderImageForVideo.image;
    editProfessionalProfile.userImage = userImage.image;
    
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    //    stringForTitle=@"Update Contact";
    stringForTitle=@"Update Professional Profile";
    
    [self.navigationController pushViewController:editProfessionalProfile animated:YES];
    //    [Parameters pushFromView:self toView:editProfessionalProfile withTransition:UIViewAnimationTransitio];
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    searchUserName = [usernameTextField.text stringByTrimmingCharactersInSet:
                       [NSCharacterSet whitespaceCharacterSet]];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    searchUserName = [usernameTextField.text stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
    [self callCheckUserExistOrNotWebService];
}

-(void)callCheckUserExistOrNotWebService
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
        
        [serviceIntegration CheckProfileUserExist:self UserName:[usernameTextField.text stringByTrimmingCharactersInSet:
                                                                 [NSCharacterSet whitespaceCharacterSet]] :@selector(receivedResponseUserExistWS:)];
    }
}
- (void)receivedResponseUserExistWS:(NSArray *)responseDict
{
    [SVProgressHUD dismiss];
    if ([[responseDict valueForKey:@"isExactExist" ]isEqualToString:@"true"])
    {
        userNameExistLabel.text = @"";
        if ([[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"user"] valueForKey:@"UserId"]] isEqualToString:CURRENT_USER_ID])
        {
            userNameExistLabel.textColor  =[UIColor redColor];
            userNameExistLabel.text = @"You cannot send profile to yourself.";
        }
        else if ([sendProfilePressed isEqualToString:@"Yes"])
        {
            sendProfilePressed=@"No";
            [self callSendProfileWebService:[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"user"] valueForKey:@"UserId"]]];
        }
    }
    else
    {
        userNameExistLabel.textColor  =[UIColor redColor];
        userNameExistLabel.text = @"Username does not exist, try again";
    }
}

-(IBAction)sendUserProfile:(id)sender
{
    sendProfilePressed = @"Yes";
    [usernameTextField resignFirstResponder];
    if(usernameTextField.text.length > 0)
    {
        [self callCheckUserExistOrNotWebService];
    }
    else
    {
        userNameExistLabel.text = @"This field is required.";
        userNameExistLabel.textColor = [UIColor redColor];
    }
}

-(void)callSendProfileWebService :(NSString *)reciverUserId
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
        
        [serviceIntegration SendUserProfile:self userId:CURRENT_USER_ID reciverUserId:reciverUserId profileId:@"2" Message:@"" isRequest:@"false" :@selector(receivedResponseSendProfProfileInCont:)];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [checkUserExistPopUpView removeFromSuperview];
}
- (void)receivedResponseSendProfProfileInCont:(NSArray *)responseDict
{
    
    if([[responseDict valueForKey:@"msg"]isEqualToString:@"SUCCESS"] || [[responseDict valueForKey:@"msg"]isEqualToString:@"OVERRIED"])
    {
        searchUserName=@"";
        [SVProgressHUD showSuccessWithStatus: @"Profile has been sent successfully." maskType:SVProgressHUDMaskTypeBlack];
        [checkUserExistPopUpView removeFromSuperview];
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)cancelPopUpView:(id)sender
{
    searchUserName = @"";
    [checkUserExistPopUpView removeFromSuperview];
    [self handleHome];
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    
//}

#pragma mark - video integration in view
-(IBAction)playButtonClicked:(id)sender
{
    if (videoPlayFromFile)
    {
        moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPlayFromFile]];
        [moviePlayer prepareToPlay];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doneButtonClick:)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];
        
        [[moviePlayer view] setFrame:[[self view] bounds]];
        moviePlayer.controlStyle = MPMovieControlStyleDefault;
        moviePlayer.shouldAutoplay = YES;
        [self.view addSubview:moviePlayer.view];
        [moviePlayer setFullscreen:YES animated:YES];
        [moviePlayer play];
    }
    else
    {
          [self playVideo:videoUrl];
//        player = [AVPlayer playerWithURL:MyVideoUrl];
//        NSLog(@"%@",MyVideoUrl);
//        // create a player view controller
//        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
//        [self presentViewController:controller animated:YES completion:nil];
//        controller.player = player;
//        playerItem = player.currentItem;
//        [player play];
//        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
//        [playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:nil];
//        [player addObserver:self forKeyPath:@"rate" options:0 context:nil];
//        [player play];
//        
//        //        [SVProgressHUD showWithStatus:@"Streaming Video to play" maskType:SVProgressHUDMaskTypeBlack];
//        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
//        //            dispatch_async(dispatch_get_main_queue(), ^{
//        //                [SVProgressHUD dismiss];
//        //                if (data) {
//        //                    videoUrl = [self getaVideoPathFromUrl:data];
//        //                    moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoUrl]];
//        //                    [moviePlayer prepareToPlay];
//        //                    [[NSNotificationCenter defaultCenter] addObserver:self
//        //                                                             selector:@selector(doneButtonClick:)
//        //                                                                 name:MPMoviePlayerWillExitFullscreenNotification
//        //                                                               object:nil];
//        //
//        //                    [[moviePlayer view] setFrame:[[self view] bounds]];
//        //                    moviePlayer.controlStyle = MPMovieControlStyleDefault;
//        //                    moviePlayer.shouldAutoplay = YES;
//        //                    [self.view addSubview:moviePlayer.view];
//        //                    [moviePlayer setFullscreen:YES animated:YES];
//        //                    [moviePlayer play];
//        //                }
//        //            });
//        //        });
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

-(void)continuePlaying
{
    //    if (!playerItem.playbackLikelyToKeepUp)
    //    {
    //        __weak typeof(self) wSelf = self;
    //        //self.playbackLikelyToKeepUpKVOToken = [playerItem addObserverForKeyPath:@keypath(playerItem.playbackLikelyToKeepUp) block:^(id obj, NSDictionary *change) {
    //            __strong typeof(self) sSelf = wSelf;
    //            if(sSelf)
    //            {
    //                if (sSelf.playerItem.playbackLikelyToKeepUp)
    //                {
    //                    [sSelf.playerItem removeObserverForKeyPath:@keypath(_playerItem.playbackLikelyToKeepUp) token:self.playbackLikelyToKeepUpKVOToken];
    //                    sSelf.playbackLikelyToKeepUpKVOToken = nil;
    //                    [sSelf continuePlaying];
    //                }
    //            }
    //        }];
    //    }
    [player play];
}

-(void)playVideo:(NSString *)url1
{
    moviePlayer=[[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url1]];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:moviePlayer];
    moviePlayer.controlStyle=MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay=YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
    [moviePlayer prepareToPlay];
    [moviePlayer play];
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerController *players = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:player];
    if ([players respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [players.view removeFromSuperview];
    }
}

-(void)doneButtonClick:(NSNotification*)aNotification
{
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

-(void)hideShowPlayVideoButton
{
    UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
    NSData *imgData1 = UIImagePNGRepresentation(self.placeholderImageForVideo.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if (isCompare)
    {
        self.playButton.hidden = YES;
        playImage.hidden = YES;
    }
    else
    {
        self.playButton.hidden = NO;
        playImage.hidden = NO;
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
    return videopath;
}





@end

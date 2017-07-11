//
//  actualPersonalVC.m
//  7EvenDigits
//
//  Created by nikhil on 11/21/16.
//  Copyright © 2016 Quagnitia Systems. All rights reserved.
//

#import "actualPersonalVC.h"
#import "AddContactViewController.h"
#import "Constant.h"
#import "ContactViewController.h"

@interface actualPersonalVC ()

@end

@implementation actualPersonalVC
@synthesize firstNameLabel,lastNameLabel,userIdLabel,notesDetailWebView,statusImage,addContVc,viewForSendBtn,digitsButton,addc,videoPersonalUrl,userImage,contactArray,menuVc,privateStatusBtn,publicStatusBtn;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    
    videoPersonalUrl = [[NSString alloc]init];
    
    playVideoData = [[NSData alloc]init];
    
    
    if ([stringForTitle isEqualToString:@"Personal Profile"])
    {
        [viewForSendBtn setFrame:CGRectMake(0, 65, 320, 311)];
        stringForTitle=@"Update Profile";
        
        UIBarButtonItem *homeBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handleHome)];
        
        self.navigationItem.leftBarButtonItem=homeBarBtn;
        
    }
    else
    {
        [viewForSendBtn setFrame:CGRectMake(0, 15, 320, 311)];
        stringForTitle=@"Update Contact";
        
        UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
        self.navigationItem.leftBarButtonItem=leftBarBtn;
        
    }
    
    
    
    self.title=@"Personal Profile";
    
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(handleUpdateButton)];
    
    
    [rightBarBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIFont fontWithName:@"Helvetica Neue" size:15], NSFontAttributeName,
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         nil]
                               forState:UIControlStateNormal];
    
       
    self.navigationItem.rightBarButtonItem=rightBarBtn;
    
    sendProfilePressed = @"No";
    [self setProfileData];
    [SVProgressHUD dismiss];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)viewWillAppear:(BOOL)animated{
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

-(void)handleHome
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    
}
-(void)setProfileData
{
    if([[[contactArray objectAtIndex:0] valueForKey:@"Yes"] isEqualToString:@"YES"])
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    int checkstatus = [[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"IsPublic"] intValue];
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

    
    self.firstNameLabel.text= [NSString stringWithFormat:@"%@ %@",[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"FirstName" ],[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"LastName" ]];
    self.userIdLabel.text=[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserName" ];
    [self.notesDetailWebView setUserInteractionEnabled:NO];
    self.emailLabel.text=[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"EmailId" ];
    [self.digitsButton setTitle:[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"PhoneNumber"] forState:UIControlStateNormal];
    [self.digitsButton addTarget:self action:@selector(handleCallButton:) forControlEvents:UIControlEventTouchUpInside];
    NSString *notesStr = [Parameters decodeDataForEmogies:[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"UserNotes" ]];
    
    if(notesStr)
    {
        [self.notesDetailWebView loadHTMLString:[Parameters insertNewLineInText:notesStr] baseURL:nil];
    }
    
    self.notesDetailWebView.delegate = self;
    CGFloat newHeight = [[self.notesDetailWebView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollHeight;"] floatValue];
    
    [profileDataScrollView setContentSize:CGSizeMake(0, newHeight+600)];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileImageName"]];
    
    if ([urlStr hasSuffix:@"default_Contact.png"] || [urlStr hasSuffix:@"noimage.png"])
    {
        userImage.image = [UIImage imageNamed:@"default_profile_img.png"];
    }
    else
    {
        
        if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
        {
            NSURL *url = [NSURL URLWithString:[[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileImageName"]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                if (data)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.userImage.image = [[UIImage alloc]initWithData:data];
                    });
                }
            });
            
            [self.userImage hnk_setImageFromURL:url];
        }
        else
        {
            userImage.image = [UIImage imageNamed:@"default_profile_img.png"];
        }
    }
    MyVideoUrl = [[NSURL alloc] initWithString:[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileVideo"]];
    NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileVideoImage"]];
    
    if (videoImageStr!=nil && videoImageStr.length > 0 && ![videoImageStr isEqualToString:@"<null>"])
    {
        NSURL *url = [NSURL URLWithString:[[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileVideoImage"]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
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
        self.placeholderImageForVideo.image = [UIImage imageNamed:@"novideo_default_img-2"];
    }
    
    NSString *videoUrlStr = [NSString stringWithFormat:@"%@",[[[contactArray objectAtIndex:0] valueForKey:@"userDTO"] valueForKey:@"ProfileVideo"]];
    
    if (videoUrlStr!=nil && videoUrlStr.length > 0 && ![videoUrlStr isEqualToString:@"<null>"]) {
        videoUrlStr = [videoUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        videoPersonalUrl = [NSString stringWithFormat:@"%@",videoUrlStr];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoPersonalUrl]];
            if (data)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    videoPlayFromAcceptContact = [[NSString alloc]init];
                    videoPlayFromAcceptContact = [self getaVideoPathForPersonal:data];
                });
            }
        });
        
        self.playButton.hidden = NO;
        self.playImage.hidden = NO;
    }
    else
    {
        self.playButton.hidden = YES;
        self.playImage.hidden = YES;
    }
    
    
    //    }
    //    else
    //    {
    //        self.firstNameLabel.text= [NSString stringWithFormat:@"%@ %@",[[contactArray objectAtIndex:0]valueForKey:@"FirstName"],[[contactArray objectAtIndex:0] valueForKey:@"LastName"]];
    //
    //        self.userIdLabel.text=[[contactArray objectAtIndex:0] valueForKey:@"UserName" ];
    //        [self.notesDetailWebView setUserInteractionEnabled:YES];
    //
    //        self.emailLabel.text=[[contactArray objectAtIndex:0]  valueForKey:@"EmailId"];
    //        [self.digitsButton setTitle:[[contactArray objectAtIndex:0] valueForKey:@"PhoneNumber"] forState:UIControlStateNormal];
    //        [self.digitsButton addTarget:self action:@selector(handleCallButton:) forControlEvents:UIControlEventTouchUpInside];
    //
    //
    //        [self.notesDetailWebView loadHTMLString:[[contactArray objectAtIndex:0] valueForKey:@"Notes" ] baseURL:nil];
    //
    //
    //        NSURL *url = [NSURL URLWithString:[[[contactArray objectAtIndex:0] valueForKey:@"ContactImage"]
    //                                       stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //        NSData *data = [NSData dataWithContentsOfURL:url];
    //        self.userImage.image = [[UIImage alloc]initWithData:data];
    //    }
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    //Set the profile data
    [self.view endEditing:NO];
    [SVProgressHUD dismiss];
}

- (NSString *)removeSymbolFromHTML:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"\\&quot;"  withString:@""];
    
    return html;
}
-(void)handleUpdateButton
{
    if (!addc) {
        addc=[[AddContactViewController alloc]initWithNibName:@"AddContactViewController" bundle:[NSBundle mainBundle]];
    }
    addc.contactProfilVc=self;
    
    
    if([stringForTitle isEqualToString:@"Update Profile"] || [addc.isEditingMyProfile isEqualToString:@"Yes"])
    {
        addc=[[AddContactViewController alloc]initWithNibName:@"AddContactViewController" bundle:[NSBundle mainBundle]];
        addc.isEditingMyProfile = @"Yes";
    }
    else
    {
        addc=[[AddContactViewController alloc]initWithNibName:@"AddContactViewController" bundle:[NSBundle mainBundle]];
        addc.isEditingMyProfile = @"No";
    }
    addc.dataForEditContactArray=[[NSMutableArray alloc]init];
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    stringForTitle=@"Update Contact";
    
    addc.videoImageFromBack = [[UIImage alloc]init];
    addc.userImage = [[UIImage alloc]init];
    
    addc.videoImageFromBack = self.placeholderImageForVideo.image;
    addc.userImage = userImage.image;
    
    
    [addc.dataForEditContactArray addObject:[contactArray objectAtIndex:0]];
    [self.navigationController pushViewController:addc animated:YES];
    
}

-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)handleCallButton:(UIButton *)sender
{
    if(sender.titleLabel.text.length > 0)
    {
        NSString *number = [Parameters removeSpecialCharactresFromNumber:sender.titleLabel.text];
        
        NSString *tempPhoneNumber = [[@"tel://"stringByAppendingString:number]stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tempPhoneNumber]])
        {
            //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:tempPhoneNumber]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:tempPhoneNumber] options:@{} completionHandler:nil];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"Your device is not able to make calls" maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}

#pragma mark == Send Profile
-(IBAction)handelSend:(id)sender
{
    [Parameters addPaddingView:usernameTextField];
    popUpBackgroundView.layer.cornerRadius = 5.0;
    userNameExistLabel.text = @"";
    usernameTextField.text =@"";
    checkUserExistPopUpView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:checkUserExistPopUpView];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    searchUserName = textField.text;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    searchUserName = textField.text;
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
                                                                 [NSCharacterSet whitespaceCharacterSet]] :@selector(receivedResponseUserExistPersonalWS:)];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    CGFloat height = [[self.notesDetailWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    notesDetailWebView.frame = CGRectMake(notesDetailWebView.frame.origin.x, notesDetailWebView.frame.origin.y, notesDetailWebView.frame.size.width, height);
    [profileDataScrollView setContentSize:CGSizeMake(0, height+600)];
}

- (void)receivedResponseUserExistPersonalWS:(NSArray *)responseDict
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
    else{
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
        
        [serviceIntegration SendUserProfile:self userId:CURRENT_USER_ID reciverUserId:reciverUserId profileId:@"1" Message:@"" isRequest:@"false" :@selector(receivedResponseSendProfileInCont:)];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    searchUserName = @"";
    [checkUserExistPopUpView removeFromSuperview];
}

- (void)receivedResponseSendProfileInCont:(NSArray *)responseDict
{
    
    if([[responseDict valueForKey:@"msg"]isEqualToString:@"SUCCESS"] || [[responseDict valueForKey:@"msg"]isEqualToString:@"OVERRIED"])
    {
        searchUserName=@"";
        [SVProgressHUD showSuccessWithStatus:@"Profile has been sent successfully." maskType:SVProgressHUDMaskTypeBlack];
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
    
    //    UIAlertView *obj = [[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to cancel this request? " delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
    //    [obj show];
    //    obj.tag = 100;
    //    obj = nil;
}

#pragma mark - play video in profile
-(IBAction)playButtonClicked:(id)sender
{
    if (videoPlayFromAcceptContact)
    {
        moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPlayFromAcceptContact]];
        [moviePlayer prepareToPlay];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneButtonClick:)
                                                     name:MPMoviePlayerWillExitFullscreenNotification object:nil];
        
        [[moviePlayer view] setFrame:[[self view] bounds]];
        moviePlayer.controlStyle = MPMovieControlStyleDefault;
        moviePlayer.shouldAutoplay = YES;
        [self.view addSubview:moviePlayer.view];
        [moviePlayer setFullscreen:YES animated:YES];
        [moviePlayer play];
//        if (player != nil && [player currentItem] != nil)
//            [playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
//            [playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
//            [playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
//        
//                player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:videoPlayFromAcceptContact]];
//                AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
//                [self presentViewController:controller animated:YES completion:nil];
//                controller.player = player;
//                playerItem = player.currentItem;
//                [player play];
//       
//                [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
//                [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
//                [playerItem addObserver:self forKeyPath:@"playbackBufferFull" options:NSKeyValueObservingOptionNew context:nil];
//                [player addObserver:self forKeyPath:@"rate" options:0 context:nil];
//                [player play];
    }
    else
    {
        [self playVideo:videoPersonalUrl];
        
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
        
        //        [SVProgressHUD showWithStatus:@"Streaming Video to play" maskType:SVProgressHUDMaskTypeBlack];
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoPersonalUrl]];
        //            dispatch_async(dispatch_get_main_queue(), ^{
        //                [SVProgressHUD dismiss];
        //                if (data) {
        //                    videoPersonalUrl = [self getaVideoPathForPersonal:data];
        //                    moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPersonalUrl]];
        //                    [moviePlayer prepareToPlay];
        //                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doneButtonClick:)
        //                                                                 name:MPMoviePlayerWillExitFullscreenNotification object:nil];
        //
        //                    [[moviePlayer view] setFrame:[[self view] bounds]];
        //                    moviePlayer.controlStyle = MPMovieControlStyleDefault;
        //                    moviePlayer.shouldAutoplay = YES;
        //                    [self.view addSubview:moviePlayer.view];
        //                    [moviePlayer setFullscreen:YES animated:YES];
        //                    [moviePlayer play];
        //                }
        //            });
        //        });
    }
}

-(void)doneButtonClick:(NSNotification*)aNotification
{
    MPMoviePlayerController *player1 = [aNotification object];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerWillExitFullscreenNotification
     object:player1];
    
    if ([player1 respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player1.view removeFromSuperview];
    }
}

-(NSString*)getaVideoPathForPersonal:(NSData*)video
{
    BOOL success;
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
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (!player)
    {
        return;
    }
    
    
    else if (object == playerItem && [keyPath isEqualToString:@"playbackBufferFull"])
    {
        if (playerItem.playbackBufferFull)
        {
            [player play];
        }
    }
    else if (object == playerItem && [keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if (playerItem.playbackBufferEmpty)
        {
                       [player play];
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

@end

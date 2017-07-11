//
//  AcceptIgnoreProfileVC.m
//  7EvenDigits
//
//  Created by Neha_Mac on 30/06/15.
//  Copyright (c) 2015 Quagnitia Systems. All rights reserved.
//

#import "AcceptIgnoreProfileVC.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AcceptIgnoreProfileVC ()

@end

@implementation AcceptIgnoreProfileVC

@synthesize userImage,profileDataArray,menuVc;
@synthesize firstNameLabel,userIdLabel,notesDetailWebView,digitsButton,playVideoURL,ButtonPlay,acceptBtn,ignoreBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    
    playVideoURL = [[NSString alloc]init];
    PlayVideoData = [[NSData alloc]init];
    
    self.title=@"Personal Profile";
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
    
    currentUserProfileId = [[profileDataArray objectAtIndex:0] valueForKey:@"ProfileId"];
    
    [self callViewProfileWS];
    [Parameters addBorderToView:acceptBtn];
    [Parameters addBorderToView:ignoreBtn];
    
}
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
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
        
        [serviceIntegration ViewInboxOtherUserProfile:self profileId:[[profileDataArray objectAtIndex:0] valueForKey:@"ProfileId"] :@selector(receivedResponseViewProfileWS:)];
      
    }
}
- (void)receivedResponseViewProfileWS:(NSArray *)responseDict
{
    [SVProgressHUD dismiss];
    
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        profileDataArray = [[NSMutableArray alloc]init];
        [profileDataArray addObject:responseDict];
        [self setProfileData];
    }
    else
    {
    }
}
-(void)handleHome
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    
}
-(void)setProfileData
{
    self.firstNameLabel.text=[NSString stringWithFormat:@"%@ %@",[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"FirstName" ],[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"LastName"]];
    
    self.userIdLabel.text=[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserName" ];
    [self.notesDetailWebView setUserInteractionEnabled:NO];
    self.notesDetailWebView.delegate = self;
    
    NSString *notesStr = [Parameters decodeDataForEmogies:[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"UserNotes" ]];
    if(![notesStr isEqual:[NSNull null]])
    {
        [self.notesDetailWebView loadHTMLString:[Parameters insertNewLineInText:notesStr] baseURL:nil];
    }
    
    self.emailLabel.text=[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"EmailId" ];
    
//    NSMutableCharacterSet *characterSet =[NSMutableCharacterSet characterSetWithCharactersInString:@"()-"];
//    // Build array of components using specified characters as separtors
//    NSArray *arrayOfComponents = [str componentsSeparatedByCharactersInSet:characterSet];
//    // Create string from the array components
//    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
//    NSString *s = [strOutput stringByReplacingOccurrencesOfString:@" " withString:@""];
//
//    NSMutableString *num = [[NSMutableString alloc]initWithString:s];
//    
//    if(num.length >= 10)
//    {
//        [num insertString:@"(" atIndex:0];
//        [num insertString:@")" atIndex:4];
//        [num insertString:@"-" atIndex:8];
//    }
    [self.digitsButton setTitle:[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"PhoneNumber" ] forState:UIControlStateNormal];
    
    
    [self.digitsButton addTarget:self action:@selector(handleCallButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    NSString *urlStr = [[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileImageName" ];
    
    if ([urlStr hasSuffix:@"default_Contact.png"] || [urlStr hasSuffix:@"noimage.png"])
    {
        self.userImage.image = [UIImage imageNamed:@"default_profile_img.png"];
    }
    else
    {
//        if (([urlStr rangeOfString:@".png"].location == NSNotFound) & ([urlStr rangeOfString:@".jpg"].location == NSNotFound))
            if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
            {
                NSURL *url = [NSURL URLWithString:[[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileImageName" ] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
                
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
    
    
    NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileVideoImage"]];
    
    if (videoImageStr!=nil && videoImageStr.length > 0 && ![videoImageStr isEqualToString:@"<null>"]) {
        
        NSURL *url = [NSURL URLWithString:[[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileVideoImage" ] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];

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
    MyVideoUrl = [[NSURL alloc] initWithString:[[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileVideo"]];
    NSString *videoUrlStr = [[[profileDataArray objectAtIndex:0] valueForKey:@"userViewDTO"] valueForKey:@"ProfileVideo"];
    
    if (videoUrlStr!=nil && videoUrlStr.length > 0 && ![videoUrlStr isEqualToString:@"<null>"]) {
        videoUrlStr = [videoUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        playVideoURL = [NSString stringWithFormat:@"%@",videoUrlStr];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:playVideoURL]];
            if (data) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    videoPlayFromAcceptPersonal = [[NSString alloc]init];
                    videoPlayFromAcceptPersonal = [self getaVideoPathFromUrl:data];
                });
            }
        });
        
//        UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2"];
//        NSData *imgData1 = UIImagePNGRepresentation(secondImage);
//        NSData *imgData2 = UIImagePNGRepresentation(videoImage.image);
//        BOOL isCompare =  [imgData1 isEqual:imgData2];
//        if (isCompare)
//        {
//            UIImage *placeHolderImage = [CommonNotification loadImage:[NSURL URLWithString:videoUrlStr]];
//            videoImage.image = placeHolderImage;
//        }
        
        ButtonPlay.hidden = NO;
        buttonPlayImage.hidden = NO;
    }
    else
    {
        ButtonPlay.hidden = YES;
        buttonPlayImage.hidden = YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height = [[self.notesDetailWebView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"] floatValue];
    notesDetailWebView.frame = CGRectMake(notesDetailWebView.frame.origin.x, notesDetailWebView.frame.origin.y, notesDetailWebView.frame.size.width, height);
    [profileDataScrollView setContentSize:CGSizeMake(0,height+600)];
}
- (IBAction)handleCallButton:(UIButton *)sender {
    //    if (callviewstate == CallViewOpenState)
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
-(IBAction)AcceptProfile:(id)sender
{
    [self callCheckContactAddedForAcceptProfileWs];
}

-(void)callCheckContactAddedForAcceptProfileWs
{
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];    }
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
//             isContactProfileExist = @"false";
//             [self callAcceptProfileWs];
            NSString *string = @"Profile has been added to your Contact list and Chat Box";
            [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
            [self performSelector:@selector(handelBackButton) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
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
//        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Accepting this profile will override any existing profile for this user. Do you still want to proceed?" delegate:self cancelButtonTitle:@"Accept" otherButtonTitles:@"Ignore", nil];
//        alrt.tag = 1;
//        [alrt show];
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
        [serviceIntegration AcceptUserProfile:self userId:CURRENT_USER_ID isOverrride:isContactProfileExist profileId:currentUserProfileId :@selector(receivedResponseAcceptProfileWS:)];
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 1)
//    {
//        if (buttonIndex == 0)
//        {
//            [self callAcceptProfileWs];
//        }
//        else
//        {
//            [self IgnoreProfile:nil];
//        }
//    }
//    else
//    {
//        if (buttonIndex == 0)
//        {
//            [self callAcceptProfileWs];
//        }
//        else
//        {
//           // UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"“Profile will not be added to your contact list”" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
//         //   [alrt show];
//            [self handelBackButton];
//        }
//      
//    }
//}

- (void)receivedResponseAcceptProfileWS:(NSArray *)responseDict
{
   
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        NSString *string = @"Profile has been updated to your Contact list and Chat Box";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(handelBackButton) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
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
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];    }
    else
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        [serviceIntegration IgnoreUserProfile:self profileId:currentUserProfileId :@selector(receivedResponseIgnoreProfileWS:)];
    }
}
- (void)receivedResponseIgnoreProfileWS:(NSArray *)responseDict
{
   
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        NSString *string = @"Profile will not be added to your contact list";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(handelBackButton) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
         [SVProgressHUD dismiss];
    }
}


#pragma mark - video integration in view
-(IBAction)playButtonClicked:(id)sender
{
    if (videoPlayFromAcceptPersonal)
    {
        Player =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:videoPlayFromAcceptPersonal]];
        [Player prepareToPlay];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doneButtonClick:)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:nil];
        
        [[Player view] setFrame:[[self view] bounds]];
        Player.controlStyle = MPMovieControlStyleDefault;
        Player.shouldAutoplay = YES;
        [self.view addSubview:Player.view];
        [Player setFullscreen:YES animated:YES];
        [Player play];
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

//        [SVProgressHUD showWithStatus:@"Streaming Video to play" maskType:SVProgressHUDMaskTypeBlack];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//             NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:playVideoURL]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//                if (data) {
//                    playVideoURL = [self getaVideoPathFromUrl:data];
//                    Player =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:playVideoURL]];
//                    [Player prepareToPlay];
//                    [[NSNotificationCenter defaultCenter] addObserver:self
//                                                             selector:@selector(doneButtonClick:)
//                                                                 name:MPMoviePlayerWillExitFullscreenNotification
//                                                               object:nil];
//                    
//                    [[Player view] setFrame:[[self view] bounds]];
//                    Player.controlStyle = MPMovieControlStyleDefault;
//                    Player.shouldAutoplay = YES;
//                    [self.view addSubview:Player.view];
//                    [Player setFullscreen:YES animated:YES];
//                    [Player play];
//                }
//            });
//        });
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end



#import "ChatMeassageVC.h"
#import "MessageData.h"
#import "Constant.h"
#import "Parameters.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ChatMeassageVC () <JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIImage *willSendImage;

@end

@implementation  ChatMeassageVC

@synthesize chatUserID,chatUserImageURL,userStatus,titleName,chatUserVideoURL,cameraBtnTag1,chatMessageImageURL,StopWevservice;


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    ConnectionManagerObj =[[ConnectionManager alloc]init];
    self.navigationController.navigationBarHidden=NO;
    videoFlag = 0;
    cameraFlag = 0;
    self.title = titleName;
    self.delegate = self;
    self.dataSource = self;
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButtonInCHat)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 75.0f, 30.0f)];
    
    deleteHistoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteHistoryButton setImage:[UIImage imageNamed:@"clear_btn.png"] forState:UIControlStateNormal];
    [deleteHistoryButton setFrame:CGRectMake(34.0f, 0.0f, 60.0f, 40.0f)];
    [deleteHistoryButton addTarget:self action:@selector(deleteHistoryButton) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:deleteHistoryButton];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self callChatHistoryWebService];
    [self reloadTable];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = false;
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(void)callChatHistoryWebService
{
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
           if([mediaType isEqualToString:@"image"] || [mediaType isEqualToString:@"video"])
          {
              [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeBlack];
          }
          else
          {
               [SVProgressHUD showWithStatus:@"Downloading..." maskType:SVProgressHUDMaskTypeBlack];
          }
         serviceIntegration = [[ServerIntegration alloc]init];
        [serviceIntegration GetOfflineChat:self userId:CURRENT_USER_ID ContactId:chatUserID :@selector(receivedResponseDataChatHisInChatMsg:)];
    }
}

- (void)receivedResponseDataChatHisInChatMsg:(NSArray *)responseDict
{
    if(responseDict.count > 0 || responseDict.count == 0)
    {
        [SVProgressHUD dismiss];
        if([mediaType isEqualToString:@"image"] || [mediaType isEqualToString:@"video"])
        {
            [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeBlack];
        }
        
        for (int i=0; i<[responseDict count]; i++)
        {
           @autoreleasepool
           {
               const char *jsonString = [[[responseDict objectAtIndex:i]valueForKey:@"ChatMessage"] UTF8String];
               jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
               NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
            
               if (goodMsg==nil||goodMsg == NULL||[goodMsg isEqualToString:@""]||[goodMsg isEqualToString:@"(null)"])
               {
                    NSLog(@"Empty Message message cannot be forward ");
               }
               else
               {
                   NSMutableDictionary *messageDict = [[NSMutableDictionary alloc]init];
                   if ([goodMsg hasSuffix:@".jpg"])
                   {
                       appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
                       if(appDeleagated.internetStatus==0)
                       {
                          [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
                       }
                      else
                      {
                              NSURL *imgUrl = [NSURL URLWithString:goodMsg];
                              jsonData = [[NSData alloc] initWithContentsOfURL:imgUrl];
                              [messageDict setValue:jsonData  forKey:@"msg"];
                              MessageData *message = [[MessageData alloc] init];
                              [SVProgressHUD dismiss];

                             JSBubbleMessageType msgType;
                             msgType = JSBubbleMessageTypeIncoming;
                             [CommonNotification setMessageDetailsForChatWithUserID:[[responseDict objectAtIndex:i]valueForKey:@"FromUserId"] :[message createdDictionaryForMsgId:chatUserID text:nil date:[NSDate date] msgType:msgType imageData:[NSString stringWithFormat:@"%@", goodMsg] attachment:jsonData videoURL:nil mediaType:JSBubbleMediaTypeImage imageurl:[[responseDict objectAtIndex:i]valueForKey:@"ChatMessageId"] download:@"0"]];
                      }
                  }
                  else if ([goodMsg hasSuffix:@".mp4"])
                  {
                       NSURL *videoUrl;
                       NSString *thumbNilImg =  [goodMsg stringByReplacingOccurrencesOfString:@"Videos" withString:@"VideoThumbnailImg"];
                      thumbNilImg = [thumbNilImg stringByReplacingOccurrencesOfString:@".mp4" withString:@".jpg"];
                      NSLog(@"ThumbnilImg : %@",thumbNilImg);
                      videoUrl = [[NSURL alloc] initWithString:thumbNilImg];
                      
                      if(jsonData == nil)
                      {
                          jsonData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://115.113.151.199:8007/Content/ChatData/Video/Chk%20Abhi.mp4"]];
                      }
                      
                          jsonData = [[NSData alloc] initWithContentsOfURL:videoUrl];
                          [messageDict setValue:jsonData  forKey:@"msg"];
                          MessageData *message = [[MessageData alloc] init];
                          [SVProgressHUD dismiss];

                         JSBubbleMessageType msgType;
                         msgType = JSBubbleMessageTypeIncoming;
                
                         [CommonNotification setMessageDetailsForChatWithUserID:[[responseDict objectAtIndex:i]valueForKey:@"FromUserId"] :[message createdDictionaryForMsgId:chatUserID text:nil date:[NSDate date] msgType:msgType imageData:nil attachment:jsonData videoURL:[NSString stringWithFormat:@"%@", goodMsg] mediaType:JSBubbleMediaTypeImage imageurl:nil download:@"0"]];
                      
                }
                else
                {
                    [messageDict setValue:goodMsg  forKey:@"msg"];
                    [messageDict setValue:[NSDate date] forKey:@"date"];
                    [SVProgressHUD dismiss];
                    [messageDict setValue:[NSString stringWithFormat:@"%ld",(long)JSBubbleMessageTypeIncoming] forKey:@"msgType"];
                    [CommonNotification setMessageDetailsForChatWithUserID:[[responseDict objectAtIndex:i]valueForKey:@"FromUserId"] :messageDict];
                }
             }
            [JSMessageSoundEffect playMessageReceivedSound];
               
           }
        }
    }
   [self reloadTable];
}



-(UIImage*)getimagefromUrl:(NSURL*)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

- (void)reloadTable
{
    self.messageArray = [NSMutableArray array];
    self.messageArray = [CommonNotification getMessageDetailsForChatWithUserID:chatUserID];
      self.isdownload=[[NSMutableArray alloc]init];
    for (int i=0; i <self.messageArray.count; i++)
    {
        [self.isdownload addObject:@"0"];
    }
    ischecked=NO;
    [self.tableView reloadData];
    self.title = titleName;
    if (self.messageArray.count > 0)
    {
        deleteHistoryButton.hidden = false;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    else
    {
        deleteHistoryButton.hidden = true;
    }
}


-(void)deleteHistoryButton
{
    [[self view] endEditing:YES];
    if (IS_IOS8)
    {
        UIAlertController *alertVC1 = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to clear this message(s)?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self handleOkAction];
                                   }];
        [alertVC1 addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [alertVC1 addAction:cancelAction];
        [self presentViewController:alertVC1 animated:YES completion:nil];
    }
    else
    {
       // UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to clear this message(s)?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        //alert.tag = 00;
        //[alert show];
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 00)
//    {
//       if (buttonIndex == 0)
//       {
//          [self handleOkAction];
//       }
//    }
//}
-(void)handleOkAction
{
    [CommonNotification resetMessagesForUser:chatUserID];
    [self.navigationController popViewControllerAnimated:true];
}

-(void)handelBackButtonInCHat
{
    id parent=self;
    [Parameters popToViewControllerNamed:@"ChatContactsViewController" from:parent];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)deleteChatOnBack
{
    [[self view] endEditing:YES];
    if (IS_IOS8)
    {
        UIAlertController *alertVC1 = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"After leaving chatbox and again login your previous chat contents gets clear" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self.navigationController popViewControllerAnimated:YES];
                                   }];
        [alertVC1 addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }];
        [alertVC1 addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"After leaving chatbox and again login your previous chat contents gets clear" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
//        [alert show];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - Messages view delegate
- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    userText=text;
    if (serviceIntegration != nil)
    {
        serviceIntegration = nil;
    }
    serviceIntegration = [[ServerIntegration alloc]init];
    text=[self removeQuotesFromHTML:text];
    MessageData *message = [[MessageData alloc] init];
    
    //To send encoded data for emogies
    NSString *uniText = [NSString stringWithUTF8String:[text UTF8String]];
    NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    text = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding];
    
   [self.messageArray addObject:[message createdDictionaryForMsgId:chatUserID text:userText date:[NSDate date] msgType:JSBubbleMessageTypeOutgoing imageData:@"" ? [NSString stringWithFormat:@"%@",@""] : @"" attachment:nil videoURL: nil mediaType:JSBubbleMediaTypeText imageurl:@"ada" download:@"1"]];
    
    [CommonNotification setMessageDetailsForChatWithUserID:chatUserID :[message createdDictionaryForMsgId:chatUserID text:userText date:[NSDate date] msgType:JSBubbleMessageTypeOutgoing imageData:chatUserImageURL ? [NSString stringWithFormat:@"%@",chatUserImageURL] : @"" attachment:nil videoURL:nil mediaType:JSBubbleMediaTypeText imageurl:@"ada" download:@"1"]];
    
    [serviceIntegration InsertChatMessage:self FromUser:CURRENT_USER_ID ToUser:chatUserID ChatMessage:text Type:@"Text" data:nil fileName:@"" videoData:nil :@selector(receivedResponseDataChatMessage:)];
     mediaType = @"text";
    
    [self reloadTable];

    [self finishSend:NO];
}

- (NSString *)removeQuotesFromHTML:(NSString *)html
{
//    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
//    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
//    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
//    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    html = [html stringByReplacingOccurrencesOfString:@"&"  withString:@"%26"];
    return html;
}//end

-(void)receivedResponseDataChatMessage :(NSMutableDictionary *)respnonseDict
{
    NSLog(@"%@",respnonseDict);
    if (respnonseDict!=nil && respnonseDict.count>0 && [respnonseDict objectForKey:@"success"]!=nil)
    {
        
        if ([[respnonseDict valueForKey:@"success"] isEqualToString:@"true"])
        {
            if([mediaType isEqualToString:@"text"])
            {
                
            }
            else if([mediaType isEqualToString:@"image"])
            {
               [SVProgressHUD showSuccessWithStatus:@"Image Sent Successfully"];
                cameraFlag = 1;
                mediaType = nil;
            }
            else if([mediaType isEqualToString:@"video"])
            {
                [SVProgressHUD showSuccessWithStatus:@"Video Sent Successfully"];
                videoFlag = 1;
                mediaType = nil;
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[respnonseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (void)cameraPressed:(id)sender
{
    NSUserDefaults *nsdef = [NSUserDefaults standardUserDefaults];
    NSUserDefaults *nsdef1 = [NSUserDefaults standardUserDefaults];

    if([[nsdef1 objectForKey:@"off"] isEqualToString:@"online"])
    {
        if([nsdef integerForKey:@"one"] == 1)
        {
            [self showOverwriteAlert];
        }
        else
        {
            [self.inputToolBarView.textView resignFirstResponder];
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture from Gallery",@"Take a picture from Camera",@"Take a video from Gallery",@"Take a video from Camera", nil];
            [actionSheet showInView:self.view];
        }
        [nsdef synchronize];
    }
    else
    {
        [self.inputToolBarView.textView resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:nil otherButtonTitles:@"Take a picture from Gallery",@"Take a picture from Camera",@"Take a video from Gallery",@"Take a Video from camera", nil];
        [actionSheet showInView:self.view];
    }
    [nsdef1 synchronize];
}

-(void)showOverwriteAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC1 = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"User has loged in from Web." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       
                                   }];
        [alertVC1 addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           
                                       }];
        [alertVC1 addAction:cancelAction];
        [self presentViewController:alertVC1 animated:YES completion:nil];
    }
    else
    {
//        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"User has loged in from Web." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        alrt.tag = 1;
//        [alrt show];
    }
}



#pragma mark -- UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    pickerObj = [[UIImagePickerController alloc]init];
    pickerObj.allowsEditing=YES;
    pickerObj.delegate = self;
    
    switch (buttonIndex)
    {
        case 0:
        {
            insertMediaType = @"Image";
            pickerObj.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self  presentViewController:pickerObj animated:YES completion:nil];
            break;
        }
        case 1:
        {
            insertMediaType = @"Image";
            if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])
            {
                pickerObj.sourceType =UIImagePickerControllerSourceTypeCamera;
                pickerObj.cameraCaptureMode = UIImagePickerControllerQualityTypeHigh;
                [self presentViewController:pickerObj animated:YES completion:nil];
            }
            else
            {
            }
            int value = arc4random() % 1000;
            msgId = [NSString stringWithFormat:@"%d",value];
            JSBubbleMessageType msgType;
            if((self.messageArray.count - 1) % 2)
            {
                msgType = JSBubbleMessageTypeOutgoing;
                [JSMessageSoundEffect playMessageSentSound];
            }
            else
            {
                msgType = JSBubbleMessageTypeIncoming;
                [JSMessageSoundEffect playMessageReceivedSound];
            }
            break;
        }
        case 2:
        {
            insertMediaType = @"GalleryVideo";
            pickerObj.modalPresentationStyle = UIModalPresentationCurrentContext;
            pickerObj.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            pickerObj.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
            pickerObj.videoQuality = UIImagePickerControllerQualityTypeHigh;
            [self  presentViewController:pickerObj animated:YES completion:nil];
            break;
        }
        case 3:
        {
            insertMediaType = @"Video";
            [self handleCaptureVideo];
            break;
        }
    }
}

-(void)handleCaptureVideo
{
   if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSArray *sourceTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerObj.sourceType];
        NSLog(@"Available types for source as camera = %@", sourceTypes);
        if (![sourceTypes containsObject:(NSString*)kUTTypeMovie] )
        {
            return;
        }
        pickerObj.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerObj.mediaTypes = [NSArray arrayWithObject:(NSString*)kUTTypeMovie];
        pickerObj.videoQuality = UIImagePickerControllerQualityTypeMedium;
        pickerObj.videoMaximumDuration = 100;
        [self presentViewController:pickerObj animated:YES completion:NULL];
    }
    else
    {
        
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.messageArray[indexPath.row] valueForKey:@"msgType"] integerValue];
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.messageArray[indexPath.row] valueForKey:@"medType"] integerValue];
    return 0;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
       return JSMessagesViewTimestampPolicyEveryThree;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    return JSAvatarStyleCircle;
}

- (JSInputBarStyle)inputBarStyle
{
    return JSInputBarStyleFlat;
}



#pragma mark - Messages view data source
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[self.messageArray[indexPath.row] valueForKey:@"msg"] isKindOfClass:[NSData class]])
    {
        return nil;
    }
    else
        return [self.messageArray[indexPath.row] valueForKey:@"msg"];
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    MessageData *message = self.messageArray[indexPath.row];
//    return message.date;
    return 0;
}

- (UIImage *)avatarImageForIncomingMessage
{
    
    if(chatUserImageURL == nil)
    {
        return [UIImage imageNamed:@"default_profile_img.png"];
    }
    else
    {
        UIImageView *img = [[UIImageView alloc]init];
        
        NSString *imageData = [CommonNotification getImageURLForChatWithUserID:chatUserID];
        if (imageData) {
            [img setImageWithURL:[NSURL URLWithString:imageData] placeholderImage:[UIImage imageNamed:@"default_profile_img.png"]];
        }
        else{
             [img setImageWithURL:chatUserImageURL placeholderImage:[UIImage imageNamed:@"default_profile_img.png"]];
        }
       return img.image;
    }
}

- (SEL)avatarImageForIncomingMessageAction
{
    return @selector(onInComingAvatarImageClick);
}

- (void)onInComingAvatarImageClick
{
    NSLog(@"__%s__",__func__);
}

- (SEL)avatarImageForOutgoingMessageAction
{
    return @selector(onOutgoingAvatarImageClick);
}

- (void)onOutgoingAvatarImageClick
{
    NSLog(@"__%s__",__func__);
}

- (UIImage *)avatarImageForOutgoingMessage
{
   
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
    
    if ([CURRENT_USER_IMAGE hasSuffix:@"default_Contact.png"] || [CURRENT_USER_IMAGE hasSuffix:@"noimage.png"] )
    {
        img.image = [UIImage imageNamed:@"default_profile_img.png"];
    }
    else
    {
        if ([CURRENT_USER_IMAGE hasSuffix:@".png"] || [CURRENT_USER_IMAGE hasSuffix:@".jpg"]|| [CURRENT_USER_IMAGE hasSuffix:@".JPG"])
        {
            NSURL *url = [NSURL URLWithString:[CURRENT_USER_IMAGE
                                               stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            [img setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_profile_img.png"]];
        }
        else {
            img.image = [UIImage imageNamed:@"default_profile_img.png"];
        }
    }
    return img.image;
}

- (UIImage *)dataForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger indextype=[indexPath row];
    NSLog(@"indexttype %ld",(long)indextype);
   return [UIImage imageWithData:[[self.messageArray objectAtIndex:indextype] valueForKey:@"attachment"]];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    MessageData *message = [[MessageData alloc] init];
    JSBubbleMessageType msgType;
    msgType = JSBubbleMessageTypeOutgoing;
    [JSMessageSoundEffect playMessageSentSound];
    
    fileName = [NSString stringWithFormat:@"ios_%0.0f", ([[NSDate date] timeIntervalSince1970] * 1000)];
    type = [info objectForKey:UIImagePickerControllerMediaType];

      if ([insertMediaType isEqualToString:@"Video"] )
      {
          NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
          [opQueue addOperationWithBlock:^
           {
               NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
               chosevideo = [NSData dataWithContentsOfURL:videoUrl];
               fileName = [NSString stringWithFormat:@"%@",fileName];
               UIImage *videoImg=[self createImageWithURL:videoUrl frame:5];
               NSData *uploadData = UIImageJPEGRepresentation(videoImg,0.5);
               NSData *viddata=[NSData dataWithContentsOfURL:videoUrl];
    
               NSURL *movieUrl = [info objectForKey:UIImagePickerControllerMediaURL];
               ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
               [library writeVideoAtPathToSavedPhotosAlbum:movieUrl completionBlock:^(NSURL *newURL, NSError *error){
               if (error)
               {
                   NSLog( @"Error writing image with metadata to Photo Library: %@", error );
               }
               else
               {
                   [[NSOperationQueue mainQueue] addOperationWithBlock:^
                   {
                       [self.messageArray addObject:[message createdDictionaryForMsgId:chatUserID text:nil date:[NSDate date] msgType:msgType imageData:chatUserImageURL ? [NSString stringWithFormat:@"%@",chatUserImageURL] : @"" attachment:uploadData videoURL:[NSString stringWithFormat:@"%@",newURL] mediaType:JSBubbleMediaTypeImage imageurl:@"ada" download:@"1"]];
                
                       [CommonNotification setMessageDetailsForChatWithUserID:chatUserID :[message createdDictionaryForMsgId:chatUserID text:nil date:[NSDate date] msgType:msgType imageData:chatUserImageURL ? [NSString stringWithFormat:@"%@",chatUserImageURL] : @"" attachment:uploadData videoURL:[NSString stringWithFormat:@"%@",newURL] mediaType:JSBubbleMediaTypeImage imageurl:@"ada" download:@"1"]];
                
                      totalSeconds = 40;
                      videoFlag=0;
                      videoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                              target:self
                                                            selector:@selector(videoTimer)
                                                            userInfo:nil
                                                             repeats:YES];
                
                      [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeBlack];
                      mediaType = @"video";
                
                      [serviceIntegration InsertChatMessage:self FromUser:CURRENT_USER_ID ToUser:chatUserID ChatMessage:@"" Type:insertMediaType data:videoImg fileName:fileName videoData:viddata :@selector(receivedResponseDataChatMessage:)];
                    
                     [self reloadTable];
                   }];
            }
                   }];
        }];
          mediaType = @"video";
    }
    else if([insertMediaType isEqualToString:@"GalleryVideo"] ||[type isEqualToString:(NSString *)kUTTypeVideo] || [type isEqualToString:(NSString *)kUTTypeMovie] )
    {
        NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
        [opQueue addOperationWithBlock:^
         {
             NSURL *videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
             chosevideo = [NSData dataWithContentsOfURL:videoUrl];
             fileName = [NSString stringWithFormat:@"%@",fileName];
             UIImage *VideoImg=[self createImageWithURL:videoUrl frame:5];
             NSData *uploadData = UIImageJPEGRepresentation(VideoImg,0.5);
             NSData *viddata=[NSData dataWithContentsOfURL:videoUrl];
             
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^
                      {
                          [self.messageArray addObject:[message createdDictionaryForMsgId:chatUserID text:nil date:[NSDate date] msgType:msgType imageData:chatUserImageURL ? [NSString stringWithFormat:@"%@",chatUserImageURL] : @"" attachment:uploadData videoURL:[NSString stringWithFormat:@"%@",videoUrl] mediaType:JSBubbleMediaTypeImage imageurl:@"ada" download:@"1"]];
                          
                          [CommonNotification setMessageDetailsForChatWithUserID:chatUserID :[message createdDictionaryForMsgId:chatUserID text:nil date:[NSDate date] msgType:msgType imageData:chatUserImageURL ? [NSString stringWithFormat:@"%@",chatUserImageURL] : @"" attachment:uploadData videoURL:[NSString stringWithFormat:@"%@",videoUrl] mediaType:JSBubbleMediaTypeImage imageurl:@"ada" download:@"1"]];
                          
                          totalSeconds = 40;
                          videoFlag=0;
                          videoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                        target:self
                                                                      selector:@selector(videoTimer)
                                                                      userInfo:nil
                                                                       repeats:YES];
                          
                          [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeBlack];
                          mediaType = @"video";
                          
                          [serviceIntegration InsertChatMessage:self FromUser:CURRENT_USER_ID ToUser:chatUserID ChatMessage:@"" Type:@"Video" data:VideoImg fileName:fileName videoData:viddata :@selector(receivedResponseDataChatMessage:)];
                          
                          [self reloadTable];
                      }];
             
            
         }];
        mediaType = @"video";

    }
    else
    {
        UIImage *myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSURL *imgUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        
        NSOperationQueue *opQueue = [[NSOperationQueue alloc] init];
        [opQueue addOperationWithBlock:^
         {
             CGFloat compression = 0.3f;
             CGFloat maxCompression = 0.1f;
             int maxFileSize = 190*1024;
             
             NSData *uploadData = UIImageJPEGRepresentation(myImage, compression);
             while ([uploadData length] > maxFileSize && compression > maxCompression)
             {
                compression -= 0.01;
                uploadData = UIImageJPEGRepresentation(myImage, compression);

             }
             
             [[NSOperationQueue mainQueue] addOperationWithBlock:^
              {
                 [self.messageArray addObject:[message createdDictionaryForMsgId:chatUserID text:nil date:[NSDate date] msgType:msgType imageData:[NSString stringWithFormat:@"%@", imgUrl] attachment:uploadData videoURL:nil mediaType:JSBubbleMediaTypeImage imageurl:@"ada" download:@"1"]];
        
                 [CommonNotification setMessageDetailsForChatWithUserID:chatUserID :[message createdDictionaryForMsgId:chatUserID text:nil date:[NSDate date] msgType:msgType imageData:[NSString stringWithFormat:@"%@", imgUrl] attachment:uploadData videoURL:nil mediaType:JSBubbleMediaTypeImage imageurl:@"ada" download:@"1"]];
        
                totalSeconds = 40;
                cameraFlag = 0;
                type = @"0";
                videoTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(cameraTimer)
                                                    userInfo:nil
                                                     repeats:YES];
        
                [SVProgressHUD showWithStatus:@"Sending..." maskType:SVProgressHUDMaskTypeBlack];
                mediaType = @"image";
                [serviceIntegration InsertChatMessage:self FromUser:CURRENT_USER_ID ToUser:chatUserID ChatMessage:nil Type:insertMediaType data:myImage  fileName:fileName videoData:nil :@selector(receivedResponseDataChatMessage:)];
                  
               [self reloadTable];
              }];
         }];
    }
}

- (void)videoTimer
{
    totalSeconds--;
    if ( totalSeconds == 0 )
    {
        if (videoFlag == 0)
        {
            mediaType = @"video";
            [videoTimer invalidate];
            [SVProgressHUD dismiss];
             [SVProgressHUD showWithStatus:@"Your internet is slow Please Wait..." maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}

-(void)cameraTimer
{
    totalSeconds--;
    if ( totalSeconds == 0 )
    {
        if(cameraFlag == 0)
        {
            mediaType = @"image";
            [videoTimer invalidate];
            [SVProgressHUD showWithStatus:@"Your internet is slow Please Wait..." maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

-(UIImage *)createImageWithURL:(NSURL *)videoUrl frame:(int)withFPS
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.requestedTimeToleranceAfter =  kCMTimeZero;
    generator.requestedTimeToleranceBefore =  kCMTimeZero;
    UIImage *generatedImage;

           CMTime time = CMTimeMake(1, withFPS);
    time.value=1;
           NSError *err;
            CMTime actualTime;
            CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&err];
            generatedImage = [[UIImage alloc] initWithCGImage:image];
    
    if([insertMediaType isEqualToString:@"Video"])
    {
      // return generatedImage;
                UIImage * portraitImage = [[UIImage alloc] init];
                portraitImage=[Parameters rotateImage:generatedImage byDegree:90];
                return portraitImage;

    }
    else
    {
        return generatedImage;
    }
}

@end

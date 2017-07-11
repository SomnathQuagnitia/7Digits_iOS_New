//
//  JSMessagesViewController.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"
#import "ChatMeassageVC.h"
#import "MessageData.h"
#import "Constant.h"
#import <mach/mach.h>
#import <mach/mach_host.h>

#define OSVersionIsAtLeastiOS7  (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define INPUT_HEIGHT 46.0f

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate>
{
    UIButton *sendButton;
    UIButton *cameraButton;
    JSBubbleMessageCell *cell1;
    JSBubbleMessageCell *cell;
    NSURL *videoUrl1;
}
- (void)setup;

@end

@implementation JSMessagesViewController
@synthesize cameraButton,videodata,saveBtn,videoSaveBtn;
- (void)loadView
{
    [super loadView];
    [self fixFrame];
    saveBtn.layer.cornerRadius = 4;
}

- (void)fixFrame
{
    CGRect frame = [UIScreen mainScreen].bounds;
    if (OSVersionIsAtLeastiOS7 == YES)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    else
    {
        frame.size.height -= 20 + 44;
    }
    self.view.frame = frame;
    self.view.bounds = frame;
}


#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]])
    {
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;
    CGRect tableFrame = CGRectMake(0.0f, 0.0f, size.width, size.height - INPUT_HEIGHT);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self; 
	[self.view addSubview:self.tableView]; 
	UIButton* mediaButton = nil;
    
//	if (kAllowsMedia)
//	{
		// set up the image and button frame
		UIImage* image = [UIImage imageNamed:@"chatkeyboard@2x.png"];
		CGRect frame = CGRectMake(4, 0, image.size.width, image.size.height);
		CGFloat yHeight = (INPUT_HEIGHT - frame.size.height) / 2.0f;
		frame.origin.y = yHeight;
		mediaButton = [[UIButton alloc] initWithFrame:frame];
		[mediaButton setBackgroundImage:image forState:UIControlStateNormal];
		
		
    [mediaButton addTarget:self action:@selector(hideKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
     CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;
    self.inputToolBarView.textView.placeHolder = @"Enter Text";
    
   sendButton = [self sendButton];
    sendButton.enabled = NO;
    sendButton.frame = CGRectMake(self.inputToolBarView.frame.size.width - 65.0f, 8.0f, 59.0f, 26.0f);
    [sendButton addTarget:self
                   action:@selector(sendPressed:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setSendButton:sendButton];
    
    cameraButton = [[UIButton alloc]init];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    cameraButton.frame = CGRectMake(sendButton.frame.origin.x - 20 , (self.inputToolBarView.frame.size.height / 2) - 16, 32.0f, 32.0f);
    [cameraButton addTarget:self
                   action:@selector(cameraAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView setCameraButton:cameraButton];
    [self.view addSubview:self.inputToolBarView];
    
	if (kAllowsMedia)
	{
		CGRect frame = self.inputToolBarView.sendButton.frame;
		frame.size.width -= 16;
		frame.origin.x += 16;
		self.inputToolBarView.sendButton.frame = frame;
		
		// add the camera button
		[self.inputToolBarView addSubview:mediaButton];
        
		// move the tet view over
		frame = self.inputToolBarView.textView.frame;
		frame.origin.x += mediaButton.frame.size.width + mediaButton.frame.origin.x;
		frame.size.width -= mediaButton.frame.size.width + mediaButton.frame.origin.x;
		frame.size.width += 16;		// from the send button adjustment above
		self.inputToolBarView.textView.frame = frame;
	}
    self.selectedMarks = [NSMutableArray new];
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
}

-(void)hideKeyBoard: (id)sender
{
    [[self view] endEditing:YES];
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    ischecked=YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self scrollToBottomAnimated:NO];
    _originalTableViewContentInset = self.tableView.contentInset;
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    imgNew=nil;
    downloadImg=nil;
    smallImage=nil;
    cell.avatarImageView=nil;
    self.fullScreenView=nil;
    cell.bubbleView=nil;
    
    [super didReceiveMemoryWarning];

    NSString *memory =@"Recived low memory warning , Do you want to clear this all Data....?";
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
    if (IS_IOS8)
    {
        alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:memory preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                        [CommonNotification resetMessagesAfterLogoutForAll];
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                   }];
        [alertVC addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [alertVC addAction:cancelAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
//        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:memory delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"No", nil];
//        [alrt show];
    }
    alertVC=nil;
   

}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        [CommonNotification resetMessagesAfterLogoutForAll];
//    }
//}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.inputToolBarView = nil;
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
    [self.delegate sendPressed:sender
                      withText:[self.inputToolBarView.textView.text trimWhitespace] ];
}

- (void)cameraAction:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(cameraPressed:)])
    {
        [self.delegate cameraPressed:sender];
    }
}

-(void)setUpImage
{
    imgNew= [[UIImageView alloc]init];
    imgFrame = imgNew.frame;
    imgFrame.size = CGSizeMake(40, 40);
    imgFrame.origin.x = (cell.bubbleView.bubbleFrame.origin.x + cell.bubbleView.bubbleFrame.size.width/2) - imgFrame.size.width/2;
    imgFrame.origin.y = (cell.bubbleView.bubbleFrame.origin.y + cell.bubbleView.bubbleFrame.size.height/2) - imgFrame.size.height/2;
    [imgNew setImage:[UIImage imageNamed:@"play.png"]];
    if(IS_IPhone_6)
    {
        if (imgFrame.origin.x==177)
        {
            imgFrame.origin.x=232;
        }
    }
    else if(IS_IPHONE_6P)
    {
        [self setUpImage];
        if (imgFrame.origin.x==162.5)
        {
            imgFrame.origin.x=256.5;
        }
    }
    else
    {
        imgNew.frame = imgFrame;
        [cell.bubbleView addSubview:imgNew];
    }
     imgNew.frame = imgFrame;
    [cell.bubbleView addSubview:imgNew];
 }

-(void)saveVideoButton
{
    videoSaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(16, 6, 70, 30)];
    [videoSaveBtn setTitle:@"Save" forState:UIControlStateNormal];
    videoSaveBtn.layer.cornerRadius = 8;
    [videoSaveBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)];
    [videoSaveBtn setBackgroundColor:[UIColor orangeColor]];
    [videoSaveBtn addTarget:self action:@selector(videoSaveBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.bubbleView addSubview:videoSaveBtn];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSBubbleMediaType mediaType= [self.delegate messageMediaTypeForRowAtIndexPath:indexPath];
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = NO;//[self shouldHaveAvatarForRowAtIndexPath:indexPath];
    NSInteger row = indexPath.row;
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%ld_%d_%d_%d_%ld",(long)type, bubbleStyle, hasTimestamp, hasAvatar, (long)row];
    cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    if(!cell)
        cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                   avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone mediaType:mediaType
                                                  hasTimestamp:hasTimestamp
                                               reuseIdentifier:CellID];
    
    if(hasTimestamp)
        [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
    
    if(hasAvatar)
    {
        switch (type)
        {
            case JSBubbleMessageTypeIncoming:
                [cell setAvatarImage:[self.dataSource avatarImageForIncomingMessage]];
                [cell setAvatarImageTarget:self.dataSource action:[self.dataSource avatarImageForIncomingMessageAction]];
                break;
                
            case JSBubbleMessageTypeOutgoing:
                [cell setAvatarImage:[self.dataSource avatarImageForOutgoingMessage]];
                [cell setAvatarImageTarget:self.dataSource action:[self.dataSource avatarImageForOutgoingMessageAction]];
                break;
        }
    }
    if (kAllowsMedia)
    {
            [self setAnimationView];
            [cell setMedia:[self.dataSource dataForRowAtIndexPath:indexPath]];
           // NSLog(@"indextype %ld",(long)indexPath.row);
        
       if ([[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"medType"] integerValue] == 1)
       {
        if ([[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"download"]isEqualToString:@"0"])
            {
                [cell setMedia:[self.dataSource dataForRowAtIndexPath:indexPath]];
               if ([[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"videoURL"])
                {
                    if(IS_IPhone_6)
                    {
                        [self setUpImage];
                        if (imgFrame.origin.x==177)
                        {
                            imgFrame.origin.x=232;
                        }
                        imgNew.frame = imgFrame;
                        [self setUpImage];
                        [cell.bubbleView addSubview:imgNew];
                        imgNew = nil;
                    }
                    else if(IS_IPHONE_6P)
                    {
                        [self setUpImage];
                        if (imgFrame.origin.x==162.5)
                        {
                            imgFrame.origin.x=256.5;
                        }
                        imgNew.frame = imgFrame;
                        [self setUpImage];
                        [cell.bubbleView addSubview:imgNew];
                        imgNew = nil;
                    }
                    else
                    {
                        [self setUpImage];
                        [cell.bubbleView addSubview:imgNew];
                        imgNew = nil;
                        
                    }

                    [self saveVideoButton];
                     videoSaveBtn.tag = indexPath.row;
                    
                    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
                    switch (type)
                    {
                        case JSBubbleMessageTypeIncoming:
                            [videoSaveBtn setHidden:NO];
                            break;
                            
                        case JSBubbleMessageTypeOutgoing:
                            [videoSaveBtn setHidden:YES];
                            break;
                    }
                }
            }
            else
            {
                if ([[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"videoURL"])
                {
                    if(IS_IPhone_6)
                    {
                        [self setUpImage];
                        if (imgFrame.origin.x==177)
                        {
                            imgFrame.origin.x=232;
                        }
                        imgNew.frame = imgFrame;
                         [self setUpImage];
                        [cell.bubbleView addSubview:imgNew];
                        imgNew = nil;
                    }
                    else if(IS_IPHONE_6P)
                    {
                       [self setUpImage];
                        if (imgFrame.origin.x==162.5)
                        {
                            imgFrame.origin.x=256.5;
                        }
                        imgNew.frame = imgFrame;
                         [self setUpImage];
                        [cell.bubbleView addSubview:imgNew];
                        imgNew = nil;
                    }
                    else
                    {
                        [self setUpImage];
                        [cell.bubbleView addSubview:imgNew];
                        imgNew = nil;
                        
                    }
                    
                    //Here
                    [self saveVideoButton];
                    videoSaveBtn.tag = indexPath.row;

            
                    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
                    switch (type)
                    {
                        case JSBubbleMessageTypeIncoming:
                            [videoSaveBtn setHidden:NO];
                            break;
                            
                        case JSBubbleMessageTypeOutgoing:
                            [videoSaveBtn setHidden:YES];
                            break;
                    }
                
                    if ([[self.isdownload objectAtIndex:indexPath.row]isEqualToString:@"1"])
                    {
                        NSString *filePath = [[self buildDocumentsPath] stringByAppendingPathComponent:[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"Filepath"]];
                        NSURL *url=[[NSURL alloc]initFileURLWithPath:filePath];
                        UIImage *img = [self createImageWithURL:url frame:5];
                        UIGraphicsBeginImageContextWithOptions(img.size, YES, [UIScreen mainScreen].scale);
                        [cell setMedia:img];
                    }
                    else
                    {
                        if([[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"Filepath"])
                        {
                            NSString *filePath = [[self buildDocumentsPath] stringByAppendingPathComponent:[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"Filepath"]];
                            videoUrl1 = [[NSURL alloc]initFileURLWithPath:filePath];
                            imgNew=(UIImageView *)[self createImageWithURL:videoUrl1 frame:5];
                            [cell setMedia:imgNew];
                        }
                        else
                        {
                          [cell setMedia:[self.dataSource dataForRowAtIndexPath:indexPath]];
                        }
                    }
                }
                else
                {
                   
                     [cell setMedia:[self.dataSource dataForRowAtIndexPath:indexPath]];
                    
                }
            }
        }
    }
    [self setAnimationView];
    [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
    [cell setBackgroundColor:tableView.backgroundColor];
    cell.isSelected = [self.selectedMarks containsObject:CellID] ? YES : NO;
    return cell;
}

-(void)videoSaveBtnClicked:(UIButton *)videoSaveButton
{
    ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
    [libraryFolder addAssetsGroupAlbumWithName:@"7EvenDigit Video" resultBlock:^(ALAssetsGroup *group)
    {
        NSLog(@"Adding Folder:'7EvenDigit Video', success: %s", group.editable ? "Success" : "Already created: Not Success");
    } failureBlock:^(NSError *error)
    {
        NSLog(@"Error: Adding on Folder");
    }];
   
    NSLog(@" Video indextype %ld",(long)videoSaveButton.tag);
    self.library = [[ALAssetsLibrary alloc] init];
    NSString *videoString = [[self.messageArray objectAtIndex:videoSaveButton.tag]valueForKey:@"videoURL"];
    NSLog(@"VideoStr : %@",videoString);
    NSURL *videoUrl = [[NSURL alloc] initWithString:videoString];
    [self downloadVideo:videoUrl];
    
}


- (void)downloadVideo:(NSURL *)videoURL
{
    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        NSData *urlData = [NSData dataWithContentsOfURL:videoURL];
        if (urlData)
        {
           NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"thefile.mp4"];
            [urlData writeToFile:filePath atomically:YES];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.library saveVideo:[NSURL fileURLWithPath:filePath] toAlbum:@"7EvenDigit Video" completion:^(NSURL *assetURL, NSError *error)
                 {
                     NSLog(@"Success downloaded");
                     [SVProgressHUD showSuccessWithStatus:@"Video saved successfully" maskType:SVProgressHUDMaskTypeBlack];
                 }
                                failure:^(NSError *error)
                {
                     NSLog(@"Error : %@", [error localizedDescription]);
                 }];
            });
        }
    });
}



-(UIImage *)createImageWithURL:(NSURL *)videoUrl frame:(int)withFPS
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.requestedTimeToleranceAfter =  kCMTimeZero;
    generator.requestedTimeToleranceBefore =  kCMTimeZero;
    UIImage *generatedImage;
    for (Float64 i = 0; i < CMTimeGetSeconds(asset.duration) *  withFPS ; i++){
        @autoreleasepool {
            CMTime time = CMTimeMake(i, withFPS);
            NSError *err;
            CMTime actualTime;
            CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&err];
            generatedImage = [[UIImage alloc] initWithCGImage:image];
            CGImageRelease(image);
        }
    }
    return generatedImage;
}

#pragma mark NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    progress=[[UIProgressView alloc]initWithFrame:CGRectMake(100, 350, 200, 100)];
    progress.backgroundColor=[UIColor yellowColor];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    progress.hidden = NO;
    [mediadata setLength:0];
   
    expectedBytes = [response expectedContentLength];
    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:0] afterDelay:0.0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
       [mediadata appendData:data];
       progressive = (float)[mediadata length] / (float)expectedBytes;
       [progress setProgress:progressive];
       [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:progressive] afterDelay:0.0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
  
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    [progress setAlpha:0];
    [UIView commitAnimations];
    
    progress.hidden = YES;

    [self performSelector:@selector(setProgress:) withObject:[NSNumber numberWithFloat:1.0] afterDelay:progressive];
    NSString *fileNamevideo;
    UIImage *img;
   
     if ([[self.messageArray objectAtIndex:_indextypeofarray]valueForKey:@"videoURL"])
     {
         [SVProgressHUD showSuccessWithStatus:@"Download Completed..."];

         NSString  *fileName = [NSString stringWithFormat:@"ios_%0.0f", ([[NSDate date] timeIntervalSince1970] * 1000)];
           fileNamevideo = [NSString stringWithFormat:@"%@.mp4",fileName];
          NSString *filePath = [[self buildDocumentsPath] stringByAppendingPathComponent:fileNamevideo];
           [mediadata writeToFile:filePath atomically:YES];
         NSURL *videoUrl = [[NSURL alloc]initFileURLWithPath:filePath];
         if ([[self.isdownload objectAtIndex:_indextypeofarray]isEqualToString:@"0"])
         {
             [self.isdownload replaceObjectAtIndex:_indextypeofarray withObject:@"1"];
         }
         img = [self createImageWithURL:videoUrl frame:5];
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        NSURL *url;
        if([[self.messageArray objectAtIndex:_indextypeofarray]valueForKey:@"Filepath"])
        {
            NSString *filePath = [[self buildDocumentsPath] stringByAppendingPathComponent:[[self.messageArray objectAtIndex:_indextypeofarray]valueForKey:@"Filepath"]];
            url =[[NSURL alloc]initFileURLWithPath:filePath];
        }
        else
        {
            url=[[NSURL alloc]initWithString:[[self.messageArray objectAtIndex:_indextypeofarray]valueForKey:@"videoURL"]];
        }
        controller.player = [AVPlayer playerWithURL:url];
        [self presentViewController:controller animated:YES completion:nil];
        [controller.player play];
    }
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    [CommonNotification updatedownloadstatus:[[self.messageArray objectAtIndex:_indextypeofarray] valueForKey:@"ChatMessageId"] senderuserid:[[self.messageArray objectAtIndex:_indextypeofarray] valueForKey:@"SenderUserId"] indextypeofmessage:_indextypeofarray mediadata:mediadata filename:fileNamevideo ];
    arr = [CommonNotification getMessageDetailsForChatWithUserID:[[self.messageArray objectAtIndex:_indextypeofarray] valueForKey:@"SenderUserId"]];
    
    [self.messageArray removeAllObjects];
    [cell.bubbleView setAlpha:1.0f];
    [self.messageArray addObjectsFromArray:arr];
    cell.userInteractionEnabled = YES;
    videoConnection = nil;
    [firstobj removeFromSuperview];
    [downloadImg removeFromSuperview];
    [self.tableView reloadData];
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return cachedResponse;
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

-(NSString *)buildDocumentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    return documentsPath;
}

-(void)setProgress:(NSNumber*)value
{
    [firstobj performSelectorOnMainThread:@selector(setProgress:) withObject:value waitUntilDone:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = NO;
    NSInteger row = indexPath.row;
    [self.inputToolBarView.textView resignFirstResponder];
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%ld_%d_%d_%d_%ld",(long)type, bubbleStyle, hasTimestamp, hasAvatar, (long)row];

    if ([self.selectedMarks containsObject:CellID])
        [self.selectedMarks removeObject:CellID];
    else
        [self.selectedMarks addObject:CellID];
    _indextypeofarray=indexPath.row;
    
    if ([[self.dataSource dataForRowAtIndexPath:indexPath] isKindOfClass:[UIImage class]])
    {
        if ([[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"videoURL"])
        {
        }
        else
        {
            cell1 = (JSBubbleMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
            self.fullScreenImageView.image = cell1.bubbleView.data;
            self.fullScreenView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.inputToolBarView.frame.size.height);
            [self.view addSubview:self.fullScreenView];
//            self.fullScreenImageView.image = cell1.bubbleView.data;
//            UIGraphicsBeginImageContext(CGSizeMake(480,320));
//            context = UIGraphicsGetCurrentContext();
//            [self.fullScreenImageView.image drawInRect: CGRectMake(0, 0, 480, 320)];
//            smallImage.image = UIGraphicsGetImageFromCurrentImageContext();
//            UIGraphicsEndImageContext();
//            smallImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.inputToolBarView.frame.size.height);
//            self.fullScreenView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            [self.imgScrollView setMaximumZoomScale:5.0f];
            [self.imgScrollView setClipsToBounds:YES];
            JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
            switch (type)
            {
                case JSBubbleMessageTypeIncoming:
                    [saveBtn setHidden:NO];
                    break;

                case JSBubbleMessageTypeOutgoing:
                    [saveBtn setHidden:YES];
                    break;
            }
            
            [self setAnimationView];
            [self.view addSubview:self.fullScreenView];
            
            if ([[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"download"]isEqualToString:@"0"])
            {
                NSString *urlname=[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"image"];
                NSURL *url=[[NSURL alloc]initWithString:urlname];
                NSURLRequest *reqobj=[NSURLRequest requestWithURL:url];
                cell1 = (JSBubbleMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
                firstobj = [[customview alloc] init:(self.view)];
                [firstobj setBackgroundColor:[UIColor clearColor]];
                firstobj.frame = cell1.bubbleView.bubbleFrame;
                firstobj.delegate = self;
                NSURLConnection *imageConnection = [[NSURLConnection alloc]initWithRequest:reqobj delegate:self];
                if(imageConnection)
                {
                    mediadata=[[NSMutableData alloc]init];
                }
             }
            else
            {
                cell1 = (JSBubbleMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
                self.fullScreenImageView.image = cell1.bubbleView.data;
                self.fullScreenView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.inputToolBarView.frame.size.height);
                [self.view addSubview:self.fullScreenView];
//                self.fullScreenImageView.image = cell1.bubbleView.data;
//                context = UIGraphicsGetCurrentContext();
//                [self.fullScreenImageView.image drawInRect: CGRectMake(0, 0, 480, 320)];
//                smallImage.image = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//                smallImage.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - self.inputToolBarView.frame.size.height);
//                self.fullScreenView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                [self.imgScrollView setMaximumZoomScale:5.0f];
                [self.imgScrollView setClipsToBounds:YES];
                JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
                switch (type)
                {
                    case JSBubbleMessageTypeIncoming:
                        [saveBtn setHidden:NO];
                        break;
                        
                    case JSBubbleMessageTypeOutgoing:
                        [saveBtn setHidden:YES];
                        break;
                }
            }
        }
    }
    if ([[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"videoURL"])
    {

        if ([[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"download"]isEqualToString:@"0"])
        {

            NSString *urlname=[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"videoURL"];
            NSURL *url=[[NSURL alloc]initWithString:urlname];
            NSURLRequest *reqobj=[NSURLRequest requestWithURL:url];
            cell1 = (JSBubbleMessageCell *)[tableView cellForRowAtIndexPath:indexPath];
            firstobj = [[customview alloc] init:(self.view)];
            [firstobj setBackgroundColor:[UIColor clearColor]];
            firstobj.frame = cell1.bubbleView.bubbleFrame;
            firstobj.delegate = self;
            [SVProgressHUD showWithStatus:@"Downloading..." maskType:SVProgressHUDMaskTypeBlack];
            videoConnection = [[NSURLConnection alloc]initWithRequest:reqobj delegate:self];
            if(videoConnection)
            {
                mediadata=[[NSMutableData alloc]init];
            }
            [videoConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
            [videoConnection start];
    }
    else
    {
        AVPlayerViewController *controller = [[AVPlayerViewController alloc] init];
        NSURL *url;
        if([[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"Filepath"])
        {
            NSString *filePath = [[self buildDocumentsPath] stringByAppendingPathComponent:[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"Filepath"]];
             url =[[NSURL alloc]initFileURLWithPath:filePath];
        }
        else
        {
            url=[[NSURL alloc]initWithString:[[self.messageArray objectAtIndex:indexPath.row]valueForKey:@"videoURL"]];
        }
        controller.player = [AVPlayer playerWithURL:url];
        [self presentViewController:controller animated:YES completion:nil];
        [controller.player play];
       }
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.fullScreenImageView;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self.delegate messageMediaTypeForRowAtIndexPath:indexPath])
    {
        return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
                                              timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                 avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }
    else
    {
        return [JSBubbleMessageCell neededHeightForImage:[self.dataSource dataForRowAtIndexPath:indexPath]
                                               timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                  avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy])
    {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy])
    {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

- (void)finishSend:(BOOL)isMedia
{
    if (!isMedia)
    {
        [self.inputToolBarView.textView setText:nil];
        [self textViewDidChange:self.inputToolBarView.textView];
    }
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    if(rows > 0)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated
{
	[self.tableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}


#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight)
    {
        changeInHeight = 0;
    }
    else
    {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f)
    {
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             if(isShrinking)
                             {
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking)
                             {
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
    self.inputToolBarView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.inputToolBarView.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = self.originalTableViewContentInset;
                         insets.bottom = self.view.frame.size.height - self.inputToolBarView.frame.origin.y - inputViewFrame.size.height;
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

-(IBAction)cancelFullScreenImage:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATruncationEnd;
    transition.subtype = kCATransitionFromLeft;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.view.layer addAnimation:transition forKey:nil];
    [self.imgScrollView setZoomScale:self.imgScrollView.minimumZoomScale animated:NO];
    [self.fullScreenView removeFromSuperview];
}

- (IBAction)saveImgBtnClicked:(UIButton *)sender
{
    ALAssetsLibrary* libraryFolder = [[ALAssetsLibrary alloc] init];
    [libraryFolder addAssetsGroupAlbumWithName:@"7EvenDigit Photo" resultBlock:^(ALAssetsGroup *group)
     {
         NSLog(@"Adding Folder:'7EvenDigit Photo', success: %s", group.editable ? "Success" : "Already created: Not Success");
     } failureBlock:^(NSError *error)
     {
         NSLog(@"Error: Adding on Folder");
     }];
    
    UIImage *chatImage1 = cell1.bubbleView.data;
    self.library = [[ALAssetsLibrary alloc] init];
       [self downloadImage:chatImage1];
}

- (void)downloadImage:(UIImage *)chatImage
{
    [SVProgressHUD showWithStatus:@"Saving..." maskType:SVProgressHUDMaskTypeBlack];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self.library saveImage:chatImage toAlbum:@"7EvenDigit Photo" completion:^(NSURL *assetURL, NSError *error)
                 {
                     NSLog(@"Success downloaded");
                     [SVProgressHUD showSuccessWithStatus:@"Image saved successfully" maskType:SVProgressHUDMaskTypeBlack];
                     [saveBtn setHidden:YES];
                 } failure:^(NSError *error){
                     NSLog(@"Error : %@", [error localizedDescription]);
                 }];
            });
    });
}

-(void)setAnimationView
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.type = kCATruncationStart;
    transition.subtype = kCATransitionFromLeft;
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [self.view.layer addAnimation:transition forKey:nil];
}
@end

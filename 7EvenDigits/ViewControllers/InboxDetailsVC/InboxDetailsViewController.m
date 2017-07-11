//
//  InboxDetailsViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "InboxDetailsViewController.h"
#import "ReplyViewController.h"
#import "Constant.h"
#import "Parameters.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface InboxDetailsViewController ()

@end

@implementation InboxDetailsViewController
@synthesize messageLabel,replyByLabel,repliedNameLabel,customCellDetailView,inboxMesgVC,labelForMessage,labelForTitle,labelForPostedBy,inboxDetailsArrayFromInbox,userImage,inboxDetailsArray,opendImageURL;
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
    
    webviewHeights = [[NSMutableArray alloc] init];
    
    self.title=@"Inbox Detail";
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    stringForTitle=self.title;
    
    [inboxDetailTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];
    
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
    
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 75.0f, 30.0f)];
        
        UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnAll setTitle:@"Reply" forState:UIControlStateNormal];
        [btnAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAll setFrame:CGRectMake(34.0f, 0.0f, 60.0f, 30.0f)];
        [btnAll addTarget:self action:@selector(handelReplyScreen:) forControlEvents:UIControlEventTouchUpInside];
        [customView addSubview:btnAll];
        
        UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customView];
        [self.navigationItem setRightBarButtonItem:rightBtn];
    

    
    [self tableFooterAdjustment];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self callInboxDetailWebService];
    [inboxDetailTable reloadData];
}
-(void)setInboxDetailData
{
    self.labelForTitle.text=[self.inboxDetailsArray valueForKey:@"Title"];
    //self.labelForMessage.text=[self.inboxDetailsArray valueForKey:@"PlainText"];
    
    [webViewForMain loadHTMLString:[Parameters decodeDataForEmogies:[self.inboxDetailsArray valueForKey:@"Message"]] baseURL:nil];
    
    self.labelForPostedBy.text=[self.inboxDetailsArray valueForKey:@"FromUser"];
    self.labelForDate.text=[self.inboxDetailsArray valueForKey:@"InboxDate"];
    
    NSURL *url = [NSURL URLWithString:[[self.inboxDetailsArray valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.userImage.image = [[UIImage alloc]initWithData:data];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunctionForProfile:)];

    tapped.numberOfTapsRequired = 1;
    [self.userImage setUserInteractionEnabled:true];
    [self.userImage addGestureRecognizer:tapped];
    [customCellDetailView.imageViewInReply setUserInteractionEnabled:YES];

}
-(void)myFunctionForProfile:(UITapGestureRecognizer *) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);
    NSURL *url = [NSURL URLWithString:[[self.inboxDetailsArray valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imageViewFOrLargeImage.image = [[UIImage alloc]initWithData:data];
    self.ViewforLargeImage.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:self.ViewforLargeImage];
}
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath
{
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        NSLog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
    }
}

-(void)callInboxDetailWebService
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
        
        [serviceIntegration InboxDetailsList:self UserId:CURRENT_USER_ID MessageId:[[self.inboxDetailsArrayFromInbox objectAtIndex:0]valueForKey:@"MessageId"] PostedById:[[self.inboxDetailsArrayFromInbox objectAtIndex:0]valueForKey:@"FromUserId"] FromInbox:@"true" :@selector(receivedResponseDataInboxDetails:)];
    }
}
- (void)receivedResponseDataInboxDetails:(NSDictionary *)responseDict
{
     [SVProgressHUD dismiss];
   // NSLog(@"%@",responseDict);
    inboxDetailsArray = [[NSMutableDictionary alloc]initWithDictionary:responseDict];
    for (int i = 0; i < [[self.inboxDetailsArray valueForKey:@"Replies"] count]; i++) {
        [webviewHeights addObject:@"0"];
    }
    //[inboxDetailsArray addObject:responseDict];
    [self setInboxDetailData];
    [inboxDetailTable reloadData];

}

-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handelHomeVC
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}

-(void)handelReplyScreen:(id)sender
{
    ReplyViewController *replyVC=[[ReplyViewController alloc]initWithNibName:@"ReplyViewController" bundle:[NSBundle mainBundle]];
    
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    stringForTitle=@"Inbox Detail Reply";
    replyVC.inboxDtlVC=self;
    replyVC.messageIdForReply=[inboxDetailsArray valueForKey:@"MessageId"];
//    replyVC.toUser=[[[inboxDetailsArray valueForKey:@"Replies"] lastObject]valueForKey:@"RepliedById"];
    replyVC.toUser=[[self.inboxDetailsArrayFromInbox objectAtIndex:0]valueForKey:@"FromUserId"];
    [self.navigationController pushViewController:replyVC animated:YES];
}

#pragma mark==Table View Datasource And Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.inboxDetailsArray valueForKey:@"Replies"] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    customCellDetailView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(customCellDetailView==nil)
    {
        customCellDetailView=[[[NSBundle mainBundle]loadNibNamed:@"DetailViewCustomCell" owner:self options:nil]objectAtIndex:0];
        customCellDetailView.showsReorderControl=YES;
    }
    customCellDetailView.selectionStyle=UITableViewCellSelectionStyleNone;
    
    //Set Image
    customCellDetailView.imageViewInReply.tag = indexPath.row;
    

    NSURL *url = [NSURL URLWithString:[[[[self.inboxDetailsArray valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ImageName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    if ([[NSString stringWithFormat:@"%@",url] hasSuffix:@"default.png"])
    {
        [customCellDetailView.imageViewInReply setHidden:true];
    }
    else
    {
        //[customCellDetailView.imageViewInReply setImageWithURL:url];
        UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
        tapped.numberOfTapsRequired = 1;
        [customCellDetailView.imageViewInReply addGestureRecognizer:tapped];
        [customCellDetailView.imageViewInReply setUserInteractionEnabled:YES];
    }
    
    customCellDetailView.dateInInboxDetail.text = [[[self.inboxDetailsArray valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ReplyDate"];
    
    NSString *str = [Parameters decodeDataForEmogies:[[[self.inboxDetailsArray valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ReplyMessage"]];
    if(![str isEqual:[NSNull null]])
    {
        [customCellDetailView.messageWebView loadHTMLString:str baseURL:nil];
    }
    
    customCellDetailView.messageWebView.tag = indexPath.row;
    customCellDetailView.messageWebView.scrollView.scrollEnabled  = NO;
    customCellDetailView.messageWebView.delegate = self;
    
    //From
     customCellDetailView.fromNameLabel.text =  [[[self.inboxDetailsArray valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"RepliedUserName"];
    //To
    customCellDetailView.toNameLabel.text = [[[self.inboxDetailsArray valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ReplyTo"];
    
    customCellDetailView.postingTitleLabel.text = [self.inboxDetailsArray  valueForKey:@"Title"];
    
    return customCellDetailView;
}
-(void)myFunction :(UITapGestureRecognizer *) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);
   
    opendImageURL =  [NSURL URLWithString:[[[[self.inboxDetailsArray valueForKey:@"Replies"] objectAtIndex:gesture.view.tag]valueForKey:@"ImageName"]
                                           stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    [self.imageViewFOrLargeImage setImageWithURL:opendImageURL];
    self.ViewforLargeImage.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
   
    timer=[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(touch1) userInfo:nil repeats:NO];
    
}

-(void)touch1
{
    [SVProgressHUD dismiss];
    [self.view addSubview:self.ViewforLargeImage];
    [timer invalidate];
}
-(IBAction)downloadPhotoToDevice:(id)sender
{
    
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.tintColor = [UIColor orangeColor];
    
    [indicator startAnimating];
    indicator.frame = CGRectMake(self.imageViewFOrLargeImage.frame.size.width/2-10, self.imageViewFOrLargeImage.frame.size.height/2-10, 30, 30);
    [self.imageViewFOrLargeImage addSubview:indicator];
    
    UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:opendImageURL]];
    UIImageWriteToSavedPhotosAlbum(img, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

-(void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo
{
    NSString*message;
    NSString*title;
    if(!error)
    {
        
        title=NSLocalizedString(@"",@"");
        // [SVProgressHUD dismiss];
        
        message=NSLocalizedString(@"Image has been saved to gallery",@"");
        [SVProgressHUD showSuccessWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
        }
    else
        {
            title=NSLocalizedString(@"SaveFailedTitle",@"");
            message=[error description];
            [SVProgressHUD showErrorWithStatus:message maskType:SVProgressHUDMaskTypeBlack];
            }
    [indicator stopAnimating];
    [self.ViewforLargeImage removeFromSuperview];
}

- (IBAction)cancelImagePreview:(id)sender
{
    [self.ViewforLargeImage removeFromSuperview];
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3)];
    headerView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1 ];
  // use your own design
    
    
    return headerView;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.ViewforLargeImage removeFromSuperview];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str=[[[self.inboxDetailsArray valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ReplyMessage"];
    str = [self convertHTML:str];
        return 140 + [[webviewHeights objectAtIndex:indexPath.row] floatValue];
}

-(NSString *) stringByStrippingHTML : (NSString *)html {
    NSRange r;
    while ((r = [html rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        html = [html stringByReplacingCharactersInRange:r withString:@""];
    return html;
}
-(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}
- (CGFloat) getTextHeight:(NSString*)str atFont:(UIFont*)font
{
    CGSize size = CGSizeMake(300, 9999);// here is some trick.
    UILabel *label;
    CGSize textSize = [str sizeWithFont:font constrainedToSize:size lineBreakMode:label.lineBreakMode];
    
    return textSize.height;
    
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    @try {
        
        
        
        CGRect frame = aWebView.frame;
        frame.size = [aWebView sizeThatFits:CGSizeZero];
       // frame.size.height += 20.0f;
        //aWebView.delegate = nil;
        DetailViewCustomCell *cell =(DetailViewCustomCell *)[inboxDetailTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:aWebView.tag inSection:0]];
        frame.origin.y=124;
        [cell setNeedsLayout];
        aWebView.alpha = 1.0f;
        [inboxDetailTable beginUpdates];
        frame.size.width=SCREEN_WIDTH - 10;
        aWebView.frame = frame;
        CGFloat webviewHeight =  frame.size.height;
        [webviewHeights replaceObjectAtIndex:aWebView.tag withObject:[NSString stringWithFormat:@"%f",webviewHeight]];
        [inboxDetailTable endUpdates];
    
    } @catch (NSException *ex)
    {
		
	}
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0;
}

//Table Footer

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    UIView *view =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    return tableFooter;
    return view;

}

-(void)tableFooterAdjustment
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    inboxDetailTable.tableFooterView = view;
}

#pragma mark== Cell Data Content View

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

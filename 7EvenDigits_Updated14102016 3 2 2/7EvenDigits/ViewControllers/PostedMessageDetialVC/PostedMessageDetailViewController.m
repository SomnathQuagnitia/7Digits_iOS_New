//
//  PostedMessageDetailViewController.m
//  7EvenDigits
//
//  Created by Krishna on 09/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "PostedMessageDetailViewController.h"
#import "ReplyViewController.h"
#import "Constant.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface PostedMessageDetailViewController ()

@end

@implementation PostedMessageDetailViewController
@synthesize postedMsgVc,messageId,postedDetailDict,titleMessageLabel,messageTextView,postedByLabel,dateLabel,postedDetailTable,imageViewProfile,postedDetailWebView,replyVC,postedById;
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
    self.title=@"Posted Message Detail";
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
//    postedDetailTable =[[UITableView alloc]initWithFrame:CGRectMake(0, 200, 320 ,220)];
//    postedDetailTable.dataSource = self;
//    postedDetailTable.delegate = self;
//    [self.view addSubview:postedDetailTable];
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 30.0f)];
    
    UIButton *btnAll = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAll setTitle:@"Reply" forState:UIControlStateNormal];
    [btnAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnAll setFrame:CGRectMake(15.0f, 0.0f, 60.0f, 30.0f)];
    [btnAll addTarget:self action:@selector(handelReply:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btnAll];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:customView];
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    [self tableFooterAdjustment];
    [postedDetailTable reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self callPostedmessageDetailWebService];
}

-(void)callPostedmessageDetailWebService
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
        
        [serviceIntegration InboxDetailsList:self UserId:CURRENT_USER_ID MessageId:messageId PostedById:postedById FromInbox:@"false" :@selector(receivedResponsePostedDetail:)];
    }
    
}
- (void)receivedResponsePostedDetail:(NSDictionary *)responseDict
{
     [SVProgressHUD dismiss];
    //NSLog(@"Resp%@",responseDict);
    postedDetailDict=[[NSMutableDictionary alloc]initWithDictionary:responseDict];
    [self setUpPostedDetailData];
    [postedDetailTable reloadData];
  
}
-(void)setUpPostedDetailData
{
    self.titleMessageLabel.text=[postedDetailDict valueForKey:@"Title"];
    self.postedByLabel.text=[postedDetailDict valueForKey:@"FromUser"];
    self.dateLabel.text=[postedDetailDict valueForKey:@"InboxDate"];
    //self.messageTextView.text=[postedDetailDict valueForKey:@"Message"];
    self.postedDetailMainWebView = [[UIWebView alloc]initWithFrame:CGRectMake(103, 103, 204, 50)];
    self.postedDetailMainWebView.backgroundColor = [UIColor whiteColor];
    [self.postedDetailMainWebView loadHTMLString:[Parameters decodeDataForEmogies:[postedDetailDict valueForKey:@"Message"]] baseURL:nil];
    NSURL *url = [NSURL URLWithString:[[postedDetailDict valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    self.postedDetailMainWebView.delegate = self;
    [self.view addSubview:self.postedDetailMainWebView];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imageViewProfile.image = [[UIImage alloc]initWithData:data];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunctionForProfile:)];
    tapped.numberOfTapsRequired = 1;
    [self.imageViewProfile setUserInteractionEnabled:true];
    [self.imageViewProfile addGestureRecognizer:tapped];
}
- (void)webViewDidFinishLoad:(UIWebView *)aWebView{
    @try {
        
        CGRect frame = aWebView.frame;
        frame.size = [aWebView sizeThatFits:CGSizeZero];
        // frame.size.height += 20.0f;
        //aWebView.delegate = nil;
        frame.origin.y=103;
        aWebView.alpha = 1.0f;
        frame.size.width=204;
        self.staticPostedByLabel.text = @"Posted By";
        if (frame.size.height > 400)
        {
            aWebView.frame = CGRectMake(103, 103, 204, SCREEN_HEIGHT-210);
            self.staticPostedByLabel.frame = CGRectMake(103,  SCREEN_HEIGHT-100, 62, 21);
            self.postedByLabel.frame = CGRectMake(167,  SCREEN_HEIGHT-100, 62, 21);
        }
        else
        {
        aWebView.frame = frame;
        self.staticPostedByLabel.frame = CGRectMake(103, 110+aWebView.frame.size.height, 62, 21);
        self.postedByLabel.frame = CGRectMake(167, 110+aWebView.frame.size.height, 62, 21);
        }
    }
    @catch (NSException *ex)
    {
        
    }
}

-(void)myFunctionForProfile:(UITapGestureRecognizer *) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);
    NSURL *url = [NSURL URLWithString:[[postedDetailDict valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.imageViewFOrLargeImage.image = [[UIImage alloc]initWithData:data];
    
    self.ViewforLargeImage.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:self.ViewforLargeImage];
}
- (IBAction)cancelImagePreview:(id)sender
{
    [self.ViewforLargeImage removeFromSuperview];
}
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)handelReply:(id)sender
{
    //replyViewControllerFlag=YES;
    
    ReplyViewController *replyVc=[[ReplyViewController alloc]initWithNibName:@"ReplyViewController" bundle:[NSBundle mainBundle]];
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    stringForTitle=@"Posted Message Detail";
    replyVc.postedDtlVC=self;
    replyVc.messageIdForReply=[postedDetailDict valueForKey:@"MessageId"];
    replyVc.toUser=[postedDetailDict valueForKey:@"FromUserId"];
    [self.navigationController pushViewController:replyVc animated:YES];
}

#pragma mark==Table View Datasource And Delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   // return [[postedDetailDict valueForKey:@"Replies"] count];
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    custonCellObj = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    customCell = nil;
    if(custonCellObj==nil)
    {
        custonCellObj=[[[NSBundle mainBundle]loadNibNamed:@"PostedMsgDetailCustomCell" owner:self options:nil]objectAtIndex:0];
     }
    custonCellObj.selectionStyle=UITableViewCellSelectionStyleNone;
    custonCellObj.imageViewInPostedDetail.tag=indexPath.row;
    NSURL *url = [NSURL URLWithString:[[[[postedDetailDict valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    
//    custonCellObj.imageViewInPostedDetail.image = [[UIImage alloc]initWithData:data];
//    
    
    [custonCellObj.imageViewInPostedDetail setImageWithURL:url];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myFunction:)];
    tapped.numberOfTapsRequired = 1;
    [custonCellObj.imageViewInPostedDetail addGestureRecognizer:tapped];
    [custonCellObj.imageViewInPostedDetail setUserInteractionEnabled:YES];
    
    
    
    
//    custonCellObj.imageViewInPostedDetail.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    custonCellObj.imageViewInPostedDetail.layer.borderWidth = 1.0;
//    [custonCellObj.imageViewInPostedDetail.layer setCornerRadius:0];
    
    custonCellObj.dateInPostedDetail.text = [[[postedDetailDict  valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ReplyDate"];
    

    replyVC.postedDtlVC=self;
    NSMutableString *str=[[[postedDetailDict valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ReplyMessage"];
    CGFloat rowHeight =[self getTextHeight:str atFont:[UIFont fontWithName:@"Helvetica" size:20]];
    UILabel *repliedByStaticLabel;
    UILabel *repliedByNameLabel;
    if(rowHeight < 70)
    {
        postedDetailWebView= [[UIWebView alloc]initWithFrame:CGRectMake(78, 20, 240, 60)];
        repliedByStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, 67, 82, 70)] ;
        repliedByNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(143,67, 142, 70)] ;
    }
    else
    {
        postedDetailWebView= [[UIWebView alloc]initWithFrame:CGRectMake(78, 20, 280, rowHeight-20)];
        repliedByStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(78, rowHeight - 2, 142, 21)] ;
        repliedByNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(143, rowHeight - 2, 142, 21)] ;
    }
    
    //CGFloat rowHeight=[[replyVC.dictionaryForReply valueForKey:@"Height"] floatValue];
    postedDetailWebView.userInteractionEnabled=YES;
    [postedDetailWebView setBackgroundColor:[UIColor whiteColor]];
    [custonCellObj.contentView addSubview:postedDetailWebView];
    
    //customCellDetailView.webViewForInboxDetailMessage.frame=CGRectMake(20, 2, 280,rowHeight);
    
    [postedDetailWebView loadHTMLString:[[[postedDetailDict valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ReplyMessage"] baseURL:nil];

    
   
    repliedByStaticLabel.text = @"Replied By: ";
    repliedByStaticLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    repliedByStaticLabel.textColor = [UIColor orangeColor];
    [custonCellObj.contentView addSubview:repliedByStaticLabel];
    
    
    repliedByNameLabel.text = [[[postedDetailDict  valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"RepliedUserName"];
    repliedByNameLabel.font = [UIFont fontWithName:@"Helvetica" size:13];
    [custonCellObj.contentView addSubview:repliedByNameLabel];

    return custonCellObj;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.ViewforLargeImage removeFromSuperview];
}
-(void)myFunction :(UITapGestureRecognizer *) sender
{
    UITapGestureRecognizer *gesture = (UITapGestureRecognizer *) sender;
    NSLog(@"Tag = %ld", (long)gesture.view.tag);
    NSURL *url = [NSURL URLWithString:[[[[postedDetailDict valueForKey:@"Replies"] objectAtIndex:gesture.view.tag]valueForKey:@"ImageName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    [self.imageViewFOrLargeImage setImageWithURL:url];
    self.ViewforLargeImage.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    [self.view addSubview:self.ViewforLargeImage];
}

-(void)tableFooterAdjustment
{
    //UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    tableViewObj.tableFooterView = tableFooter;
}
- (CGFloat) getTextHeight:(NSString*)str atFont:(UIFont*)font
{
    CGSize size = CGSizeMake(300, 9999);// here is some trick.
   // CGSize textSize = [str sizeWithFont:font constrainedToSize:size];
    CGRect textRect = [str boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    
    CGSize size1 = textRect.size;
    return size1.height;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3)];
    headerView.backgroundColor = [UIColor colorWithRed:223.0f/255.0f green:223.0f/255.0f blue:223.0f/255.0f alpha:1 ];
    // use your own design
    
    
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableString *str=[[[postedDetailDict valueForKey:@"Replies"] objectAtIndex:indexPath.row]valueForKey:@"ReplyMessage"];
    CGFloat height =[self getTextHeight:str atFont:[UIFont fontWithName:@"Helvetica" size:20]];
    
    if(height < 70)
    {
        return 120;
    }
    else
    {
        return height+25;
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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section   // custom view for footer. will be adjusted to default or specified footer height
{
    return tableFooter;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

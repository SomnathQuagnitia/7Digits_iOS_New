//
//  PreviewPostViewController.m
//  7EvenDigits
//
//  Created by Krishna on 04/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "PreviewPostViewController.h"
#import "Constant.h"
#import "ComposeViewController.h"
@interface PreviewPostViewController ()

@end

@implementation PreviewPostViewController
@synthesize textViewForPreviw,labelForTitle,composeVC,messageIdForEdit,fromPrevPost;
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
    self.title=@"Preview Post Screen";
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    
    //self.textViewForPreviw.text=[dictionaryForPreviiewPostData valueForKey:@"InnerTextForPrevPost"];
    //self.labelForTitle.text=[dictionaryForPreviiewPostData valueForKey:@"TitleText"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/YYYY"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    self.labelForDate.text=dateString;
    
    self.labelForTitle.text= self.composeVC.textfieldForTitle.text;
    
    self.imageInPreviePosting.image = self.composeVC.img.image;
    
    CGFloat heightOfTextView=[self textViewHeightForText:self.composeVC.messagePlianText andWidth:285];
    
    textViewForPrevPost=[[UITextView alloc]init];
    textViewForPrevPost.font=[UIFont fontWithName:@"" size:16];
    textViewForPrevPost.text=[Parameters decodeDataForEmogies:self.composeVC.messagePlianText];
    textViewForPrevPost.delegate=self;
    [self.view addSubview:textViewForPrevPost];
    
    postButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setImage: [UIImage imageNamed:@"post_small_btn.png"] forState:UIControlStateNormal];
    postButton.tag=2;
    [postButton addTarget:self action:@selector(handelPostAndSave:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:postButton];
    
    editButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage: [UIImage imageNamed:@"edit_small_btn.png"] forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(handelEdit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    saveButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage: [UIImage imageNamed:@"save_small_btn.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(handelPostAndSave:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.tag=1;
    [self.view addSubview:saveButton];
    
    if(heightOfTextView >=370)
    {
        textViewForPrevPost.frame=CGRectMake(79, 102, SCREEN_WIDTH-102, 260);
        postButton.frame=CGRectMake(82, 370, 47, 27);
        editButton.frame=CGRectMake(136, 370, 47, 27);
        saveButton.frame=CGRectMake(190, 370, 47, 27);
    }
    else
    {
        textViewForPrevPost.frame=CGRectMake(79, 102, SCREEN_WIDTH-102, heightOfTextView);
        postButton.frame=CGRectMake(82, 97+heightOfTextView+10, 47, 27);
        editButton.frame=CGRectMake(136, 97+heightOfTextView+10, 47, 27);
        saveButton.frame=CGRectMake(190, 97+heightOfTextView+10, 47, 27);
    }
}
-(void)handelPostAndSave :(UIButton *)sender
{
    
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
          [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        //NSString *messageIdForUpdateDraftInPost=[NSString stringWithFormat:@"%@",self.composeVC.messageIdForUpdateDraft];
        
        
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        self.composeVC.messagePlianText = [self replacePlainMessageAmpercentInString:self.composeVC.messagePlianText];

        if(![stringForTitle isEqualToString:@"DraftMessage"])
        {
            [serviceIntegration PostMessage:self UserId:CURRENT_USER_ID StateId:self.composeVC.stateId CityId:self.composeVC.cityId ZipCodeId:self.composeVC.zipCodeId Title:self.composeVC.textfieldForTitle.text Age:self.composeVC.textfieldForAge.text M2M:(self.composeVC.m2mBtn.selected ? @"true": @"false") M2W:(self.composeVC.m2wBtn.selected ? @"true": @"false") W2W:(self.composeVC.w2wBtn.selected ? @"true": @"false") W2M:(self.composeVC.w2mBtn.selected ? @"true": @"false") Everyone:(self.composeVC.everyOneBtn.selected ? @"true": @"false") LessThan30Days:(self.composeVC.radioBtnLessThanCompose.selected ? @"true": @"false") MessageHTML:self.composeVC.htmlMessageText Message:self.composeVC.messagePlianText IsDraft:(sender.tag - 1 ? @"false" : @"true") PostMessageId:@"0" ImageName:@"profile" Image:self.composeVC.img.image :@selector(receivedResponseDataForPostMessage:)];
            
        }
        else
        {
            [serviceIntegration PostMessage:self UserId:CURRENT_USER_ID StateId:self.composeVC.stateId CityId:self.composeVC.cityId ZipCodeId:self.composeVC.zipCodeId Title:self.composeVC.textfieldForTitle.text Age:self.composeVC.textfieldForAge.text M2M:(self.composeVC.m2mBtn.selected ? @"true": @"false") M2W:(self.composeVC.m2wBtn.selected ? @"true": @"false") W2W:(self.composeVC.w2wBtn.selected ? @"true": @"false") W2M:(self.composeVC.w2mBtn.selected ? @"true": @"false") Everyone:(self.composeVC.everyOneBtn.selected ? @"true": @"false") LessThan30Days:(self.composeVC.radioBtnLessThanCompose.selected ? @"true": @"false") MessageHTML:self.composeVC.htmlMessageText Message:self.composeVC.messagePlianText IsDraft:(sender.tag - 1 ? @"false" : @"true") PostMessageId:self.composeVC.messageIdForUpdateDraft ImageName:@"profile" Image:self.composeVC.img.image :@selector(receivedResponseDataForPostMessage:)];
            
            isMsgFromDraft=YES;
        }
    }
    self.composeVC.messageIdForUpdateDraft=@"";
    
}

- (NSString *)replacePlainMessageAmpercentInString:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    return str;
}
#pragma mark== Receive Response
- (void)receivedResponseDataForPostMessage:(NSMutableArray *)responseArray
{
    NSLog(@"Respons%@",responseArray);
    if([[responseArray valueForKey:@"success"]isEqualToString:@"true"])
    {
//             [self slideViewWithAnimation];
        NSString *string =[responseArray valueForKey:@"Message"];
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToTheBack) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
//        UIViewController* viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
//        if ([viewController isKindOfClass:[DraftViewController class]] )
//        {
//                        [Parameters popToViewControllerNamed:@"DraftViewController" from:parent];

//        }
//        else
//        {
//            draftVC=[[DraftViewController alloc]initWithNibName:@"DraftViewController" bundle:[NSBundle mainBundle]];
//            [self.navigationController pushViewController:draftVC animated:YES];
//        }
        
        //     [self.navigationController popViewControllerAnimated:YES];
        [self.composeVC clearComposeData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseArray valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];

    }
    isMsgFromDraft=NO;
}
-(void)moveToTheBack
{
    id parent=self;
    if(isMsgFromDraft)
    {
        isMsgFromDraft=NO;
        [Parameters popToViewControllerNamed:@"DraftViewController" from:parent];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (CGFloat)textViewHeightForText:(NSString *)text andWidth:(CGFloat)width
{
    UITextView *textView = [[UITextView alloc] init];
    [textView setText:text];
    CGSize size = [textView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handelEdit
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)handleSave
{
    [self.composeVC handelSave:saveButton];
}

//- (void)receivedResponseDataForPostMessage:(NSMutableArray *)responseArray
//{
//     [SVProgressHUD dismiss];
//
//    NSLog(@"Respons%@",responseArray);
//    if([[responseArray valueForKey:@"success"]isEqualToString:@"true"])
//    {
//    }
//    else
//    {
//    }
//}
@end

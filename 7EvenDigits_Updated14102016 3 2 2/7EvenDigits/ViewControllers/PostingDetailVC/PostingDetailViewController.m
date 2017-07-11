//
//  PostingDetailViewController.m
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "PostingDetailViewController.h"
#import "Constant.h"
@interface PostingDetailViewController ()

@end

@implementation PostingDetailViewController
@synthesize labelForStatus,labelForTitle,labelForDate,labelForId,labelForMessage,postingDetailArray;
@synthesize staticlabelPostedBy,staticlabelPostedDate,repostButton,deleteButton;
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
    
    self.title=@"Posting Detail";
    
    //    UIBarButtonItem *rightBarButton=[[UIBarButtonItem alloc]initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(handelHomeVC)];
    //    self.navigationItem.rightBarButtonItem=rightBarButton;
    
    labelForTitle.text=[postingDetailArray valueForKey:@"Title"];
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    
    CGFloat height =[self getTextHeight:[postingDetailArray valueForKey:@"PlainMessage"] atFont:[UIFont fontWithName:@"Helvetica" size:20]];
    
    
    if (height > 370)
    {
        //Message Frame
        labelForMessage.frame = CGRectMake(79, 100, 226 , SCREEN_HEIGHT-270);
        
        //PostedByFrame
        staticlabelPostedBy.frame = CGRectMake(85, SCREEN_HEIGHT-160, 119, 20);
        labelForId.frame = CGRectMake(152, SCREEN_HEIGHT-160, 119, 20);
        
        //DateFrame
        staticlabelPostedDate.frame = CGRectMake(85, SCREEN_HEIGHT-140, 119, 20);
        labelForDate.frame = CGRectMake(172, SCREEN_HEIGHT-140, 119, 20);
        
        //Buttons Frame
        labelForStatus.frame = CGRectMake(85, SCREEN_HEIGHT-120, 119, 20);
        repostButton.frame = CGRectMake(128, SCREEN_HEIGHT-120, 49, 20);
        deleteButton.frame = CGRectMake(172, SCREEN_HEIGHT-120, 49, 20);
    }
    else
    {
        if(SCREEN_HEIGHT < 490 && height > 250) //for iPhone 4s
        {
            height = 250;
            //Message Frame
            labelForMessage.frame = CGRectMake(79, 90, 226, height);
            
            //PostedByFrame
            staticlabelPostedBy.frame = CGRectMake(85, height+90, 119, 20);
            labelForId.frame = CGRectMake(152, height+90, 119, 20);
            
            //DateFrame
            staticlabelPostedDate.frame = CGRectMake(85, height+110, 119, 20);
            labelForDate.frame = CGRectMake(172, height+110, 119, 20);
            
            //Buttons Frame
            labelForStatus.frame = CGRectMake(85, height+130, 119, 20);
            repostButton.frame = CGRectMake(128, height+130, 49, 20);
            deleteButton.frame = CGRectMake(172, height+130, 49, 20);
        }
        else
        {
            //Message Frame
            labelForMessage.frame = CGRectMake(79, 90, 226, height);
            
            //PostedByFrame
            staticlabelPostedBy.frame = CGRectMake(85, height+90, 119, 20);
            labelForId.frame = CGRectMake(152, height+90, 119, 20);
            
            //DateFrame
            staticlabelPostedDate.frame = CGRectMake(85, height+110, 119, 20);
            labelForDate.frame = CGRectMake(172, height+110, 119, 20);
            
            //Buttons Frame
            labelForStatus.frame = CGRectMake(85, height+130, 119, 20);
            repostButton.frame = CGRectMake(128, height+130, 49, 20);
            deleteButton.frame = CGRectMake(172, height+130, 49, 20);
        }
    }
    
    
    
    
    labelForMessage.text=[Parameters decodeDataForEmogies:[postingDetailArray valueForKey:@"PlainMessage"]];
    labelForId.text=[postingDetailArray valueForKey:@"UserName"];
    labelForDate.text=[postingDetailArray valueForKey:@"PostedDate"];
    
    NSURL *url = [NSURL URLWithString:[[postingDetailArray valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.userImage.image = [[UIImage alloc]initWithData:data];
    
    
    if([[postingDetailArray valueForKey:@"Active"]isEqualToString:@"Active"])
    {
        labelForStatus.textColor=[UIColor colorWithRed:103.0f/255.0f green:160.0f/255.0f blue:17.0f/255.0f alpha:1 ];
        labelForStatus.text=@"Active";
    }
    else
    {
        labelForStatus.textColor=[UIColor redColor];
        labelForStatus.text=@"Expired";
    }
}
- (CGFloat) getTextHeight:(NSString*)str atFont:(UIFont*)font
{
    CGSize size = CGSizeMake(300, 9999);// here is some trick.
    //CGSize textSize = [str sizeWithFont:font constrainedToSize:size];
    CGRect textRect = [str boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    
    CGSize size1 = textRect.size;
    return size1.height;
}
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)handelHomeVC
{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handelDelete:(id)sender
{
    [self deleteAlert];
}
-(void)deleteAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to delete this message?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self handelOkAction];
                                   }];
        [alertVC addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
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
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to delete this message?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==0)
//    {
//        [self handelOkAction];
//    }
//    
//}
-(void)handelOkAction
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
        
        [serviceIntegration DeletePostingMessage:self MessageId:[postingDetailArray valueForKey:@"MessageId"] :@selector(receivedResponseDataPostingDetail:)];
    }
}
- (IBAction)handelRepost:(id)sender
{
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        if([[postingDetailArray valueForKey:@"Active"]isEqualToString:@"Active"])
        {
            [SVProgressHUD showErrorWithStatus:@"Active message cannot be reposted again." maskType:SVProgressHUDMaskTypeBlack];
        }
        else
        {
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
            
            if (serviceIntegration != nil)
            {
                serviceIntegration = nil;
            }
            serviceIntegration = [[ServerIntegration alloc]init];
            
            [serviceIntegration RepostMessage:self MessageId:[postingDetailArray valueForKey:@"MessageId"] :@selector(receivedResponseDataPostingDetail:)];
        }
    }
}

- (void)receivedResponseDataPostingDetail:(NSDictionary *)responseDict
{
    //NSLog(@"%@",responseDict);
    [SVProgressHUD dismiss];
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        NSString *string =[responseDict valueForKey:@"Message"];
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToTheBack) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)moveToTheBack
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

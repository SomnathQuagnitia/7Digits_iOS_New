//
//  AdvanceSearchViewController.m
//  7EvenDigits
//
//  Created by Krishna on 01/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import "AdvanceSearchViewController.h"
#import "PostedMessageViewController.h"
@interface AdvanceSearchViewController ()

@end

@implementation AdvanceSearchViewController
@synthesize radioBtnLessThan,radioButtonMoreThan;
@synthesize textfieldForZip,textfieldForTitle,textfieldForState,textfieldForCity,stateId,postedMessagesFormAdvanceSearch,postedmsgVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"Advance Search";
    
    self.stateId=@"0";
    self.cityId=@"0";
    self.zipCodeId=@"0";
    
    [self.cancelStateBtn setHidden:YES];
    [self.cancelCityBtn setHidden:YES];
    [self.cancelZipBtn setHidden:YES];

    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    
    [Parameters addPaddingView:textfieldForCity];
    [Parameters addPaddingView:textfieldForState];
    [Parameters addPaddingView:textfieldForZip];
    [Parameters addPaddingView:textfieldForTitle];
    
    [_scrollViewObj setContentSize:CGSizeMake(0, 600)];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    if (self.textfieldForState.text.length>0)
    {
        [self.cancelStateBtn setHidden:NO];
    }
    else
    {
        [self.cancelStateBtn setHidden:YES];
    }
    if (self.textfieldForCity.text.length>0)
    {
        [self.cancelCityBtn setHidden:NO];
    }
    else
    {
        [self.cancelCityBtn setHidden:YES];
    }
    if (self.textfieldForZip.text.length>0)
    {
        [self.cancelZipBtn setHidden:NO];
    }
    else
    {
        [self.cancelZipBtn setHidden:YES];
    }
    
}

- (IBAction)handleCancel:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    if (btn.tag==500)
    {
        self.textfieldForState.text=@"";
        self.stateId=@"0";
        [self.cancelStateBtn setHidden:YES];
    }
    if (btn.tag==600)
    {
        self.textfieldForCity.text=@"";
        self.cityId=@"0";
        [self.cancelCityBtn setHidden:YES];
    }
    if (btn.tag==700)
    {
        self.textfieldForZip.text=@"";
        self.zipCodeId=@"0";
        [self.cancelZipBtn setHidden:YES];
    }
    
}


-(IBAction)handelStateList:(UIButton *)sender
{
    searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    searchVC.advanvedSearchVC=self;
    searchVC.title=@"State";
    
    [self.navigationController pushViewController:searchVC animated:YES];
    
}
-(IBAction)handelCityList:(UIButton *)sender
{
        searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
        searchVC.advanvedSearchVC=self;
        searchVC.title=@"City";
        [self.navigationController pushViewController:searchVC animated:YES];
}
-(IBAction)handelZipList:(UIButton *)sender
{
    searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    searchVC.advanvedSearchVC=self;
    searchVC.title=@"Zip Code";
    [self.navigationController pushViewController:searchVC animated:YES];
}

-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)handelAdvancedSearchGo:(id)sender
{
    [self callPostedMessageWebService];
}
#pragma mark==Handel Check box Operatios
-(IBAction)handelCheckBoxM2M:(UIButton *)sender
{
    //sender.selected = !sender.isSelected;
    [self.m2mBtn setSelected:NO];
    [self.m2wBtn setSelected:NO];
    [self.w2mBtn setSelected:NO];
    [self.w2wBtn setSelected:NO];
    [self.everyOneBtn setSelected:NO];
    [sender setSelected:YES];
}
-(IBAction)handelRadioButtonLessThanSearch:(UIButton *)sender;
{
    [radioBtnLessThan setSelected:NO];
    [radioButtonMoreThan setSelected:NO];
    [sender setSelected:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    currentTxtFld=textField;
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)callPostedMessageWebService
{
    
    if (lessThan30String != nil)
    {
        lessThan30String = nil;
    }
    
    if ([(self.radioBtnLessThan.selected ? @"true": @"false") isEqualToString:@"true"])
    {
        lessThan30String = @"1";
    }
    else if ([(self.radioButtonMoreThan.selected ? @"true": @"false") isEqualToString:@"true"])
    {
        lessThan30String = @"2";
    }
    else
    {
        lessThan30String = @"0";
    }
    
    
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
        
        //  http://115.113.151.198/socialmedia/api/register/PostedMessageList?keyword=Test&stateId=0&cityid=0&ZipCodeId=0&M2M=false&M2W=false&W2W=false&Everyone=false&LessThan30Days=false
        
        [serviceIntegration PostedMessageList:self UserId:CURRENT_USER_ID KeyWord:textfieldForTitle.text StateId:self.stateId CityId:self.cityId ZipCodeId:self.zipCodeId M2M:(self.m2mBtn.selected ? @"true": @"false") M2W:(self.m2wBtn.selected ? @"true": @"false") W2W:(self.w2wBtn.selected ? @"true": @"false") W2M:(self.w2mBtn.selected ? @"true": @"false") Everyone:(self.everyOneBtn.selected ? @"true": @"false") LessThan30Days:lessThan30String :@selector(receivedResponseDataForPostedMessage:)];
    }
}
#pragma mark== Receive Response
- (void)receivedResponseDataForPostedMessage:(NSMutableArray *)responseArray
{
    
    //NSLog(@"Respons%@",responseArray);
    
    if (responseArray.count>0)
    {
        [SVProgressHUD dismiss];
        self.postedmsgVC=[[PostedMessageViewController alloc]initWithNibName:@"PostedMessageViewController" bundle:[NSBundle mainBundle]];
        self.postedmsgVC.advanceSearchViewController=self;
        self.postedmsgVC.postedMessageArray=[[NSMutableArray alloc]initWithArray:responseArray];
        [self.navigationController pushViewController:self.postedmsgVC animated:YES];
    }
    else if(responseArray.count== 0)
    {
        [SVProgressHUD showErrorWithStatus:@"No record found" maskType:SVProgressHUDMaskTypeBlack];
    }
}

- (IBAction)handelCancelButton:(id)sender
{
    textfieldForTitle.text=@"";
    self.textfieldForState.text=@"";
    [self.cancelStateBtn setHidden:YES];
    self.textfieldForCity.text=@"";
    [self.cancelCityBtn setHidden:YES];
    self.textfieldForZip.text=@"";
    [self.cancelZipBtn setHidden:YES];
    
    self.stateId=@"0";
    self.cityId=@"0";
    self.zipCodeId=@"0";
    
    [self.m2mBtn setSelected:NO];
    [self.m2wBtn setSelected:NO];
    [self.w2mBtn setSelected:NO];
    [self.w2wBtn setSelected:NO];
    [self.everyOneBtn setSelected:NO];
    
    [radioBtnLessThan setSelected:NO];
    [radioButtonMoreThan setSelected:NO];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTxtFld=textField;
    return YES;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [currentTxtFld resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
@end

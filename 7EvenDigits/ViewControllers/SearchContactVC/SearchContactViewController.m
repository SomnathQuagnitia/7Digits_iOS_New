//
//  SearchContactViewController.m
//  7EvenDigits
//
//  Created by Tanvi on 9/14/16.
//  Copyright © 2016 Quagnitia Systems. All rights reserved.
//

#import "SearchContactViewController.h"
#import "ContactViewController.h"
#import "SearchViewController.h"
#import "SearchGoViewController.h"
#import "Parameters.h"

@interface SearchContactViewController ()
{
    NSString *FirstNameString;
    NSString *LastNameString;
    NSString *titleString;
    NSString *stateString;
    NSString *cityString;
    NSString *companyString;
}
@end

@implementation SearchContactViewController
@synthesize textfieldForCity, textfieldForState, textfieldForTitle, textfieldForCompany, textfieldForLastName, textfieldForFirstName,cancelCityBtn, cancelStateBtn, ContactVC, stateId, cityId,searchContactDataDict,searchPersonalBtn,searchProfessionalBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchPersonalBtn.tag = 1;
    searchProfessionalBtn.tag = 0;
    self.title=@"Search Profile";
    self.stateId=@"0";
    self.cityId=@"0";
    status = @"true";

    [self.cancelStateBtn setHidden:YES];
    [self.cancelCityBtn setHidden:YES];

    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    
    [Parameters addPaddingView:textfieldForCity];
    [Parameters addPaddingView:textfieldForState];
    [Parameters addPaddingView:textfieldForCompany];
    [Parameters addPaddingView:textfieldForLastName];
    [Parameters addPaddingView:textfieldForFirstName];
    [Parameters addPaddingView:textfieldForTitle];
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
}

#pragma mark == HideTextFieldPersonalProfile
-(void)hideTextFieldForPersonal
{
    
        [textfieldForCompany setAlpha:0.2f];
        [textfieldForCity setAlpha:0.2f];
        [textfieldForState setAlpha:0.2f];
        [textfieldForTitle setAlpha:0.2f];
        
        [textfieldForTitle setEnabled:YES];
        [textfieldForState setEnabled:YES];
        [textfieldForCity setEnabled:YES];
        [textfieldForCompany setEnabled:YES];
}

- (IBAction)handleCancel:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    if (btn.tag==500)
    {
        self.textfieldForState.text=@"";
        self.stateId=@"";
        [self.cancelStateBtn setHidden:YES];
    }
    if (btn.tag==600)
    {
        self.textfieldForCity.text=@"";
        self.cityId=@"";
        [self.cancelCityBtn setHidden:YES];
    }
}
-(IBAction)handelStateList:(UIButton *)sender
{
    if(searchVC.CheckStateStatus == true)
    {
        [self.textfieldForState isEditing];
        [self.textfieldForState becomeFirstResponder];
    }
    else
    {
        searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
        searchVC.searchContactVC=self;
        searchVC.title = @"State";
        [self.navigationController pushViewController:searchVC animated:YES];
    }
}
-(IBAction)handelCityList:(UIButton *)sender
{
    if(searchVC.CheckCityStatus == true)
    {
        [self.textfieldForCity isEditing];
        [self.textfieldForCity becomeFirstResponder];
    }
    else
    {
        searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
        searchVC.searchContactVC=self;
        searchVC.title = @"City";
        //[searchVC.serachTableView reloadData];
        [self.navigationController pushViewController:searchVC animated:YES];
    }

}

#pragma mark == Check Profile Button

- (IBAction)searchPersonalBtn:(UIButton *)sender
{
    if(searchPersonalBtn.tag == 1)
    {
        searchPersonalBtn.tag = 0;
        status = @"true";
        
        [searchPersonalBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
    }
    else
    {
        searchPersonalBtn.tag = 1;
        [searchPersonalBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
        
    }
    searchProfessionalBtn.tag=1;
    [searchProfessionalBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
}

- (IBAction)searchProfessionalBtn:(UIButton *)sender
{
    if(searchProfessionalBtn.tag == 0)
    {
        searchProfessionalBtn.tag = 1;
        [searchProfessionalBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
    }
    else
    {
        searchProfessionalBtn.tag = 0;
        [searchProfessionalBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
        status = @"false";
    }
    searchPersonalBtn.tag=1;
    [searchPersonalBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
}

- (IBAction)handelCancelButton:(id)sender
{
    textfieldForFirstName.text=@"";
    textfieldForLastName.text=@"";
    textfieldForCompany.text=@"";
    textfieldForTitle.text=@"";
    self.textfieldForState.text=@"";
    [self.cancelStateBtn setHidden:YES];
    self.textfieldForCity.text=@"";
    [self.cancelCityBtn setHidden:YES];
    self.stateId=@"0";
    self.cityId=@"0";
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark == Handle Go button web Service

-(void)handelGoButton:(id)sender
{
    [currentTxtFld resignFirstResponder];
    [self callViewSearchContactResult];
}

-(void)TrimeRemoveString
{
   FirstNameString = [textfieldForFirstName.text stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceCharacterSet]];
    
    LastNameString = [textfieldForLastName.text stringByTrimmingCharactersInSet:
                                [NSCharacterSet whitespaceCharacterSet]];
    
    companyString = [textfieldForCompany.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    titleString = [textfieldForTitle.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
    stateString = [textfieldForState.text stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceCharacterSet]];
    
   cityString = [textfieldForCity.text stringByTrimmingCharactersInSet:
                            [NSCharacterSet whitespaceCharacterSet]];
}
-(void)callViewSearchContactResult
{
    [self TrimeRemoveString];
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
        if(appDeleagated.iOSDeviceToken.length>0 )
        {
            [serviceIntegration SearchUser:self firstname:FirstNameString lastname:LastNameString Company:companyString Title:titleString State:stateString city:cityString IsProfileType:status :@selector(recivedResposeSearchUserData:)];
        }
        else
        {
            [serviceIntegration SearchUser:self firstname:textfieldForFirstName.text lastname:textfieldForLastName.text Company:textfieldForCompany.text Title:textfieldForTitle.text State:textfieldForState.text city:textfieldForCity.text IsProfileType:status :@selector(recivedResposeSearchUserData:)];
        }
    }
}

#pragma mark == ServerIntegration Delegate

- (void)recivedResposeSearchUserData:(NSDictionary *)responseDict
{
       if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
       {
           searchGoVC = [[SearchGoViewController alloc]initWithNibName:@"SearchGoViewController" bundle:nil];
           searchGoVC.searchDataArray = [[NSMutableArray alloc] init];
           NSLog(@"Count : %ld",(long)[[responseDict valueForKey:@"filterList"] count]);
           if(([[responseDict valueForKey:@"filterList"] count] == 0) & ([[responseDict valueForKey:@"UserPersonalList"] count] == 0) & ([[responseDict valueForKey:@"UserProfessionalList"] count] == 0))
           {
                [SVProgressHUD showErrorWithStatus:@"Search Result not found." maskType:SVProgressHUDMaskTypeBlack];
           }
           else
           {
               [searchGoVC.searchDataArray addObject:responseDict];
               [self.navigationController pushViewController:searchGoVC animated:YES];
           }
      }
      else
      {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"msg"] maskType:SVProgressHUDMaskTypeBlack];
      }
}


#pragma mark == Text Field Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    currentTxtFld=textField;
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTxtFld=textField;
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTxtFld = textField;
    [Parameters moveTextFieldUpForView:self.view forTextField:textField forSubView:self.view];
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [Parameters moveTextFieldDownforView:self.view];
    return YES;
}

@end

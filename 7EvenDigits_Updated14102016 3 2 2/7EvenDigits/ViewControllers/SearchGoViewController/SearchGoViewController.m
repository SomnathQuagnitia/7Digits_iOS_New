//
//  SearchGoViewController.m
//  7EvenDigits
//
//  Created by nikhil on 9/15/16.
//  Copyright © 2016 Quagnitia Systems. All rights reserved.
//

#import "SearchGoViewController.h"
#import "SearchTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewProfessionalProfileVC.h"
#import "ContactProfileViewController.h"

@interface SearchGoViewController ()
{

    NSString *OccupationString;
    NSString *ImgStr;
    NSString *username;
    NSString *city;
    NSString  *state;
    NSString *company;
    int sendProfileType1;
    NSString *sendUserID;
    int profileType;
    NSInteger i;
    SearchTableViewCell *cell;
    NSMutableString *firstName,*lastName;
}
@end

@implementation SearchGoViewController
@synthesize PopView,UserIdLbl,NameLbl,PopUpImgView,MsgTxtView,sendBtnClick,searchDataArray,profileTypeRequest,profileDataArray,imgUrlStr,checkImgUrl,countLbl, typeOfRequest;

-(void)viewWillAppear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    NSLog(@"New Dict is : %@",searchDataArray);
    
    profileType = [[[searchDataArray objectAtIndex:0] valueForKey:@"IsProfileType"] intValue];
    NSLog(@"Whole count : %ld",(long)searchDataArray.count);
    NSLog(@"Filter list count : %ld",(long)[[[searchDataArray objectAtIndex:0] valueForKey:@"filterList"] count]);
    NSLog(@"Personal list count : %ld",(long)[[[searchDataArray objectAtIndex:0] valueForKey:@"UserPersonalList"]count]);
    NSLog(@"Professional list count : %ld",(long)[[[searchDataArray objectAtIndex:0] valueForKey:@"UserProfessionalList"]count]);
    
    if(profileType == 1)
    {
        if(([[[searchDataArray objectAtIndex:0] valueForKey:@"filterList"] count] == 0 ) & ([[[searchDataArray objectAtIndex:0] valueForKey:@"UserPersonalList"] count] == 0))
        {
            profileDataArray = [[NSMutableArray alloc] initWithArray:[[searchDataArray objectAtIndex:0] valueForKey:@"UserProfessionalList"]];
            NSLog(@"Only Professional list : %@",profileDataArray);
        }
        else
        {
            if(([[[searchDataArray objectAtIndex:0] valueForKey:@"filterList"] count] == 0) & ([[[searchDataArray objectAtIndex:0] valueForKey:@"UserProfessionalList"] count] == 0))
            {
                profileDataArray = [[NSMutableArray alloc] initWithArray:[[searchDataArray objectAtIndex:0] valueForKey:@"UserPersonalList"]];
            }
            else
            {
                profileDataArray = [[NSMutableArray alloc] initWithArray:[[searchDataArray objectAtIndex:0] valueForKey:@"filterList"]];
                for(NSMutableDictionary *profileDict in [[searchDataArray objectAtIndex:0] valueForKey:@"UserPersonalList"])
                {
                    username = [profileDict valueForKey:@"UserName"];
                    BOOL sameUserName = NO;
                    NSMutableDictionary *dict;
                    for(int j = 0;j<[profileDataArray count];j++)
                    {
                            if(![username isEqualToString:[[profileDataArray objectAtIndex:j]  valueForKey:@"UserName"]])
                            {
                                sameUserName = NO;
                                dict = profileDict;
                            }
                            else
                            {
                                sameUserName = YES;
                                break;
                            }
                    }
                    if (sameUserName == NO)
                    {
                        [profileDataArray addObject:dict];
                    }
                }
            }
        }
    }
    else if (profileType == 0)
    {
        NSLog(@"%lu",(long)[[[searchDataArray objectAtIndex:0] valueForKey:@"UserProfessionalList"] count]);
        if([[[searchDataArray objectAtIndex:0] valueForKey:@"UserProfessionalList"] count] == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"Search result not found" maskType:SVProgressHUDMaskTypeBlack];
        }
        else
        {
            if([[[searchDataArray objectAtIndex:0] valueForKey:@"filterList"] count] == 0)
            {
                profileDataArray = [[NSMutableArray alloc] initWithArray:[[searchDataArray objectAtIndex:0] valueForKey:@"UserProfessionalList"]];
                NSLog(@"Only Professionl list : %@",profileDataArray);
            }
            else
            {
                profileDataArray = [[NSMutableArray alloc] initWithArray:[[searchDataArray objectAtIndex:0] valueForKey:@"filterList"]];
                for(NSMutableDictionary *profileDict in [[searchDataArray objectAtIndex:0] valueForKey:@"UserProfessionalList"])
                {
                    username = [profileDict valueForKey:@"UserName"];
                    BOOL sameUserName = NO;
                    NSMutableDictionary *dict;
                    for(int j = 0;j<[profileDataArray count];j++)
                    {
                        if(![username isEqualToString:[[profileDataArray objectAtIndex:j]  valueForKey:@"UserName"]])
                        {
                            sameUserName = NO;
                            dict = profileDict;
                        }
                        else
                        {
                            sameUserName = YES;
                            break;
                        }
                    }
                    if (sameUserName == NO)
                    {
                        [profileDataArray addObject:dict];
                    }
                }
            }
        }
    }
    NSLog(@"Final Array : %@",profileDataArray);
    NSString *recordCount = [NSString stringWithFormat:@"%lu",(unsigned long)[profileDataArray count]];
    countLbl.text = recordCount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setToolbarToPhoneNumber];
    
    self.navigationItem.title = @"Contact Results";
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    
    MsgTxtView.text = @"Message";
    MsgTxtView.textColor = [UIColor blackColor];
    
    [Parameters addBorderToView:PopView];
    [Parameters addBorderToView:sendBtnClick];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendBtnClick:(UIButton *)sender
{
    tableview.alpha = 1.0;
    sendUserID =  [NSString stringWithFormat:@"%@",[[profileDataArray objectAtIndex:i] valueForKey:@"UserId"]];
    if(![CURRENT_USER_ID isEqualToString:sendUserID])
    {
        [self callSendProfileWebService:sendUserID];
        [PopView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"You cannot send profile to yourself" maskType:SVProgressHUDMaskTypeBlack];
        [PopView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


-(void)callSendProfileWebService :(NSString *)reciverUserId
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
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
        if([userDef integerForKey:@"one"] == 1)
        {
            typeOfRequest=@"1";
            [serviceIntegration SendUserProfile:self userId:CURRENT_USER_ID reciverUserId:reciverUserId profileId:@"1" Message:MsgTxtView.text.length > 0 ? MsgTxtView.text : @"" isRequest:@"true" :@selector(receivedResponseSendProfProfileInCont:)];
        }
        else
        {
            typeOfRequest=@"1";
            [serviceIntegration SendUserProfile:self userId:CURRENT_USER_ID reciverUserId:reciverUserId profileId:@"2" Message:MsgTxtView.text.length > 0 ? MsgTxtView.text : @"" isRequest:@"true" :@selector(receivedResponseSendProfProfileInCont:)];
        }
        [userDef synchronize];
      }
}



- (void)receivedResponseSendProfProfileInCont:(NSArray *)responseDict
{
    NSLog(@"Response dict : %@",responseDict);
    if([[responseDict valueForKey:@"msg"]isEqualToString:@"SUCCESS"] || [[responseDict valueForKey:@"msg"]isEqualToString:@"OVERRIED"])
    {
        if([typeOfRequest isEqualToString:@"0"])
        {
           [SVProgressHUD showSuccessWithStatus: @"Profile has been sent successfully." maskType:SVProgressHUDMaskTypeBlack];
        }
        else
        {
           [SVProgressHUD showSuccessWithStatus: @"Request has been sent successfully." maskType:SVProgressHUDMaskTypeBlack];
        }
    }
    else
    {
        [SVProgressHUD dismiss];
    }
}

- (IBAction)CancelPopUp:(id)sender
{
    tableview.scrollEnabled = YES;
    tableview.alpha = 1.0;
    PopView.center = self.view.center;
    [PopView setAlpha:0.0];
    [UIView beginAnimations:nil context:nil];
    [PopView setAlpha:1.0];
    [PopView removeFromSuperview];
    [UIView commitAnimations];
    [self textViewDidChange:currentTxtView];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma  mark == TableView and datasource delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [profileDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView_in cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"reuseID";
    cell =[tableView_in dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:@"SearchTableViewCell" owner:0 options:nil];
         cell=[nib objectAtIndex:0];
    }
    
    if(profileType == 1)
    {
        //set first name and last name for personal
        NSLog(@"username : %@",[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"UserName"]);
        firstName = [[NSMutableString alloc] initWithString:[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"PersonalFirstName"]];
         NSLog(@"first name : %@",firstName);
                
        lastName = [[NSMutableString alloc] initWithString:[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"PersonalLastName"]];
        
        if([firstName isEqualToString:@""] && [lastName isEqualToString:@""])
        {
            NSString *professionalFirstName = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalFirstName"];
            NSString *professionalLastName = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalLastName"];
            if([professionalFirstName isEqualToString:@""] && [professionalLastName isEqualToString:@""])
            {
                cell.LastName.text = @"Not Mentioned";
            }
            else
            {
                cell.LastName.text = [NSString stringWithFormat:@"%@ %@",professionalLastName,professionalFirstName];
            }
        }
        else
        {
            [lastName appendFormat:@" %@", firstName];
            cell.LastName.text = lastName;
            NSLog(@"last name : %@",lastName);
        }
        
        username = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"UserName"];
        NSLog(@"user name : %@",username);
                
        OccupationString = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"UserTitle"];
        NSLog(@"%@",OccupationString);
                
        state = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalState"];
        NSLog(@"%@",state);
                
        city = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalCity"];
        NSLog(@"%@",city);
                
        company = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"UserCompany"];
        NSLog(@"%@",company);
        
        int checkstatusProfessional = [[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"IsPublicProfessional"] intValue];
        
        int checkstatusPersonal = [[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"IsPublicPersonal"] intValue];
        NSLog(@"Status is %ld",(long)checkstatusPersonal);
        NSLog(@"Status is %ld",(long)checkstatusProfessional);
        
        cell.UserIdLbl.text = username;
        
        if([OccupationString isEqualToString:@""])
        {
            cell.occupationLbl.text = @"Not Mentioned";

        }
        else
        {
            cell.occupationLbl.text = OccupationString;
            [cell.titleScrollView setContentSize:CGSizeMake(cell.occupationLbl.frame.size.width, 0)];
            if(OccupationString.length > 20)
            {
                cell.titleScrollView.userInteractionEnabled = YES;
            }
            else
            {
                cell.titleScrollView.userInteractionEnabled = NO;
            }
        }
        
        if([state isEqualToString:@""])
        {
            cell.stateLbl.text = @"Not Mentioned";
        }
        else
        {
            cell.stateLbl.text = state;
        }
                
        if([city isEqualToString:@""])
        {
            cell.cityLbl.text = @"Not Mentioned";
        }
        else
        {
            cell.cityLbl.text = city;
        }
                
        if([company isEqualToString:@""])
        {
            cell.compnayNameLbl.text = @"Not Mentioned";
        }
        else
        {
            cell.compnayNameLbl.text =company;
            [cell.companyScrollView setContentSize:CGSizeMake(cell.compnayNameLbl.frame.size.width, 0)];
            if(company.length > 10)
            {
                cell.companyScrollView.userInteractionEnabled = YES;
            }
            else
            {
                cell.companyScrollView.userInteractionEnabled = NO;
            }
        }
                
        //set personal image
        NSURL *url = [NSURL URLWithString:[[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"PersonalProfileImageName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        NSString *str;
        if([[NSString stringWithFormat:@"%@",url] isEqualToString:@"http://www.7evenDigits.com/content/Profile/"])
        {
            
            str = [NSString stringWithFormat:@"%@noimage.png",[NSString stringWithFormat:@"%@",url]];
        }
        
        if ([[NSString stringWithFormat:@"%@",url] hasSuffix:@"default_Contact.png"] || [[NSString stringWithFormat:@"%@",url] hasSuffix:@"noimage.png"] || [[NSString stringWithFormat:@"%@",url] isEqualToString:@""] || [str hasSuffix:@"noimage.png"])
        {
            cell.personalImgView.image = [UIImage imageNamed:@"icon_with_oborder.png"];
        }
        else
        {
            [cell.personalImgView hnk_setImageFromURL:url];
        }
        
        //set professional img
        NSURL *url1 = [NSURL URLWithString:[[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalProfileImageName"]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        if([[NSString stringWithFormat:@"%@",url1] isEqualToString:@"http://www.7evenDigits.com/content/Profile/"])
        {
            str = [NSString stringWithFormat:@"%@noimage.png",[NSString stringWithFormat:@"%@",url1]];
        }
        
        if ([[NSString stringWithFormat:@"%@",url1] hasSuffix:@"default_Contact.png"] || [[NSString stringWithFormat:@"%@",url1] hasSuffix:@"noimage.png"] || [[NSString stringWithFormat:@"%@",url1] isEqualToString:@""] || [str hasSuffix:@"noimage.png"])
        {
            cell.professionalImgView.image = [UIImage imageNamed:@"icon_with_oborder.png"];
        }
        else
        {
            [cell.professionalImgView hnk_setImageFromURL:url1];
        }

        
        //check professional status
        if(checkstatusProfessional == 1)
        {
            cell.professionalImgView.alpha = 1.0f;
        }
        else
        {
            cell.professionalImgView.alpha = 0.1f;
        }
        
        //check personal status
        if(checkstatusPersonal == 1)
        {
            cell.personalImgView.alpha = 1.0f;
        }
        else
        {
            cell.personalImgView.alpha = 0.1f;
        }
    }
    else if(profileType == 0)
    {
        //set professional data
        
        NSLog(@"%@",[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalFirstName"]);
            firstName = [[NSMutableString alloc] initWithString:[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalFirstName"]];
        NSLog(@"First name %@",firstName);

       lastName = [[NSMutableString alloc] initWithString:[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalLastName"]];
        
        if([firstName isEqualToString:@""] && [lastName isEqualToString:@""])
        {
            NSString *personalFirstName = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"PersonalFirstName"];
            NSString *personalLastName = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"PersonalLastName"];
            if([personalFirstName isEqualToString:@""] && [personalLastName isEqualToString:@""])
            {
                cell.LastName.text = @"Not Mentioned";
            }
            else
            {
                cell.LastName.text = [NSString stringWithFormat:@"%@ %@",personalLastName,personalFirstName];
            }
        }
        else
        {
            [lastName appendFormat:@" %@", firstName];
            cell.LastName.text = lastName;
            NSLog(@"last name : %@",lastName);
        }

        username = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"UserName"];
        NSLog(@"%@",username);
        
        OccupationString = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"UserTitle"];
        NSLog(@"%@",OccupationString);
        
        state = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalState"];
        NSLog(@"%@",state);

        city = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalCity"];
        NSLog(@"%@",city);

        company = [[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"UserCompany"];
        NSLog(@"%@",company);
        
        int checkstatusProfessional = [[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"IsPublicProfessional"] intValue];
        
        int checkstatusPersonal = [[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"IsPublicPersonal"] intValue];
        NSLog(@"Status is %ld",(long)checkstatusPersonal);
        NSLog(@"Status is %ld",(long)checkstatusProfessional);
        
        if([lastName isEqualToString:@""])
        {
            cell.LastName.text = @"Unknown";
        }
        else
        {
            cell.LastName.text = lastName;
        }

        cell.UserIdLbl.text = username;
        
        if([OccupationString isEqualToString:@""])
        {
            cell.occupationLbl.text = @"Not Mentioned";
        }
        else
        {
            cell.occupationLbl.text = OccupationString;
            [cell.titleScrollView setContentSize:CGSizeMake(cell.occupationLbl.frame.size.width, 0)];
            if(OccupationString.length > 10)
            {
                cell.titleScrollView.userInteractionEnabled = YES;
            }
            else
            {
                cell.titleScrollView.userInteractionEnabled = NO;
            }
        }
        
        if([state isEqualToString:@""])
        {
            cell.stateLbl.text = @"Not Mentioned";
        }
        else
        {
            cell.stateLbl.text = state;
        }
        
        if([city isEqualToString:@""])
        {
            cell.cityLbl.text = @"Not Mentioned";
        }
        else
        {
            cell.cityLbl.text = city;
        }
        
        if([company isEqualToString:@""])
        {
            cell.compnayNameLbl.text = @"Not Mentioned";
        }
        else
        {
            cell.compnayNameLbl.text =company;
            [cell.companyScrollView setContentSize:CGSizeMake(cell.compnayNameLbl.frame.size.width, 0)];
            if(company.length > 10)
            {
                cell.companyScrollView.userInteractionEnabled = YES;
            }
            else
            {
                cell.companyScrollView.userInteractionEnabled = NO;
            }
        }
        
        //set personal image
        NSURL *url = [NSURL URLWithString:[[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"PersonalProfileImageName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        NSString *str;
        if([[NSString stringWithFormat:@"%@",url] isEqualToString:@"http://www.7evenDigits.com/content/Profile/"])
        {
            
            str = [NSString stringWithFormat:@"%@noimage.png",[NSString stringWithFormat:@"%@",url]];
        }
        
        if ([[NSString stringWithFormat:@"%@",url] hasSuffix:@"default_Contact.png"] || [[NSString stringWithFormat:@"%@",url] hasSuffix:@"noimage.png"] || [[NSString stringWithFormat:@"%@",url] isEqualToString:@""] || [str hasSuffix:@"noimage.png"])
        {
                cell.personalImgView.image = [UIImage imageNamed:@"icon_with_oborder.png"];
        }
        else
        {
                [cell.personalImgView hnk_setImageFromURL:url];
        }
        
        // set professional image
        NSURL *url1 = [NSURL URLWithString:[[[profileDataArray objectAtIndex:indexPath.row] valueForKey:@"ProfessionalProfileImageName"]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
        if([[NSString stringWithFormat:@"%@",url1] isEqualToString:@"http://www.7evenDigits.com/content/Profile/"])
        {
            
            str = [NSString stringWithFormat:@"%@noimage.png",[NSString stringWithFormat:@"%@",url1]];
        }

        if ([[NSString stringWithFormat:@"%@",url1] hasSuffix:@"default_Contact.png"] || [[NSString stringWithFormat:@"%@",url1] hasSuffix:@"noimage.png"] || [[NSString stringWithFormat:@"%@",url1] isEqualToString:@""] || [str hasSuffix:@"noimage.png"])
        {
            cell.professionalImgView.image = [UIImage imageNamed:@"icon_with_oborder.png"];
        }
        else
        {
            [cell.professionalImgView hnk_setImageFromURL:url1];
        }

        //check professional status
        if(checkstatusProfessional == 1)
        {
            cell.professionalImgView.alpha = 1.0f;
        }
        else
        {
            cell.professionalImgView.alpha = 0.1f;
        }
        
        //check personal status
        if(checkstatusPersonal == 1)
        {
            cell.personalImgView.alpha = 1.0f;
        }
        else
        {
            cell.personalImgView.alpha = 0.1f;
        }
    }
   
    cell.PersonalBtnAction.tag = indexPath.row;
    cell.ProfessionalBtnAction.tag = indexPath.row;
    cell.professionalImgBtn.tag = indexPath.row;
    cell.personalImgBtn.tag = indexPath.row;
    
    [cell.PersonalBtnAction addTarget:self action:@selector(personalBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.ProfessionalBtnAction addTarget:self action:@selector(professionalBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.professionalImgBtn addTarget:self action:@selector(professionalImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.personalImgBtn addTarget:self action:@selector(personalImgBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

#pragma mark == ProfileBtnClicked

-(void)personalBtnClicked:(UIButton *)Personalbtn
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setInteger:1 forKey:@"one"];
    [userDef synchronize];
    
    i = Personalbtn.tag;
    int profileID = [[[profileDataArray  objectAtIndex:Personalbtn.tag] valueForKey:@"UserId"] intValue];
   
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
        [serviceIntegration IsContactAvailable:self UserId:CURRENT_USER_ID Profileid:profileID :@selector(receivedResponseSendPersonalWS:)];
    }
}

- (void)receivedResponseSendPersonalWS:(NSDictionary *)responseDict
{
       if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
       {
          [SVProgressHUD dismiss];
          [self setPersonalData];
       }
       else
       {
           [SVProgressHUD dismiss];
           [self setPersonalData];
           [cell.userExitsMsg setText:@"Personal Profile already in your contact list"];
       }
}

-(void)setPersonalData
{
    if(![PopView isDescendantOfView:self.view])
    {
        tableview.scrollEnabled = NO;
        tableview.alpha = 0.2;
        PopView.center = self.view.center;
        [PopView setAlpha:0.0];
        [self.view addSubview:PopView];
        [UIView beginAnimations:nil context:nil];
        [PopView setAlpha:1.0];
        [UIView commitAnimations];
    }
    
    firstName = [[profileDataArray objectAtIndex:i] valueForKey:@"PersonalFirstName"];
    lastName = [[profileDataArray objectAtIndex:i] valueForKey:@"PersonalLastName"];
    
    profileTypeRequest.text = @"Personal";
    NSLog(@"%ld",(long)profileType);
    UserIdLbl.text = [[profileDataArray objectAtIndex:i] valueForKey:@"UserName"];
    
    if([firstName isEqualToString:@""] && [lastName isEqualToString:@""])
    {
        NSString *professionalFirstName = [[profileDataArray objectAtIndex:i] valueForKey:@"ProfessionalFirstName"];
        NSString *professionalLastName = [[profileDataArray objectAtIndex:i] valueForKey:@"ProfessionalLastName"];
        if([professionalFirstName isEqualToString:@""] && [professionalLastName isEqualToString:@""])
        {
            NameLbl.text = @"Not Mentioned";
        }
        else
        {
            NameLbl.text = [NSString stringWithFormat:@"%@ %@",professionalLastName,professionalFirstName];
        }
    }
    else
    {
        NameLbl.text = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
    }

    checkImgUrl = [NSURL URLWithString:[[[profileDataArray objectAtIndex:i] valueForKey:@"PersonalProfileImageName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            
    if ([[NSString stringWithFormat:@"%@",checkImgUrl] hasSuffix:@"default_Contact.png"] || [[NSString stringWithFormat:@"%@",checkImgUrl] hasSuffix:@"noimage.png"] || [[NSString stringWithFormat:@"%@",checkImgUrl] isEqualToString:@""] || [[NSString stringWithFormat:@"%@",checkImgUrl] isEqualToString:@"http://www.7evenDigits.com/content/Profile/"])
    {
        PopUpImgView.image = [UIImage imageNamed:@"icon_with_oborder.png"];
    }
    else
    {
        [PopUpImgView hnk_setImageFromURL:checkImgUrl];
    }
}

-(void)professionalBtnClicked:(UIButton *)ProfessioanlBtn
{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setInteger:2 forKey:@"one"];
    [userDef synchronize];
    
    i = ProfessioanlBtn.tag;
    int profileID = [[[profileDataArray  objectAtIndex:ProfessioanlBtn.tag] valueForKey:@"UserId"] intValue];
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    if (appDeleagated.internetStatus == 0)
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
        [serviceIntegration IsContactAvailable:self UserId:CURRENT_USER_ID Profileid:profileID :@selector(receivedResponseSendProfessionalWS:)];
    }
}

-(void)setProfessionalData
{
    if(![PopView isDescendantOfView:self.view])
    {
        tableview.scrollEnabled = NO;
        tableview.alpha = 0.2;
        PopView.center = self.view.center;
        [PopView setAlpha:0.0];
        [self.view addSubview:PopView];
        [UIView beginAnimations:nil context:nil];
        [PopView setAlpha:1.0];
        [UIView commitAnimations];
    }
    profileTypeRequest.text = @"Professional";
    UserIdLbl.text = [[profileDataArray  objectAtIndex:i] valueForKey:@"UserName"];
    
    firstName = [[NSMutableString alloc] initWithString:[[profileDataArray objectAtIndex:i ]valueForKey:@"ProfessionalFirstName"]];
    lastName = [[profileDataArray objectAtIndex:i] valueForKey:@"ProfessionalLastName"];
    
    if([firstName isEqualToString:@""] && [lastName isEqualToString:@""])
    {
        NSString *personalFirstName = [[profileDataArray objectAtIndex:i] valueForKey:@"PersonalFirstName"];
        NSString *personalLastName = [[profileDataArray objectAtIndex:i] valueForKey:@"PersonalLastName"];
        if([personalFirstName isEqualToString:@""] && [personalLastName isEqualToString:@""])
        {
            NameLbl.text = @"Not Mentioned";
        }
        else
        {
            NameLbl.text = [NSString stringWithFormat:@"%@ %@",personalLastName,personalFirstName];
        }
    }
    else
    {
        NameLbl.text = [NSString stringWithFormat:@"%@ %@",lastName,firstName];
    }
    
   checkImgUrl = [NSURL URLWithString:[[[profileDataArray objectAtIndex:i] valueForKey:@"ProfessionalProfileImageName"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        
    if ([[NSString stringWithFormat:@"%@",checkImgUrl] hasSuffix:@"default_Contact.png"] || [[NSString stringWithFormat:@"%@",checkImgUrl] hasSuffix:@"noimage.png"] || [[NSString stringWithFormat:@"%@",checkImgUrl] isEqualToString:@""] || [[NSString stringWithFormat:@"%@",checkImgUrl] isEqualToString:@"http://www.7evenDigits.com/content/Profile/"])
    {
        PopUpImgView.image = [UIImage imageNamed:@"icon_with_oborder.png"];
    }
    else
    {
        [PopUpImgView hnk_setImageFromURL:checkImgUrl];
    }
}

- (void)receivedResponseSendProfessionalWS:(NSDictionary *)responseDict
{
       if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
       {
          [SVProgressHUD dismiss];
          [self setProfessionalData];
       }
       else
       {
           [SVProgressHUD dismiss];
           [self setProfessionalData];
           [cell.userExitsMsg setText:@"Professional Profile already in your contact list"];
       }
}


#pragma mark == ImgBtnClicked

-(void)professionalImgBtnClicked:(UIButton *)professionalImgBtn
{
    int status = [[[profileDataArray objectAtIndex:professionalImgBtn.tag] valueForKey:@"IsPublicProfessional"] intValue];
    if(status == 1)
    {
       int userProfileID = [[[profileDataArray objectAtIndex:professionalImgBtn.tag] valueForKey:@"UserProfessionalProfileId"] intValue];
        if(userProfileID == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"User has only Personal Profile" maskType:SVProgressHUDMaskTypeBlack];

        }
        [self callSearchProfileView:userProfileID];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"This profile is private,you will not able to view." maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)personalImgBtnClicked:(UIButton *)personalImgBtn
{
    int status = [[[profileDataArray objectAtIndex:personalImgBtn.tag] valueForKey:@"IsPublicPersonal"] intValue];
    if(status == 1)
    {
       int userProfileID = [[[profileDataArray objectAtIndex:personalImgBtn.tag] valueForKey:@"UserPersonalProfileId"] intValue];
        if(userProfileID == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"User has only Professional Profile" maskType:SVProgressHUDMaskTypeBlack];
            
        }
        [self callSearchProfileView:userProfileID];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"This profile is private,you will not able to view." maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)callSearchProfileView : (int)UserProfileID
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    if (serviceIntegration != nil)
    {
        serviceIntegration = nil;
    }
    serviceIntegration = [[ServerIntegration alloc]init];
    [serviceIntegration SearchViewProfile:self UserProfileID:UserProfileID :@selector(receivedResponseSearchProfile:)];
}

- (void)receivedResponseSearchProfile:(NSDictionary *)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD dismiss];
        if([[NSString stringWithFormat:@"%@",[[responseDict valueForKey:@"userDTO" ] valueForKey:@"ProfileType"]]isEqualToString:@"2"])
        {
            ViewProfessionalProfileVC *viewProfessionalProfileVC=[[ViewProfessionalProfileVC alloc]initWithNibName:@"ViewProfessionalProfileVC" bundle:[NSBundle mainBundle]];
            stringForTitle=@"Professional  Profile";
            viewProfessionalProfileVC.professionalProfileArray = [[NSMutableArray alloc]init];
            NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithDictionary:responseDict];
            [Dict setValue:@"YES" forKey:@"Yes"];
            [viewProfessionalProfileVC.professionalProfileArray addObject:Dict];
            [self.navigationController pushViewController:viewProfessionalProfileVC animated:YES];
        }
        else
        {
          ContactProfileViewController *contpfvc;
           contpfvc=[[ContactProfileViewController alloc]initWithNibName:@"ContactProfileViewController" bundle:[NSBundle mainBundle]];
           stringForTitle = @"Personal  Profile";
           contpfvc.contactArray = [[NSMutableArray alloc]init];
           NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithDictionary:responseDict];
           [Dict setValue:@"YES" forKey:@"Yes"];
           [contpfvc.contactArray addObject:Dict];
           [self.navigationController pushViewController:contpfvc animated:YES];
       }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}


#pragma mark - TextView Delegate

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    currentTxtView.text = textView.text;
    MsgTxtView.text = @"";
    MsgTxtView.textColor = [UIColor blackColor];
    [Parameters moveTextViewUpForView:PopView forTextView:textView forSubView:PopView];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    currentTxtView.text = textView.text;
    if(MsgTxtView.text.length == 0)
    {
        MsgTxtView.textColor = [UIColor blackColor];
        MsgTxtView.text = @"Message";
        [MsgTxtView resignFirstResponder];
    }
}


- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [Parameters moveTextViewDownforView:self.view];
    if ([MsgTxtView.text isEqualToString:@""])
    {
        MsgTxtView.text=defaultText;
        MsgTxtView.textColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:0.70];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if(textView.text.length == 250)
    {
        return NO;
        NSLog(@"Character range is 250");
    }
    else
    {
        return YES;
    }
}

#pragma mark - Add ToolBar Button
-(void)setToolbarToPhoneNumber
{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 44)];
    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancleToolBarBtn)];
    UIBarButtonItem *space =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okToolBarBtn)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:customItem1, space, customItem2, nil];
    
    [toolbar setItems:toolbarItems];
    MsgTxtView.inputAccessoryView = toolbar;
}

-(void)okToolBarBtn
{
    [MsgTxtView resignFirstResponder];
}
-(void)CancleToolBarBtn
{
    [MsgTxtView resignFirstResponder];
}


@end

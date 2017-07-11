
//
//  SearchViewController.m
//  7EvenDigits
//
//  Created by Krishna on 29/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "SearchViewController.h"
#import "ComposeViewController.h"
#import "Constant.h"
#import "AdvanceSearchViewController.h"
#import "SearchContactViewController.h"
#import "EditProfessionalProfile.h"

@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize dataAfterSearchArray,dataArray,objSearchBar,serachTableView,composeVC,selectedRowDataArray,CheckCityStatus,CheckStateStatus,searching;

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
    searching=false;
    
    [self.objSearchBar becomeFirstResponder];
    [objSearchBar setShowsCancelButton:NO animated:NO];
    
    objSearchBar.barTintColor=[UIColor colorWithRed:235.0f/255.0f green:110.0f/255.0f blue:30.0f/255.0f alpha:1 ];
    
    UIBarButtonItem *leftBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=leftBarBtn;
    
    [self tableFooterAdjustment];
}

-(void)viewWillAppear:(BOOL)animated
{
    [objSearchBar setShowsCancelButton:NO animated:NO];
}

-(void)handelSelectButton
{
    if (selectedIndexpath)
    {
        if ([self.title isEqualToString:@"State"])
        {
            if (searching)
            {
                if (self.composeVC)
                {
                    self.composeVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.composeVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.composeVC.textfieldForCity.text.length==0) || !(self.composeVC.textfieldForZip.text.length==0))
                    {
                        self.composeVC.textfieldForCity.text=@"";
                        self.composeVC.textfieldForZip.text=@"";
                    }
                }
                else if(self.searchContactVC)
                {
                    self.searchContactVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.searchContactVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.searchContactVC.textfieldForCity.text.length==0))
                    {
                        self.searchContactVC.textfieldForCity.text = @"";
                    }
                }
                else if(self.advanvedSearchVC)
                {
                    self.advanvedSearchVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.advanvedSearchVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.advanvedSearchVC.textfieldForCity.text.length==0) || !(self.advanvedSearchVC.textfieldForZip.text.length==0))
                    {
                        self.advanvedSearchVC.textfieldForCity.text=@"";
                        self.advanvedSearchVC.textfieldForZip.text=@"";
                    }
                }
                else
                {
                    self.editProfessionalVC.textFieldForState.text = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.editProfessionalVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.editProfessionalVC.textFieldForCity.text.length == 0) || !(self.editProfessionalVC.textFieldForZipCode.text.length == 0))
                    {
                        self.editProfessionalVC.textFieldForCity.text = @"";
                        self.editProfessionalVC.textFieldForZipCode.text = @"";
                    }

                }
            }
            else
            {
                if (self.composeVC)
                {
                    self.composeVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.composeVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    if(!(self.composeVC.textfieldForCity.text.length==0) || !(self.composeVC.textfieldForZip.text.length==0))
                    {
                        self.composeVC.textfieldForCity.text=@"";
                        self.composeVC.textfieldForZip.text=@"";
                    }
                }
                else if(self.searchContactVC)
                {
                    self.searchContactVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.searchContactVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    if(!(self.searchContactVC.textfieldForCity.text.length==0))
                    {
                        self.searchContactVC.textfieldForCity.text=@"";
                    }
                }
                else if(self.advanvedSearchVC)
                {
                    self.advanvedSearchVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.advanvedSearchVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.advanvedSearchVC.textfieldForCity.text.length==0) || !(self.advanvedSearchVC.textfieldForZip.text.length==0))
                    {
                        self.advanvedSearchVC.textfieldForCity.text=@"";
                        self.advanvedSearchVC.textfieldForZip.text=@"";
                    }
                }
                else
                {
                    self.editProfessionalVC.textFieldForState.text = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.editProfessionalVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.editProfessionalVC.textFieldForCity.text.length == 0) || !(self.editProfessionalVC.textFieldForZipCode.text.length == 0))
                    {
                        self.editProfessionalVC.textFieldForCity.text = @"";
                        self.editProfessionalVC.textFieldForZipCode.text = @"";
                    }

                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if  ([self.title isEqualToString:@"City"])
        {
            if(searching)
            {
                if (self.composeVC)
                {
                    self.composeVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.composeVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                else if(self.searchContactVC)
                {
                    self.searchContactVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.searchContactVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                else if(self.advanvedSearchVC)
                {
                    self.advanvedSearchVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.advanvedSearchVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                else
                {
                    self.editProfessionalVC.textFieldForCity.text = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.editProfessionalVC.cityId = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                
            }
            else
            {
                if (self.composeVC)
                {
                    self.composeVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.composeVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                    
                }
                else if(self.searchContactVC)
                {
                    self.searchContactVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.searchContactVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                    
                }
                else if(self.advanvedSearchVC)
                {
                    self.advanvedSearchVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.advanvedSearchVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                    
                }
                else
                {
                    self.editProfessionalVC.textFieldForCity.text = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                        
                    self.editProfessionalVC.cityId = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if  ([self.title isEqualToString:@"Zip Code"])
        {
            
            if (self.composeVC)
            {
                //State==0 & city==0
                if(self.composeVC.textfieldForState.text.length==0 & self.composeVC.textfieldForCity.text.length==0)
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city==0
                else if (!(self.composeVC.textfieldForState.text.length==0) & (self.composeVC.textfieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city
                else if (!(self.composeVC.textfieldForState.text.length==0) & !(self.composeVC.textfieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:self.composeVC.stateId CityId:self.composeVC.cityId Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
            }
            else if(self.advanvedSearchVC)
            {
                //State==0 & city==0
                if(self.advanvedSearchVC.textfieldForState.text.length==0 & self.advanvedSearchVC.textfieldForCity.text.length==0)
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city==0
                else if (!(self.advanvedSearchVC.textfieldForState.text.length==0) & (self.advanvedSearchVC.textfieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city
                else if (!(self.advanvedSearchVC.textfieldForState.text.length==0) & !(self.advanvedSearchVC.textfieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:self.advanvedSearchVC.stateId CityId:self.advanvedSearchVC.cityId Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
            }
            else
            {
                //State==0 & city==0
                if(self.editProfessionalVC.textFieldForState.text.length==0 & self.editProfessionalVC.textFieldForCity.text.length==0)
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city==0
                else if (!(self.editProfessionalVC.textFieldForState.text.length==0) & (self.editProfessionalVC.textFieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city
                else if (!(self.editProfessionalVC.textFieldForState.text.length==0) & !(self.editProfessionalVC.textFieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:self.editProfessionalVC.stateId CityId:self.editProfessionalVC.cityId Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }

            }
        }
        
    }
    
}
-(void)handelCancelButton
{
    if([self.title isEqualToString:@"State"])
    {
        if(self.composeVC)
        {
            self.composeVC.textfieldForState.text=@"";
            self.composeVC.textfieldForCity.text=@"";
            self.composeVC.textfieldForZip.text=@"";
            self.composeVC.stateId=nil;
        }
        else if(self.advanvedSearchVC)
        {
            self.advanvedSearchVC.textfieldForState.text=@"";
            self.advanvedSearchVC.textfieldForCity.text=@"";
            self.advanvedSearchVC.textfieldForZip.text=@"";
            self.advanvedSearchVC.stateId=nil;
        }
        else if(self.searchContactVC)
        {
            self.searchContactVC.textfieldForState.text = @"";
            self.searchContactVC.textfieldForCity.text = @"";
            self.searchContactVC.stateId = nil;
        }
        else
        {
            self.editProfessionalVC.textFieldForState.text=@"";
            self.editProfessionalVC.textFieldForCity.text=@"";
            self.editProfessionalVC.textFieldForZipCode.text=@"";
            self.editProfessionalVC.stateId=nil;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if([self.title isEqualToString:@"City"])
    {
        if(self.composeVC)
        {
            self.composeVC.textfieldForCity.text=@"";
            self.composeVC.cityId=nil;
            self.composeVC.textfieldForZip.text=@"";
            
        }
        else if(self.advanvedSearchVC)
        {
            self.advanvedSearchVC.textfieldForCity.text=@"";
            self.advanvedSearchVC.cityId=nil;
            self.advanvedSearchVC.textfieldForZip.text=@"";
        }
        else if(self.searchContactVC)
        {
            self.searchContactVC.textfieldForCity.text = @"";
            self.searchContactVC.cityId = nil;
        }
        else
        {
            self.editProfessionalVC.textFieldForCity.text=@"";
            self.editProfessionalVC.cityId=nil;
            self.editProfessionalVC.textFieldForZipCode.text=@"";
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    if([self.title isEqualToString:@"Zip Code"])
    {
        if(self.composeVC)
        {
            self.composeVC.textfieldForZip.text=@"";
        }
        else if(self.advanvedSearchVC)
        {
            self.advanvedSearchVC.textfieldForZip.text=@"";
        }
        else
        {
            self.editProfessionalVC.textFieldForZipCode.text=@"";
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)handelBackButton
{
    [objSearchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    objSearchBar.text = @"";
}

#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section
{
    if (searching)
    {
        return self.dataAfterSearchArray.count;
    }
    else
    {
        return self.dataArray.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if(searching)
    {
        if([self.title isEqualToString:@"State"])
        {
            cell.textLabel.text = [[self.dataAfterSearchArray objectAtIndex:indexPath.row]valueForKey:@"StateName"];
        }
        else if ([self.title isEqualToString:@"City"])
        {
            cell.textLabel.text = [[self.dataAfterSearchArray objectAtIndex:indexPath.row]valueForKey:@"CityName"];
        }
        else if ([self.title isEqualToString:@"Zip Code"])
        {
            cell.textLabel.text = [[self.dataAfterSearchArray objectAtIndex:indexPath.row]valueForKey:@"ZipCode"];
        }
    }
    else
    {
        if([self.title isEqualToString:@"State"])
        {
            cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"StateName"];
        }
        else if ([self.title isEqualToString:@"City"])
        {
            cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"CityName"];
        }
        else if ([self.title isEqualToString:@"Zip Code"])
        {
            cell.textLabel.text = [[self.dataArray objectAtIndex:indexPath.row]valueForKey:@"ZipCode"];
        }
    }
    
    if([selectedIndexpath isEqual:indexPath])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Uncheck the previous checked row
    if(selectedIndexpath)
    {
        UITableViewCell* uncheckCell = [tableView cellForRowAtIndexPath:selectedIndexpath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    selectedIndexpath= indexPath;
    [objSearchBar resignFirstResponder];
    
    
    if (selectedIndexpath)
    {
        if ([self.title isEqualToString:@"State"])
        {
            if (searching)
            {
                if (self.composeVC)
                {
                    self.composeVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.composeVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.composeVC.textfieldForCity.text.length==0) || !(self.composeVC.textfieldForZip.text.length==0))
                    {
                        self.composeVC.textfieldForCity.text=@"";
                        self.composeVC.textfieldForZip.text=@"";
                    }
                }
                else if(self.searchContactVC)
                {
                    self.searchContactVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.searchContactVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.searchContactVC.textfieldForCity.text.length==0))
                    {
                        self.searchContactVC.textfieldForCity.text=@"";
                    }
                }
                else if(self.advanvedSearchVC)
                {
                    self.advanvedSearchVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.advanvedSearchVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.advanvedSearchVC.textfieldForCity.text.length==0) || !(self.advanvedSearchVC.textfieldForZip.text.length==0))
                    {
                        self.advanvedSearchVC.textfieldForCity.text=@"";
                        self.advanvedSearchVC.textfieldForZip.text=@"";
                    }
                }
                else
                {
                    self.editProfessionalVC.textFieldForState.text = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.editProfessionalVC.stateId = [[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.editProfessionalVC.textFieldForCity.text.length == 0) || !(self.editProfessionalVC.textFieldForZipCode.text.length == 0))
                    {
                        self.editProfessionalVC.textFieldForCity.text = @"";
                        self.editProfessionalVC.textFieldForZipCode.text = @"";
                    }

                }
            }
            else
            {
                if (self.composeVC)
                {
                    self.composeVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.composeVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    if(!(self.composeVC.textfieldForCity.text.length==0) || !(self.composeVC.textfieldForZip.text.length==0))
                    {
                        self.composeVC.textfieldForCity.text=@"";
                        self.composeVC.textfieldForZip.text=@"";
                    }
                }
                else if(self.searchContactVC)
                {
                    self.searchContactVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.searchContactVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    if(!(self.searchContactVC.textfieldForCity.text.length==0))
                    {
                        self.searchContactVC.textfieldForCity.text=@"";
                    }
                }
                else if(self.advanvedSearchVC)
                {
                    self.advanvedSearchVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.advanvedSearchVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.advanvedSearchVC.textfieldForCity.text.length==0) || !(self.advanvedSearchVC.textfieldForZip.text.length==0))
                    {
                        self.advanvedSearchVC.textfieldForCity.text=@"";
                        self.advanvedSearchVC.textfieldForZip.text=@"";
                    }
                }
                else
                {
                    self.editProfessionalVC.textFieldForState.text = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateName"]] ;
                    
                    self.editProfessionalVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"StateId"]];
                    
                    if(!(self.editProfessionalVC.textFieldForCity.text.length == 0) || !(self.editProfessionalVC.textFieldForZipCode.text.length == 0))
                    {
                        self.editProfessionalVC.textFieldForCity.text = @"";
                        self.editProfessionalVC.textFieldForZipCode.text = @"";
                    }

                }
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if  ([self.title isEqualToString:@"City"])
        {
            if(searching)
            {
                if (self.composeVC)
                {
                    self.composeVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.composeVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                else if(self.searchContactVC)
                {
                    self.searchContactVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.searchContactVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                else if(self.advanvedSearchVC)
                {
                    self.advanvedSearchVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.advanvedSearchVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                else
                {
                    self.editProfessionalVC.textFieldForCity.text = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.editProfessionalVC.cityId = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
            }
            else
            {
                if (self.composeVC)
                {
                    self.composeVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.composeVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                    
                }else if(self.searchContactVC){
                    self.searchContactVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.searchContactVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                else if(self.advanvedSearchVC)
                {
                    self.advanvedSearchVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.advanvedSearchVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[self.dataArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                    
                }
                else
                {
                    self.editProfessionalVC.textFieldForCity.text = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityName"]] ;
                    
                    self.editProfessionalVC.cityId = [[NSString alloc]initWithFormat:@"%@",[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"CityId"]];
                }
                
            }
            [self.navigationController popViewControllerAnimated:YES];
            
        }
        else if  ([self.title isEqualToString:@"Zip Code"])
        {
            
            if (self.composeVC)
            {
                //State==0 & city==0
                if(self.composeVC.textfieldForState.text.length==0 & self.composeVC.textfieldForCity.text.length==0)
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city==0
                else if (!(self.composeVC.textfieldForState.text.length==0) & (self.composeVC.textfieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city
                else if (!(self.composeVC.textfieldForState.text.length==0) & !(self.composeVC.textfieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:self.composeVC.stateId CityId:self.composeVC.cityId Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
            }
            else if(self.advanvedSearchVC)
            {
                //State==0 & city==0
                if(self.advanvedSearchVC.textfieldForState.text.length==0 & self.advanvedSearchVC.textfieldForCity.text.length==0)
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city==0
                else if (!(self.advanvedSearchVC.textfieldForState.text.length==0) & (self.advanvedSearchVC.textfieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city
                else if (!(self.advanvedSearchVC.textfieldForState.text.length==0) & !(self.advanvedSearchVC.textfieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:self.advanvedSearchVC.stateId CityId:self.advanvedSearchVC.cityId Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
            }
            else
            {
                if(self.editProfessionalVC.textFieldForState.text.length==0 & self.editProfessionalVC.textFieldForCity.text.length==0)
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city==0
                else if (!(self.editProfessionalVC.textFieldForState.text.length==0) & (self.editProfessionalVC.textFieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }
                //State & city
                else if (!(self.editProfessionalVC.textFieldForState.text.length==0) & !(self.editProfessionalVC.textFieldForCity.text.length==0))
                {
                    [serviceIntegration GetZipCodeListByState:self StateId:self.editProfessionalVC.stateId.length > 0 ? self.editProfessionalVC.stateId : @"0" CityId:self.editProfessionalVC.cityId.length > 0 ? self.editProfessionalVC.cityId : @"0" Zip:[[self.dataAfterSearchArray objectAtIndex:selectedIndexpath.row] valueForKey:@"ZipCode"] :@selector(receivedResponseDataForSelected:)];
                }

            }
        }
        //[self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search Bar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    
    [objSearchBar setShowsCancelButton:NO animated:NO];
    objSearchBar.autocapitalizationType= UITextAutocapitalizationTypeNone;
    objSearchBar.autocorrectionType= UITextAutocorrectionTypeNo;
    
    if ([self.title isEqualToString:@"Zip Code"])
    {
        objSearchBar.keyboardType=UIKeyboardTypeNumberPad;
        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 425, 320, 35)];
        UIBarButtonItem *space =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.backgroundColor=[UIColor darkTextColor];
        
        UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okToolBarBtn)];
        customItem2.tintColor = [UIColor blackColor];;
        NSArray *toolbarItems = [NSArray arrayWithObjects: space, customItem2, nil];
        
        
        [toolbar setItems:toolbarItems];
        
        self.objSearchBar.inputAccessoryView=toolbar;
        
    }
    else
    {
        objSearchBar.keyboardType=UIKeyboardTypeAlphabet;
    }
    searchBar.showsCancelButton = YES;
    return YES;
}
-(void)okToolBarBtn
{
    [self.objSearchBar resignFirstResponder];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    selectedIndexpath=Nil;
    objSearchBar.text=@"";
    searching = FALSE;
    [self.dataArray removeAllObjects];
    [self.dataAfterSearchArray removeAllObjects];
    [self.serachTableView reloadData];
    
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

-(void)searchBar:(UISearchBar*)searchBar1 textDidChange:(NSString*)text
{
    if(text.length == 0)
    {
        searching = FALSE;
        selectedIndexpath=Nil;
        [self.dataArray removeAllObjects];
        [self.dataAfterSearchArray removeAllObjects];
        [self.serachTableView reloadData];
    }
    else
    {
        appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
        
        if (appDeleagated.internetStatus==0)
        {
            [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
        }
        else
        {
            if (serviceIntegration != nil)
            {
                serviceIntegration = nil;
            }
            serviceIntegration = [[ServerIntegration alloc]init];
            
            searchText = [searchBar1.text uppercaseString];
            self.dataAfterSearchArray  = [[NSMutableArray alloc] init];
            if((searchText.length >=1) & [self.title isEqualToString:@"Zip Code"])
            {
                [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                
                if (searchText.length>6)
                {
                    [SVProgressHUD showErrorWithStatus:@"zipcode does not exist" maskType:SVProgressHUDMaskTypeBlack];
                    return;
                }
                
                else if (self.composeVC)
                {
                    //State==0 & city==0
                    if(self.composeVC.textfieldForState.text.length==0 & self.composeVC.textfieldForCity.text.length==0)
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }
                    //            //State & city==0
                    else if (!(self.composeVC.textfieldForState.text.length==0) & (self.composeVC.textfieldForCity.text.length==0))
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }
                    //State & city
                    else if (!(self.composeVC.textfieldForState.text.length==0) & !(self.composeVC.textfieldForCity.text.length==0))
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:self.composeVC.stateId CityId:self.composeVC.cityId Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }
                }
                else if(self.advanvedSearchVC)
                {
                    //State==0 & city==0
                    if(self.advanvedSearchVC.textfieldForState.text.length==0 & self.advanvedSearchVC.textfieldForCity.text.length==0)
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }
                    //State & city==0
                    else if (!(self.advanvedSearchVC.textfieldForState.text.length==0) & (self.advanvedSearchVC.textfieldForCity.text.length==0))
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }
                    //State & city
                    else if (!(self.advanvedSearchVC.textfieldForState.text.length==0) & !(self.advanvedSearchVC.textfieldForCity.text.length==0))
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:self.advanvedSearchVC.stateId CityId:self.advanvedSearchVC.cityId Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }
                }
                else
                {
                    //State==0 & city==0
                    if(self.editProfessionalVC.textFieldForState.text.length==0 & self.editProfessionalVC.textFieldForCity.text.length==0)
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }
                    //State & city==0
                    else if (!(self.editProfessionalVC.textFieldForState.text.length==0) & (self.editProfessionalVC.textFieldForCity.text.length==0))
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:@"0" CityId:@"0" Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }
                    //State & city
                    else if (!(self.editProfessionalVC.textFieldForState.text.length==0) & !(self.editProfessionalVC.textFieldForCity.text.length==0))
                    {
                        [serviceIntegration GetZipCodeListByState:self StateId:self.editProfessionalVC.stateId.length > 0 ? self.editProfessionalVC.stateId : @"0" CityId:self.editProfessionalVC.cityId.length > 0 ? self.editProfessionalVC.cityId :@"0" Zip:self.objSearchBar.text :@selector(receivedResponseDataForCompose:)];
                    }

                }
            }
            else if([self.title isEqualToString:@"State"])
            {
                [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                [serviceIntegration GetStateList:self q:searchText :@selector(receivedResponseDataForCompose:)];
            }
            else if([self.title isEqualToString:@"City"])
            {
                [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                
                if(self.composeVC)
                {
                    if(self.composeVC.stateId.length >0)
                    {
                        [serviceIntegration GetCityListWebService:self StateId:self.composeVC.stateId q:searchText :@selector(receivedResponseDataForCompose:)];
                    }
                    else
                    {
                        [serviceIntegration GetCityListWebService:self StateId:@"0" q:searchText :@selector(receivedResponseDataForCompose:)];
                    }
                }
                else if(self.advanvedSearchVC)
                {
                    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                    
                    if(self.advanvedSearchVC.stateId.length>0)
                    {
                        [serviceIntegration GetCityListWebService:self StateId:self.advanvedSearchVC.stateId q:searchText :@selector(receivedResponseDataForCompose:)];
                    }
                    else
                    {
                        [serviceIntegration GetCityListWebService:self StateId:@"0" q:searchText :@selector(receivedResponseDataForCompose:)];
                    }
                }
                else if (self.searchContactVC)
                {
                    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                    
                    if(self.searchContactVC.stateId.length>0)
                    {
                        [serviceIntegration GetCityListWebService:self StateId:self.searchContactVC.stateId q:searchText :@selector(receivedResponseDataForCompose:)];
                    }
                    else
                    {
                        [serviceIntegration GetCityListWebService:self StateId:@"0" q:searchText :@selector(receivedResponseDataForCompose:)];
                    }
                }
                else
                {
                    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                    
                    if(self.editProfessionalVC.stateId.length>0)
                    {
                        [serviceIntegration GetCityListWebService:self StateId:self.editProfessionalVC.stateId q:searchText :@selector(receivedResponseDataForCompose:)];
                    }
                    else
                    {
                        [serviceIntegration GetCityListWebService:self StateId:@"0" q:searchText :@selector(receivedResponseDataForCompose:)];
                    }

                }
            }
            else
            {
                [self searchData];
            }
            searching = true;
        }
    }
    [self.serachTableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    objSearchBar.text=[NSString stringWithFormat:@"%@",[theSearchBar text]];
    [objSearchBar resignFirstResponder];
}

-(void)searchData
{
    for (NSMutableArray *item1 in self.dataArray)
    {
        NSString *string;
        if ([self.title isEqualToString:@"State"])
        {
            string =[item1 valueForKey:@"StateName"];
        }
        if ([self.title isEqualToString:@"City"])
        {
            string =[item1 valueForKey:@"CityName"];
        }
        if ([self.title isEqualToString:@"Zip Code"])
        {
            string =[item1 valueForKey:@"ZipCode"];
        }
        
        if (searchText.length>0)
        {
            if([[string uppercaseString] hasPrefix:searchText])
            {
                [self.dataAfterSearchArray addObject:item1];
            }
        }
    }
}

-(void)setSelectedRowData
{
    
}
#pragma mark== Receive Response


- (void)receivedResponseDataForCompose:(NSMutableArray *)responseArray
{
    // NSLog(@"serch respons%@",responseArray);
    
        self.dataArray=[[NSMutableArray alloc]init];
        for (int i=0; i< responseArray.count; i++)
       {
           [self.dataArray addObject:[responseArray  objectAtIndex:i]];
       }
       if([self.title isEqualToString:@"State"])
       {
          if([self.dataArray count]==0)
          {
              [SVProgressHUD showErrorWithStatus:@"State does not exist" maskType:SVProgressHUDMaskTypeBlack];
              CheckStateStatus = true;
              [objSearchBar resignFirstResponder];
          }
          else
          {
              [SVProgressHUD dismiss];
          }
       }
       if([self.title isEqualToString:@"City"])
       {
          if([self.dataArray count]==0)
          {
              [SVProgressHUD showErrorWithStatus:@"City does not exist" maskType:SVProgressHUDMaskTypeBlack];
              CheckCityStatus = true;
              [objSearchBar resignFirstResponder];
          }
          else
          {
              [SVProgressHUD dismiss];
          }
       }
       if([self.title isEqualToString:@"Zip Code"])
       {
          if([self.dataArray count]==0)
          {
              [SVProgressHUD showErrorWithStatus:@"Zip Code does not exist" maskType:SVProgressHUDMaskTypeBlack];
              [objSearchBar resignFirstResponder];
          }
          else
          {
              [SVProgressHUD dismiss];
          }
       }
        [self searchData];
        [self.serachTableView reloadData];
}

- (void)receivedResponseDataForSelected:(NSMutableArray *)responseArray
{
    [SVProgressHUD dismiss];
    // NSLog(@"serch respons%@",responseArray);
    self.selectedRowDataArray=[[NSMutableArray alloc]init];
    if (self.composeVC)
    {
        for (int i=0; i< responseArray.count; i++)
        {
            self.composeVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"StateName"]] ;
            self.composeVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"CityName"]] ;
            self.composeVC.textfieldForZip.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"ZipCode"]] ;
            self.composeVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"StateId"]];
            self.composeVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"CityId"]];
            self.composeVC.zipCodeId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"ZipCodeId"]];
        }
    }
    else if(self.advanvedSearchVC)
    {
        for (int i=0; i< responseArray.count; i++)
        {
            self.advanvedSearchVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"StateName"]] ;
            self.advanvedSearchVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"CityName"]] ;
            self.advanvedSearchVC.textfieldForZip.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"ZipCode"]] ;
            self.advanvedSearchVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"StateId"]];
            self.advanvedSearchVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"CityId"]];
            self.advanvedSearchVC.zipCodeId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"ZipCodeId"]];
        }
    }
    else if(self.searchContactVC)
    {
        for (int i=0; i< responseArray.count; i++)
        {
            self.searchContactVC.textfieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"StateName"]] ;
            self.searchContactVC.textfieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"CityName"]] ;
            self.searchContactVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"StateId"]];
            self.searchContactVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"CityId"]];
        }
    }
    else
    {
        for (int i=0; i< responseArray.count; i++)
        {
            self.editProfessionalVC.textFieldForState.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"StateName"]] ;
            self.editProfessionalVC.textFieldForCity.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"CityName"]] ;
            self.editProfessionalVC.textFieldForZipCode.text=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"ZipCode"]] ;
            self.editProfessionalVC.stateId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"StateId"]];
            self.editProfessionalVC.cityId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"CityId"]];
            self.editProfessionalVC.zipCodeId=[[NSString alloc]initWithFormat:@"%@",[[responseArray objectAtIndex:i] valueForKey:@"ZipCodeId"]];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

-(void)tableFooterAdjustment
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.serachTableView.tableFooterView = view;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [objSearchBar resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [objSearchBar resignFirstResponder];
}

@end

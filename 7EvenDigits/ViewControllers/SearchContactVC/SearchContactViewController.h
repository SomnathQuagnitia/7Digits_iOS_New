//
//  SearchContactViewController.h
//  7EvenDigits
//
//  Created by Tanvi on 9/14/16.
//  Copyright © 2016 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
#import "Parameters.h"

@class ContactViewController;
@class SearchViewController;
@class SearchGoViewController;

@interface SearchContactViewController : UIViewController<UITextFieldDelegate>
{
    UITextField *currentTxtFld;
    SearchViewController *searchVC;
    SearchGoViewController *searchGoVC;
    ServerIntegration *serviceIntegration;
    AppDelegate *appDeleagated;
    NSString *status;
}
@property(strong,nonatomic)IBOutlet UITextField *textfieldForFirstName;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForLastName;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForCompany;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForTitle;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForState;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForCity;
@property(strong, nonatomic)ContactViewController *ContactVC;
@property (strong, nonatomic) NSMutableArray *searchContactDataDict;
@property (strong, nonatomic) IBOutlet UIButton *searchPersonalBtn;
@property (strong, nonatomic) IBOutlet UIButton *searchProfessionalBtn;

-(IBAction)handelStateList:(UIButton *)sender;
-(IBAction)handelCityList:(UIButton *)sender;
- (IBAction)searchPersonalBtn:(UIButton *)sender;
- (IBAction)searchProfessionalBtn:(UIButton *)sender;


@property(strong,nonatomic)NSString *stateId;
@property(strong,nonatomic)NSString *cityId;

- (IBAction)handleCancel:(id)sender;
- (IBAction)handelCancelButton:(id)sender;
- (IBAction)handelGoButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *cancelStateBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelCityBtn;

@end

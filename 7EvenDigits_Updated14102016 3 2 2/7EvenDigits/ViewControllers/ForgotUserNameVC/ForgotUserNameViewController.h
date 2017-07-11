//
//  ForgotUserNameViewController.h
//  7EvenDigits
//
//  Created by Krishna on 29/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerIntegration.h"
@interface ForgotUserNameViewController : UIViewController
{
    ServerIntegration *serviceIntegration;
}
@property(strong,nonatomic)IBOutlet UITextField *textFieldForEmailForget;
-(IBAction)handelSubmit:(id)sender;
-(IBAction)handelCancel:(id)sender;
@end



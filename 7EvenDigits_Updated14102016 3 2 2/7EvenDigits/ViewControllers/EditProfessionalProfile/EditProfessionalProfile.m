//
//  EditProfessionalProfile.m
//  7EvenDigits
//
//  Created by Neha_Mac on 19/06/15.
//  Copyright (c) 2015 Quagnitia Systems. All rights reserved.
//

#import "EditProfessionalProfile.h"
#import "MenuViewController.h"
#import "ZSSRichTextEditor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constant.h"

@interface EditProfessionalProfile ()

@end

@implementation EditProfessionalProfile

@synthesize textfieldForUserName,textfieldForFirstName,textfieldForLastName,editProfessionalProfileArray,imageViewForImage,textfieldForCompany,textfieldForDigits,textfieldForEmail,textfieldForTitle,addressTextView,isEditingMyProfile,textfieldForMobile,textfieldForWorkNumber,placeholderImageVdo,textfieldForOccupation,videoStringPath,textFieldForState,textFieldForCity,textFieldForZipCode,cancelCityBtn,cancelStateBtn,cancelZipCodeBtn;

@synthesize videoImageFromBack;
@synthesize userImage;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}



- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [cancelCityBtn setHidden:YES];
    [cancelStateBtn setHidden:YES];
    [cancelStateBtn setHidden:YES];
    
    self.publicStatusBtn.tag = 1;
    self.privateStatusBtn.tag = 0;
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    isProfileDataSet = @"No";
    defaultText =  @"Address";
    isImageSelctedFOrVideo = @"No";
    isVideoImage=@"No";
    selectedImageToRotate = nil;
    selectedImageTag = 0;
    videoStringPath = [[NSString alloc]init];
    videoData = [[NSData alloc]init];
    self.title=@"Professional Profile";
    
    NSString *html1 = @"";
    // Set the base URL if you would like to use relative links, such as to images.
    self.baseURL = [NSURL URLWithString:@"http://www.google.com"];
    // If you want to pretty print HTML within the source view.
    self.formatHTML = YES;
    [self setHtml:html1];
    NSString *html;
    html = [Parameters decodeDataForEmogies:[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserNotes"]];
    
    if (self.sourceView.hidden)
    {
        self.sourceView.text = @"";
        self.sourceView.hidden = YES;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
        NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
        NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
        NSString *source = [[NSBundle mainBundle] pathForResource:@"ZSSRichTextEditor" ofType:@"js"];
        NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--content-->" withString:html];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
        [self.editorView loadHTMLString:htmlString baseURL:self.baseURL];
        self.resourcesLoaded = YES;
        self.sourceView.text = html;
        NSString *cleanedHTML = [self removeQuotesFromHTML:self.sourceView.text];
        NSString *trigger = [NSString stringWithFormat:@"zss_editor.setHTML(\"%@\");", cleanedHTML];
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
        self.editorView.hidden = NO;
    }
    else
    {
        [self setHtml:self.sourceView.text];
        self.sourceView.hidden = YES;
        self.editorView.hidden = NO;
    }
    [scrollviewObj setContentSize:CGSizeMake(0, 1180)];

    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButtonInEditProfProfile)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    self.sourceView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([isProfileDataSet isEqualToString:@"No"]){
        isProfileDataSet = @"Yes";
        [self setProfileData];
    }
    [SVProgressHUD dismiss];
}

-(void)setProfileData
{
    
    isImageChanged = @"No";
    profileId=@"";
  
    int checkstatus = [[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"IsPublic"] intValue];
    NSLog(@"Status is %ld",(long)checkstatus);
    if(checkstatus == 1)
    {
        status = 1;
       [self.publicStatusBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
       [self.privateStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];

    }
    else
    {
        status = 0;
        [self.privateStatusBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
        [self.publicStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];

    }
    
    textfieldForFirstName.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"FirstName"];
    textfieldForLastName.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"LastName"];
    textfieldForUserName.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserName"];
    OccupationString = [[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"Occupation"];


    textfieldForDigits.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"PhoneNumber"];
    textfieldForMobile.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"MobileNumber"];
    textfieldForWorkNumber.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"WorkNumber"];
    
    textfieldForTitle.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserTitle"];
    textfieldForCompany.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserCompany"];
    
    NSString *add =[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserAddress"];
     if (add.length > 0) {
        NSString *str = [[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserAddress"];
        if (str.length > 0)
        {
            NSArray *arr = [str componentsSeparatedByString:@"\n"];
            
            if (arr.count > 0)
            {
                if (arr.count == 1)
                {
                    if (![[arr objectAtIndex:0] isEqualToString:@"Address1"])
                    {
                        self.textfieldForAddress1.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
                    }
                }
                else if (arr.count == 2)
                {
                    
                    if (![[arr objectAtIndex:0] isEqualToString:@"Address1"])
                    {
                        self.textfieldForAddress1.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
                    }
                    
                    if (![[arr objectAtIndex:1] isEqualToString:@"Address2"])
                    {
                        self.textfieldForAddress2.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
                    }
                }
            else if (arr.count == 3)
           {
               
                    if (![[arr objectAtIndex:0] isEqualToString:@"Address1"])
                    {
                        self.textfieldForAddress1.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
                    }
               
                    if (![[arr objectAtIndex:1] isEqualToString:@"Address2"])
                    {
                        self.textfieldForAddress2.text = [NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
                    }
               
                    if (![[arr objectAtIndex:2] isEqualToString:@"Address3"])
                    {
                        NSString *cityZipStr = [NSString stringWithFormat:@"%@",[arr objectAtIndex:2]];
                        [cityZipStr enumerateSubstringsInRange:NSMakeRange(0, [cityZipStr length]) options:NSStringEnumerationByWords | NSStringEnumerationReverse usingBlock:^(NSString *substring, NSRange subrange, NSRange enclosingRange, BOOL *stop) {
                            textFieldForZipCode.text = substring;
                            *stop = YES;
                        }];
                      
                    }
                }
            }
            else
            {
                self.textfieldForAddress1.text = str;
            }
        }
    }
    
    NSString *city;
    city =[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"City"];
    [city stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    
    textFieldForCity.text = city;
    textFieldForState.text = [[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"State"];

   locationText = [[NSMutableString alloc] initWithString:textFieldForState.text];
    [locationText appendFormat:@" %@", textFieldForCity.text];
    
    textfieldForEmail.text=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"EmailId"];
    
    profileId=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileId"];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileImageName"]];
    
    if ([urlStr hasSuffix:@"default_Contact.png"] || [urlStr hasSuffix:@"noimage.png"] )
    {
        self.imageViewForImage.image = [UIImage imageNamed:@"default_profile_img.png"];
        [noFileChoosen setHidden:NO];
    }
    else
    {
        if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
        {
            NSURL *url = [NSURL URLWithString:[[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileImageName"]
                                               stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            if(!self.imageViewForImage.image){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    if (data) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.imageViewForImage.image = [[UIImage alloc]initWithData:data];
                        });
                    }
                });
            }
            [self.imageViewForImage hnk_setImageFromURL:url];
            [noFileChoosen setHidden:YES];
        }
        else {
            self.imageViewForImage.image = [UIImage imageNamed:@"default_profile_img.png"];
            [noFileChoosen setHidden:NO];
        }
    }
    
    
    NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileVideoImage"]];
    
    if (videoImageStr!=nil && videoImageStr.length > 0 && ![videoImageStr isEqualToString:@"<null>"]) {
        NSURL *url = [NSURL URLWithString:[[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileVideoImage"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
          isImageSelctedFOrVideo =@"Yes";
        [placeholderImageVdo hnk_setImageFromURL:url];
        if(!placeholderImageVdo.image){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                NSData *data = [NSData dataWithContentsOfURL:url];
                if (data) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        placeholderImageVdo.image = [[UIImage alloc]initWithData:data];
                    });
                }
            });
        }
        
    }
    else
    {
        placeholderImageVdo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
        [noFileChoosenVideo setHidden:NO];
        isImageSelctedFOrVideo = @"No";
    }
    
    isVideoChanged = NO;
    
    NSString *videoUrlStr = [NSString stringWithFormat:@"%@",[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileVideo"]];
    
    if (videoUrlStr!=nil && videoUrlStr.length > 0 && ![videoUrlStr isEqualToString:@"<null>"]) {
        //        UIImage *placeHolderImage = [CommonNotification thumbnailImageForVideo:[NSURL URLWithString:videoStringPath] atTime:3.0f];
        
        videoUrlStr = [videoUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        videoStringPath = [NSString stringWithFormat:@"%@",videoUrlStr];
        isVideoDeleted = NO;
    }
    else
    {
        [noFileChoosenVideo setHidden:NO];
    }
    
    
    //Setting Images from previous view
    placeholderImageVdo.image =  videoImageFromBack;
    
    self.imageViewForImage.image = userImage;
    
    
    if([isEditingMyProfile isEqualToString: @"Yes"])
    {
        [textfieldForUserName setUserInteractionEnabled:NO];
    }
    else
    {
        [textfieldForUserName setUserInteractionEnabled:YES];
    }
    
    
    [Parameters addPaddingView:textfieldForFirstName];
    [Parameters addPaddingView:textfieldForLastName];
    [Parameters addPaddingView:textfieldForUserName];
    [Parameters addPaddingView:textfieldForCompany];
    [Parameters addPaddingView:textfieldForDigits];
    [Parameters addPaddingView:textfieldForEmail];
    [Parameters addPaddingView:textfieldForTitle];
    [Parameters addPaddingView:textfieldForMobile];
    [Parameters addPaddingView:textfieldForWorkNumber];
    [Parameters addPaddingView:self.textfieldForAddress1];
    [Parameters addPaddingView:self.textfieldForAddress2];
    [Parameters addPaddingView:textFieldForState];
    [Parameters addPaddingView:textFieldForCity];
    [Parameters addPaddingView:textFieldForZipCode];
    [Parameters addPaddingView:textfieldForOccupation];
    
    [self setToolbarToPhoneNumber];
    
    [self hideShowPlayVideoButton];
    NSLog(@"%@",editProfessionalProfileArray);

}

-(void)setToolbarToPhoneNumber
{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, 320, 44)];
    UIBarButtonItem *customItem1 = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(CancleToolBarBtn)];
    
    UIBarButtonItem *space =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okToolBarBtn)];
    NSArray *toolbarItems = [NSArray arrayWithObjects:customItem1, space, customItem2, nil];
    
    
    [toolbar setItems:toolbarItems];
    
    self.textfieldForDigits.inputAccessoryView=toolbar;
    textfieldForMobile.inputAccessoryView=toolbar;
    textfieldForWorkNumber.inputAccessoryView=toolbar;
}
-(void)okToolBarBtn
{
    [currentTextField resignFirstResponder];
}
-(void)CancleToolBarBtn
{
    [currentTextField resignFirstResponder];
}
- (NSString *)removeQuotesFromHTML:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    html = [html stringByReplacingOccurrencesOfString:@"&nsbp;"  withString:@""];
    
    return html;
}
-(void)viewWillAppear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (textFieldForState.text.length > 0)
    {
        [cancelStateBtn setHidden:NO];
    }
    else
    {
        [cancelStateBtn setHidden:YES];
    }
    if (textFieldForCity.text.length > 0)
    {
        [cancelCityBtn setHidden:NO];
    }
    else
    {
        [cancelCityBtn setHidden:YES];
    }
    if (textFieldForZipCode.text.length > 0)
    {
        [cancelZipCodeBtn setHidden:NO];
    }
    else
    {
        [cancelZipCodeBtn setHidden:YES];
    }

}
-(IBAction)handelCancel:(id)sender
{
    cancelButtonClick=YES;
    [self checkForhtmlMessage];
    
    UIImage *previousImage = [UIImage imageNamed:@"default_profile_img.png"];
    CGSize test = previousImage.size;
    UIImage *imagw=imageViewForImage.image;
    CGSize test1 = imagw.size;
    
    if(textfieldForFirstName.text.length==0 && textfieldForLastName.text.length==0 &&  textfieldForUserName.text.length==0 && [myStr isEqualToString:@""] && (test.width == test1.width && test.height == test1.height))
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (IS_IOS8)
        {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to cancel?" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self handelYesButtonAction];
                                       }];
            [alertVC addAction:okAction];
            
            UIAlertAction *cancelAction = [UIAlertAction
                                           actionWithTitle:@"Cancel"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self dismissViewControllerAnimated:YES completion:nil];
                                               [self handelNoButtonAction];
                                           }];
            
            [alertVC addAction:cancelAction];
            
            
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        else
        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to cancel?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//            [alert show];
        }
    }
}
-(void)handelBackButtonInEditProfProfile
{
    [currentTextField resignFirstResponder];
    
    [self checkForhtmlMessage];
    UIImage *previousImage = [UIImage imageNamed:@"default_profile_img.png"];
    CGSize test = previousImage.size;
    UIImage *imagw=imageViewForImage.image;
    CGSize test1 = imagw.size;
    
    if(textfieldForFirstName.text.length==0 && textfieldForLastName.text.length==0 &&  textfieldForUserName.text.length==0 && [myStr isEqualToString:@""] && (test.width == test1.width && test.height == test1.height))
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    //for edit contact
    else if([self.title isEqualToString:@"Professional Profile"])
    {
        NSString *stringForFirstName;
        NSString *stringForLastName;
        NSString *stringForUserName;
        NSString *stringForEmail;
        NSString *stringForDigits;
        NSString *stringForCompany;
        NSString *stringForTitle;
        NSString *stringForAddress;
        NSURL *url;
        NSString * previousHtml;
        NSString *stringForState;
        NSString *stringForCity;
        NSString *stringForOccupation;
        
        //for edit contact
        stringForFirstName=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"FirstName"];
        stringForLastName=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"LastName"];
        stringForUserName=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserName"];
        stringForEmail=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"EmailId"];
        stringForDigits=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"PhoneNumber"];
        stringForCompany=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserCompany"];
        stringForTitle=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserTitle"];
        stringForAddress=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserAddress"];
        stringForState=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"State"];
        stringForCity=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"City"];
        stringForOccupation=[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"Occupation"];

        url = [NSURL URLWithString:[[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileImageName"]
                                    stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        previousHtml = [self convertHTML:[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"UserNotes"]];
               
        NSMutableString *htmlMessage= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
        
        htmlMessageText = nil;
        NSRange start = [htmlMessage rangeOfString:@">"];
        if (start.location != NSNotFound)
        {
            htmlMessageText = [htmlMessage substringFromIndex:start.location + start.length];
            NSRange end = [htmlMessageText rangeOfString:@"</body>"];
            if (end.location != NSNotFound)
            {
                htmlMessageText = [htmlMessageText substringToIndex:end.location];
            }
        }
        NSMutableString *innerText= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"]];
        
        //NSComparisonResult result = ;
        
        if(([textfieldForUserName.text isEqualToString:stringForUserName]) && ([textfieldForFirstName.text isEqualToString:stringForFirstName]) && ([textfieldForLastName.text isEqualToString:stringForLastName ])&& ([textfieldForTitle.text isEqualToString:stringForTitle ]) &&
           ([textfieldForCompany.text isEqualToString:stringForCompany ]) &&
           ([textfieldForEmail.text isEqualToString:stringForEmail ])&&
           ([textfieldForDigits.text isEqualToString:stringForDigits ])&& [innerText isEqualToString:previousHtml])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showExitAlert];
        }
    }
    else
    {
        [self showExitAlert];
        
    }
}

-(void)showExitAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Do you want to save changes?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self handelYesButtonAction];
                                       
                                   }];
        [alertVC addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self handelNoButtonAction];
                                       }];
        
        [alertVC addAction:cancelAction];
        
        
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    else
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to save changes?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
//        [alert show];
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 6)
//    {
//        if(buttonIndex == 0)
//        {
//            [self addRotateView];
//        }
//    }
//    if (alertView.tag == 3)
//    {
//        if (buttonIndex==1)
//        {
//            [self handelBrowseImage:nil];
//        }
//    }
//    else if (alertView.tag == 4)
//    {
//        if (buttonIndex == 1)
//        {
//            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
//            imgPicker.editing=YES;
//            imgPicker.delegate=self;
//            imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//            pickerTypes = videoImage;
//            [self presentViewController:imgPicker animated:YES completion:nil];
//            self.navigationController.navigationBar.frame=CGRectMake(0, 20, SCREEN_WIDTH, 45);
//        }
//    }
//    else
//    {
//        if (buttonIndex == 0)
//        {
//            [self handelYesButtonAction];
//        }
//        else
//        {
//            [self handelNoButtonAction];
//        }
//    }
//}

-(void)handelYesButtonAction
{
    if (cancelButtonClick)
    {
        cancelButtonClick=NO;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        UIButton *btn=[[UIButton alloc]init];
        [self handelSave:btn];
    }
}
-(void)handelNoButtonAction
{
    if (cancelButtonClick)
    {
        cancelButtonClick=NO;
    }
    else
    {
        cancelButtonClick=NO;
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)checkForhtmlMessage
{
    NSMutableString *htmlMessage= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
    
    htmlMessageText = nil;
    NSRange start = [htmlMessage rangeOfString:@">"];
    if (start.location != NSNotFound)
    {
        htmlMessageText = [htmlMessage substringFromIndex:start.location + start.length];
        NSRange end = [htmlMessageText rangeOfString:@"</body>"];
        if (end.location != NSNotFound)
        {
            htmlMessageText = [htmlMessageText substringToIndex:end.location];
        }
    }
    myStr=[self stripTags:htmlMessageText];
    myStr=[myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
}
-(NSString *)convertHTML:(NSString *)html
{
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
   
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

-(IBAction)handelSave:(UIButton *)sender
{
    [currentTextField resignFirstResponder];
    if([self checkTextfield])
    {
        if([isEditingMyProfile isEqualToString:@"Yes"])
        {
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self callSaveEditContactProfileWebService];
            });
            
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
                [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
                
                if (serviceIntegration != nil)
                {
                    serviceIntegration = nil;
                }
                serviceIntegration = [[ServerIntegration alloc]init];
                
                [serviceIntegration CheckUserExistWebService:self UserId:CURRENT_USER_ID UserName:textfieldForUserName.text :@selector(receivedResponseDataContactExistProf:)];
            }
        }
    }
}
#pragma mark - Service IntegrationDelegate

- (void)receivedResponseDataContactExistProf:(NSDictionary *)responseDict
{
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self callSaveEditContactProfileWebService];
        });
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(IBAction)handleDeleteBtn:(id)sender
{
    [noFileChoosen setHidden:NO];
    imageViewForImage.image = [UIImage imageNamed:@"default_profile_img.png"];
}

-(IBAction)handleDeleteVideoBtn:(id)sender
{
    isVideoDeleted = YES;
    isImageSelctedFOrVideo = @"No";
    [noFileChoosenVideo setHidden:NO];
    placeholderImageVdo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
}

-(void)deleteVideoFromServer
{
    if([isEditingMyProfile isEqualToString:@"Yes"])
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
            
            [serviceIntegration deletePhotoAndVideoFromProfile:self UserId:CURRENT_USER_ID ProfileTypeId:@"2" :@selector(receivedResponseForDeleteVideoAndImageForProfile:)];
        }
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
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
            
            if (serviceIntegration != nil)
            {
                serviceIntegration = nil;
            }
            serviceIntegration = [[ServerIntegration alloc]init];
            
            [serviceIntegration deletePhotoAndVideoFromProfile:self contactId:[[editProfessionalProfileArray objectAtIndex:0] valueForKey:@"ContactId"] :@selector(receivedResponseForDeleteVideoAndImageForContactProfile:)];
        }
        
    }
}

-(void)receivedResponseForDeleteVideoAndImageForProfile:(NSDictionary*)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [noFileChoosenVideo setHidden:NO];
        placeholderImageVdo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
        videoData = [[NSData alloc]init];
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
    
}


-(void)receivedResponseForDeleteVideoAndImageForContactProfile:(NSDictionary*)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [noFileChoosenVideo setHidden:NO];
        placeholderImageVdo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
        videoData = [[NSData alloc]init];
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
    
}


-(BOOL)checkTextfield
{
    
    if(textfieldForEmail.text.length ==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Email Id is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
    if(textfieldForUserName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"User Name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
    if(textfieldForDigits.text.length > 0 && textfieldForDigits.text.length < 10)
    {
        [SVProgressHUD showErrorWithStatus:@"Phone number must be 10 digits" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForMobile.text.length > 0 && textfieldForMobile.text.length < 10)
    {
        [SVProgressHUD showErrorWithStatus:@"Mobile number must be 10 digits" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForWorkNumber.text.length > 0 && textfieldForWorkNumber.text.length < 10)
    {
        [SVProgressHUD showErrorWithStatus:@"Work number must be 10 digits" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isvalidEmil = [emailTest evaluateWithObject:textfieldForEmail.text];
    
    if(isvalidEmil == NO)
    {
        [SVProgressHUD showErrorWithStatus:@"Enter valid email" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
    if(textfieldForEmail.text.length > 50)
    {
        [SVProgressHUD showErrorWithStatus:@"Email Id must be less than 50 characters" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForFirstName.text.length > 25)
    {
        [SVProgressHUD showErrorWithStatus:@"First name must be less than 25 characters" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForCompany.text.length > 30)
    {
        [SVProgressHUD showErrorWithStatus:@"Company name must be less than 30 characters" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForTitle.text.length > 30)
    {
        [SVProgressHUD showErrorWithStatus:@"Title must be less than 30 characters" maskType:SVProgressHUDMaskTypeBlack ];
        return NO;
    }
    if(textfieldForCompany.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Company name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForLastName.text.length > 25)
    {
        [SVProgressHUD showErrorWithStatus:@"Last name must be less than 25 characters" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForFirstName.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"First name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForLastName.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Last name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForTitle.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"Title is required" maskType:SVProgressHUDMaskTypeBlack ];
        return NO;
    }

    if(textFieldForState.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"State name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(self.textFieldForCity.text.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"City name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    NSMutableString *innerText= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"]];
    if(innerText.length > 250)
    {
        
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"You are %d characters over the 250 character limit",(int)innerText.length-250] maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
    if((textFieldForState.text.length == 0) & (self.textFieldForCity.text.length == 0) & (textfieldForTitle.text.length == 0) & (textfieldForCompany.text.length == 0) & (textfieldForLastName.text.length > 25) & (textfieldForFirstName.text.length == 0) & (textfieldForEmail.text.length ==0))
    {
        [SVProgressHUD showErrorWithStatus:@"Enter all required Fields" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
       return YES;
}

- (void)showInsertURLAlternatePicker
{
    [self dismissAlertView];
}


- (void)showInsertImageAlternatePicker
{
    
    [self dismissAlertView];
    
    //    ZSSDemoPickerViewController *picker = [[ZSSDemoPickerViewController alloc] init];
    //    picker.demoView = self;
    //    picker.isInsertImagePicker = YES;
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    //    nav.navigationBar.translucent = NO;
    //    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark==Navigate to home view
-(IBAction)handelBrowseImage:(UIButton*)sender
{
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    imgPicker.editing=YES;
    imgPicker.delegate=self;
    imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    if (sender.tag == 0 && sender !=nil)
    {
        pickerTypes = image;
    }
    else
    {
        pickerTypes = video;
        imgPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        imgPicker.videoMaximumDuration = 30;
        imgPicker.allowsEditing = NO;
    }
    [self presentViewController:imgPicker animated:YES completion:nil];
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, SCREEN_WIDTH, 45);
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (pickerTypes == image)
    {
        isImageChanged = @"Yes";
        [picker dismissViewControllerAnimated:YES completion:nil];
        imageViewForImage.image=[Parameters scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] maxSize:700];
        [noFileChoosen setHidden:YES];
    }
    else if(pickerTypes == video)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.movie"]){
            //            NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"] relativePath];
            videoUrl =  [info objectForKey:UIImagePickerControllerMediaURL];
            //            AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:videoUrl options:nil];
            //            CMTime duration = sourceAsset.duration;
            NSData * movieData = [NSData dataWithContentsOfURL:[info objectForKey:UIImagePickerControllerMediaURL]];
            NSLog(@"%.2f",(float)movieData.length/1024.0f/1024.0f);
            float number = [[NSString stringWithFormat:@"%.2f",(float)movieData.length/1024.0f/1024.0f] floatValue];
            //            float seconds = CMTimeGetSeconds(duration);
            if (number > 35.0) {
                if (IS_IOS8)
                {
                    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Maximum file size exceeds 35 mb,try again?" preferredStyle:UIAlertControllerStyleAlert];
                    
                    
                    
                    UIAlertAction *okAction = [UIAlertAction
                                               actionWithTitle:@"YES"
                                               style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction *action)
                                               {
                                                   [self handelBrowseImage:nil];
                                               }];
                    [alertVC addAction:okAction];
                    
                    UIAlertAction *cancelAction = [UIAlertAction
                                                   actionWithTitle:@"NO"
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
                    UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Maximum file size exceeds 35 mb,try again?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                    alrt.tag = 3;
                    [alrt show];
                }
            }
            else
            {
                videoStringPath = [[NSString alloc]init];
                [noFileChoosenVideo setHidden:YES];
                isVideoDeleted = NO;
                isVideoChanged = YES;
                videoStringPath = [NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerMediaURL]];
                videoStringPath = [self getaVideoPath:videoStringPath];
                videoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoStringPath]];
                placeholderImageVdo.image = [self getimagefromUrl:[info objectForKey:UIImagePickerControllerMediaURL]];
                [self hideShowPlayVideoButton];
                [self videoUploaded];
            }
        }
    }
    else if (pickerTypes == videoImage)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
        isImageSelctedFOrVideo = @"Yes";
        isVideoImage=@"Yes";
        placeholderImageVdo.image=[Parameters scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] maxSize:480];
    }
}

-(UIImage*)getimagefromUrl:(NSURL*)url
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

-(NSString*)getaVideoPath:(NSString*)path
{
   
    NSData *videoData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoStringPath]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *uniqueString = [CommonNotification createRandomName];
    NSString *videopath= [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@.mov",documentsDirectory,uniqueString]];
    success = [videoData1 writeToFile:videopath atomically:NO];
    NSLog(@"video path --> %@",videopath);
    return videopath;
}

-(IBAction)playVideoButtonClicked:(id)sender
{
    
    moviePlayer =  [[MPMoviePlayerController alloc]
                    initWithContentURL:[NSURL URLWithString:videoStringPath]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];
    
    [[moviePlayer view] setFrame:[[self view] bounds]];
    moviePlayer.controlStyle = MPMovieControlStyleDefault;
    moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:moviePlayer.view];
    [moviePlayer setFullscreen:YES animated:YES];
}

-(void)doneButtonClick:(NSNotification*)aNotification{
    MPMoviePlayerController *player = [aNotification object];
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerWillExitFullscreenNotification
     object:player];
    
    if ([player respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}


-(void)addvideoPlayerOnView:(NSString*)urlString
{
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)exportHTML {
    
    //NSLog(@"%@", [self getHTML]);
    
}

#pragma mark - Service IntegrationDelegate
-(void)callSaveEditContactProfileWebService
{
    
    NSMutableString *htmlMessage= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
    
    addressText = [[NSMutableString alloc]init];
    
    if (self.textfieldForAddress1.text.length > 0 || self.textfieldForAddress2.text.length > 0 )
    {
        if (self.textfieldForAddress1.text.length > 0)
        {
            [addressText appendFormat:@"%@\n",self.textfieldForAddress1.text];
        }
        else
        {
            [addressText appendString:@"Address1\n"];
        }
        
        if (self.textfieldForAddress2.text.length > 0)
        {
            [addressText appendFormat:@"%@\n",self.textfieldForAddress2.text];
        }
        else
        {
            [addressText appendString:@"Address2\n"];
        }
        
        if (textFieldForCity.text.length > 0 & textFieldForState.text > 0)
        {
            NSString *str = [NSString stringWithFormat:@"%@, %@ %@",textFieldForCity.text,textFieldForState.text,textFieldForZipCode.text];
            [addressText appendFormat:@"%@",str];
        }
        else
        {
            [addressText appendString:@"Address3"];
        }
    }

        locationText = [[NSMutableString alloc] initWithString:textFieldForState.text];
        [locationText appendFormat:@" %@", textFieldForState.text];
        NSLog(@"%@",locationText);
    
    htmlMessageText = nil;
    NSRange start = [htmlMessage rangeOfString:@">"];
    if (start.location != NSNotFound)
    {
        htmlMessageText = [htmlMessage substringFromIndex:start.location + start.length];
        NSRange end = [htmlMessageText rangeOfString:@"</body>"];
        if (end.location != NSNotFound)
        {
            htmlMessageText = [htmlMessageText substringToIndex:end.location];
        }
    }
    htmlMessageText=[self replaceHTMLEntitiesInString:htmlMessageText];
    htmlMessageText = [Parameters encodeDataForEmogies:htmlMessageText];
    
    
    // Download Images if not
    if(!self.imageViewForImage.image){
        NSString *urlStr = [NSString stringWithFormat:@"%@",[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileImageName"]];
        if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
        {
            NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            self.imageViewForImage.image = [[UIImage alloc]initWithData:data];
        }
    }
    
    //compare is image Change
    UIImage *secondImage = [UIImage imageNamed:@"default_profile_img.png"];
    
    NSData *imgData1 = UIImagePNGRepresentation(imageViewForImage.image);
//    NSData *imgData1 = UIImagePNGRepresentation([UIImage imageNamed:@"icon_with_oborder.png"]);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    
    
    NSLog(@"%d",status);
    
    BOOL isCompare =  [imgData1 isEqualToData:imgData2];
    if([isEditingMyProfile isEqualToString:@"Yes"])
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
            
            if(isCompare)
            {
                
                [serviceIntegration UpdateLogInUserProfile:self UserName:self.textfieldForUserName.text FirstName:textfieldForFirstName.text.length > 0 ? textfieldForFirstName.text : @"" LastName:textfieldForLastName.text.length > 0 ? textfieldForLastName.text:@"" EmailId:textfieldForEmail.text.length > 0 ? textfieldForEmail.text: @"" PhoneNumber:textfieldForDigits.text.length > 0 ? textfieldForDigits.text : @"" UserNotes:htmlMessageText UserTitle:textfieldForTitle.text UserCompany:textfieldForCompany.text.length > 0 ? textfieldForCompany.text:@"" UserAddress:addressText ProfileImageName:@"profile" Image:nil ProfileTypeId:@"2" UserId:CURRENT_USER_ID MobileNumber:textfieldForMobile.text.length > 0 ? textfieldForMobile.text : @"" WorkNumber:textfieldForWorkNumber.text.length > 0 ? textfieldForWorkNumber.text : @"" isImageChanged:isImageChanged state:textFieldForState.text.length > 0 ? textFieldForState.text : @"" city:self.textFieldForCity.text.length > 0 ? self.textFieldForCity.text : @"" location:locationText IsPublic:status Occupation:@"" :@selector(receivedResponseDataUpdateProfessionalProfile:)];
                
            }
            else
            {
                 [serviceIntegration UpdateLogInUserProfile:self UserName:self.textfieldForUserName.text FirstName:textfieldForFirstName.text.length > 0 ? textfieldForFirstName.text : @"" LastName:textfieldForLastName.text.length > 0 ? textfieldForLastName.text : @"" EmailId:textfieldForEmail.text.length > 0 ? textfieldForEmail.text: @"" PhoneNumber:textfieldForDigits.text.length > 0 ? textfieldForDigits.text : @"" UserNotes:htmlMessageText UserTitle:textfieldForTitle.text UserCompany:textfieldForCompany.text.length > 0 ? textfieldForCompany.text: @"" UserAddress:addressText ProfileImageName:@"profile" Image:imageViewForImage.image ProfileTypeId:@"2" UserId:CURRENT_USER_ID MobileNumber:textfieldForMobile.text.length > 0 ? textfieldForMobile.text : @"" WorkNumber:textfieldForWorkNumber.text.length > 0 ? textfieldForWorkNumber.text : @"" isImageChanged:isImageChanged state:textFieldForState.text.length > 0 ? textFieldForState.text : @"" city:self.textFieldForCity.text.length > 0 ? self.textFieldForCity.text : @"" location:locationText IsPublic:status Occupation:@"" :@selector(receivedResponseDataUpdateProfessionalProfile:)];
            }
            isImageChanged = @"No";
        }
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
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
            
            if (serviceIntegration != nil)
            {
                serviceIntegration = nil;
            }
            serviceIntegration = [[ServerIntegration alloc]init];
            
            if(isCompare)
            {
                [serviceIntegration AddContactWebService:self UserId:CURRENT_USER_ID ContactId:[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ContactId"] UserName:textfieldForUserName.text.length > 0 ? textfieldForUserName.text : @"" FirstName:textfieldForFirstName.text.length > 0 ? textfieldForFirstName.text : @"" LastName:textfieldForLastName.text.length > 0 ? textfieldForLastName.text : @"" Message:htmlMessageText ImageName:@"profile" Image:nil PhoneNumber:textfieldForDigits.text.length > 0 ? textfieldForDigits.text : @"" emailId:textfieldForEmail.text.length > 0 ? textfieldForEmail.text: @"" userNotes:htmlMessageText userCompany:textfieldForCompany.text.length > 0 ? textfieldForCompany.text: @"" userTitle:textfieldForTitle.text.length > 0 ? textfieldForTitle.text: @"" userAddress:addressText profileId:profileId MobileNumber:textfieldForMobile.text.length > 0 ? textfieldForMobile.text : @"" WorkNumber:textfieldForWorkNumber.text.length > 0 ? textfieldForWorkNumber.text : @"" isImageChanged:isImageChanged state:textFieldForState.text.length > 0 ? textFieldForState.text : @"" city:self.textFieldForCity.text.length > 0? textFieldForCity.text : @"" location:locationText IsPublic:status Occupation:textfieldForOccupation.text.length > 0 ? textfieldForOccupation.text : @"" profileType:profileId ? @"1" : @"2" :@selector(receivedResponseDataAddContactProf:)];
            }
            else
            {
                
                [serviceIntegration AddContactWebService:self UserId:CURRENT_USER_ID ContactId:[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ContactId"] UserName:textfieldForUserName.text.length > 0 ? textfieldForUserName.text : @"" FirstName:textfieldForFirstName.text.length > 0 ? textfieldForFirstName.text : @"" LastName:textfieldForLastName.text.length > 0 ? textfieldForLastName.text : @"" Message:htmlMessageText ImageName:@"profile" Image:imageViewForImage.image PhoneNumber:textfieldForDigits.text.length > 0 ? textfieldForDigits.text : @"" emailId:textfieldForEmail.text.length > 0 ? textfieldForEmail.text: @"" userNotes:htmlMessageText userCompany:textfieldForCompany.text.length > 0 ? textfieldForCompany.text: @"" userTitle:textfieldForTitle.text.length > 0 ? textfieldForTitle.text: @"" userAddress:addressText profileId:profileId MobileNumber:textfieldForMobile.text.length > 0 ? textfieldForMobile.text : @"" WorkNumber:textfieldForWorkNumber.text.length > 0 ? textfieldForWorkNumber.text : @"" isImageChanged:isImageChanged state:textFieldForState.text.length > 0 ? textFieldForState.text : @"" city:self.textFieldForCity.text.length > 0? textFieldForCity.text : @"" location:locationText IsPublic:status Occupation:textfieldForOccupation.text.length > 0 ? textfieldForOccupation.text : @"" profileType:profileId ? @"1" : @"2" :@selector(receivedResponseDataAddContactProf:)];
            }
            isImageChanged = @"No";
        }
    }
}


-(void)uploadVideoOnServer
{
    
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDeleagated.internetStatus==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        if(isVideoChanged == YES)
        {
            NSData* videoUrlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoStringPath]];
            if (videoUrlData !=nil) {
                videoData = videoUrlData;
            }
        }
        else
        {
            videoData = nil;
        }
        [self postvideo:videoData];
    }
}

-(void)receivedResponseDataUpdateProfessionalProfile:(NSDictionary *)responseDict
{
    NSLog(@"%@",responseDict);
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        CURRENT_USER_IMAGE= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"image"]];
        
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        if (videoStringPath !=nil && ![videoStringPath isEqual: [NSNull null]] && videoStringPath.length > 0 && ![videoStringPath isEqualToString:@""]) {
            [self uploadVideoOnServer];
        }
        
        //        else if (isVideoDeleted) {
        //            [self deleteVideoFromServer];
        //        }
        else{
            [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)moveToHome
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
}

-(void)receivedResponseDataAddContactProf:(NSDictionary *)responseDict
{
    
    //NSLog(@"%@",responseDict);
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        NSString *string = [responseDict valueForKey:@"Message"];
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        NSLog(@"%@",videoStringPath);
        
       
            if (videoStringPath !=nil && ![videoStringPath isEqual: [NSNull null]] && videoStringPath.length > 0 && ![videoStringPath isEqualToString:@""]) {
                [self uploadVideoOnServer];
            }else{
            [self performSelector:@selector(popTOBack) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
            }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)popTOBack
{
    [Parameters popToViewControllerNamed:@"ContactViewController" from:self];
}
- (NSString *)replaceHTMLEntitiesInString:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"%26"];
    
    return str;
}

- (NSString *)stripTags:(NSString *)str
{
    NSMutableString *html = [NSMutableString stringWithCapacity:[str length]];
    
    NSScanner *scanner = [NSScanner scannerWithString:str];
    scanner.charactersToBeSkipped = NULL;
    NSString *tempText = nil;
    
    while (![scanner isAtEnd])
    {
        [scanner scanUpToString:@"<" intoString:&tempText];
        
        if (tempText != nil)
            [html appendString:tempText];
        
        [scanner scanUpToString:@">" intoString:NULL];
        
        if (![scanner isAtEnd])
            [scanner setScanLocation:[scanner scanLocation] + 1];
        
        tempText = nil;
    }
    
    return html;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
    [currentTextField resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark == textview delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [Parameters moveTextViewUpForView:scrollviewObj forTextView:textView forSubView:scrollviewObj];
    if ([textView.text isEqualToString:defaultText])
    {
        textView.text=@"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [Parameters moveTextViewDownforView:scrollviewObj];

    if ([textView.text isEqualToString:@""])
    {
        textView.text=defaultText;
        textView.textColor = [UIColor colorWithRed:187.0f/255.0f green:187.0f/255.0f blue:187.0f/255.0f alpha:0.70];

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


#pragma mark - Phone Number Field Formatting

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 7777 || textField.tag == 666 || textField.tag == 444)
    {
        NSUInteger length = [Parameters getLength:textField.text];
        
        if(length == 10) {
            if(range.length == 0)
                return NO;
        }
        
        if(length == 3) {
            NSString *num = [Parameters formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) ",num];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"%@",[num substringToIndex:3]];
        }
        else if(length == 6) {
            NSString *num = [Parameters formatNumber:textField.text];
            textField.text = [NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]];
            if(range.length > 0)
                textField.text = [NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]];
        }
    }
    else if (textField.tag == 311 || textField.tag == 312 || textField.tag == 313)
    {
        if (textField.text.length >= 29 && range.length == 0)
            return NO;
    }
    
    return YES;
}

-(void)postvideo:(NSData*)uploadVideo
{
    NSString *uniqueString;
    NSString *videoFileName;
    
    if(isVideoChanged){
        uniqueString = [CommonNotification createRandomName];
        videoFileName = [NSString stringWithFormat:@"%@%@",@"i",uniqueString];
    }
    else{
         NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileVideo"]];
        NSArray *arrayWithTwoStrings = [videoImageStr componentsSeparatedByString:@"Video/"];
        videoFileName = [arrayWithTwoStrings objectAtIndex:1];
    }
    NSString *urlString;
    if([isEditingMyProfile isEqualToString:@"Yes"])
    {
        if(isVideoChanged){
        urlString = [NSString stringWithFormat:@"%@%@UserId=%@&typeId=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadVideoFile,CURRENT_USER_ID,@"2", videoFileName,@"true"];
        }
        else{
            urlString = [NSString stringWithFormat:@"%@%@UserId=%@&typeId=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadVideoFile,CURRENT_USER_ID,@"2", videoFileName,@"false"];
        }
    }
    else
    {
        if(isVideoChanged){
            urlString = [NSString stringWithFormat:@"%@%@contact_id=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadProfileVideoContact,[[editProfessionalProfileArray objectAtIndex:0] valueForKey:@"ContactId"],videoFileName,@"true"];
        }
        else{
             urlString = [NSString stringWithFormat:@"%@%@contact_id=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadProfileVideoContact,[[editProfessionalProfileArray objectAtIndex:0] valueForKey:@"ContactId"],videoFileName,@"false"];
        }
    }
    
    
       
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:150];
    [request setHTTPMethod:@"POST"];
    NSString *boundary = @"+++++ABck";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];[request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",videoFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: video/quicktime\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];//video/quicktime for .mov format
    //    NSLog(@"Video Data In prof beforAttch to body : %@ ",uploadVideo);
    [body appendData:[NSData dataWithData:uploadVideo]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLResponse *response;
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:&error];
    
    NSLog(@"videoUpload=%@",responseDict);
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        
        CURRENT_USER_Video= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"video"]];
        
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        
        //compare is image Change
        UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
        NSData *imgData1 = UIImagePNGRepresentation(placeholderImageVdo.image);
        NSData *imgData2 = UIImagePNGRepresentation(secondImage);
        BOOL isCompareImage =  [imgData1 isEqual:imgData2];
        
        if (isVideoDeleted)
        {
            [self deleteVideoFromServer];
        }
        else
        {
            if (!isCompareImage)
            {
                [self uploadVideoImage];
            }
            else
            {
                [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
            }
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)videoUploaded
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Do you want to pick a photo for your video" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
                                       imgPicker.editing=YES;
                                       imgPicker.delegate=self;
                                       imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                                       pickerTypes = videoImage;
                                       [self presentViewController:imgPicker animated:YES completion:nil];
                                       self.navigationController.navigationBar.frame=CGRectMake(0, 20, SCREEN_WIDTH, 45);
                                   }];
        [alertVC addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
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
//        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to pick a photo for your video" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
//        alrt.tag = 4;
//        [alrt show];
    }
}


-(void)uploadVideoImage
{
    if(!placeholderImageVdo.image){
        NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[editProfessionalProfileArray objectAtIndex:0]valueForKey:@"ProfileVideoImage"]];
        if (videoImageStr!=nil && videoImageStr.length > 0 && ![videoImageStr isEqualToString:@"<null>"]) {
            NSURL *url1 = [NSURL URLWithString:[videoImageStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            NSData *data = [NSData dataWithContentsOfURL:url1];
            placeholderImageVdo.image = [[UIImage alloc]initWithData:data];
        }
    }
    
    //compare is image Change
    UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
    NSData *imgData1 = UIImagePNGRepresentation(placeholderImageVdo.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompareImage =  [imgData1 isEqual:imgData2];
    
    if([isEditingMyProfile isEqualToString:@"Yes"])
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
            
            NSString *uniqueString = [CommonNotification createRandomName];
            NSString *videoImageFileName = [NSString stringWithFormat:@"%@%@",@"videoImage_",uniqueString];
            
            if(isCompareImage)
            {
                [serviceIntegration uploadVideoImage:self UserId:CURRENT_USER_ID ProfileTypeId:@"2" ProfileVideoImageName:videoImageFileName videoImage:nil isImageChanged:isVideoImage :@selector(receivedResponseDataForVideoImageUpload:)];
             
                
            }
            else
            {
                [serviceIntegration uploadVideoImage:self UserId:CURRENT_USER_ID ProfileTypeId:@"2" ProfileVideoImageName:videoImageFileName videoImage:placeholderImageVdo.image isImageChanged:isVideoImage :@selector(receivedResponseDataForVideoImageUpload:)];
            
            }
            
        }
           isVideoImage = @"No";
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
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
            
            if (serviceIntegration != nil)
            {
                serviceIntegration = nil;
            }
            serviceIntegration = [[ServerIntegration alloc]init];
            
            NSString *uniqueString = [CommonNotification createRandomName];
            NSString *videoImageFileName = [NSString stringWithFormat:@"%@%@",@"videoImage_",uniqueString];
            
            if(isCompareImage)
            {
                [serviceIntegration uploadVideoImageINContact:self contactId:[[editProfessionalProfileArray objectAtIndex:0] valueForKey:@"ContactId"] ProfileVideoImageName:videoImageFileName videoImage:nil isImageChanged:isVideoImage :@selector(receivedResponseDataForVideoImageUploadInContact:)];
   
                
            }
            else
            {//tanvi
                [serviceIntegration uploadVideoImageINContact:self contactId:[[editProfessionalProfileArray objectAtIndex:0] valueForKey:@"ContactId"] ProfileVideoImageName:videoImageFileName videoImage:placeholderImageVdo.image isImageChanged:isVideoImage :@selector(receivedResponseDataForVideoImageUploadInContact:)];
              
            }
            isVideoImage=@"No";
        }
    }
}


-(void)receivedResponseDataForVideoImageUpload:(NSDictionary *)responseDictionary
{
    NSLog(@"VideoImage=%@",responseDictionary);
    
    if ([[responseDictionary valueForKey:@"success" ]isEqualToString:@"true"])
    {
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        if (isVideoDeleted) {
            [self deleteVideoFromServer];
        }
        else
        {
            [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDictionary valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}



//VideoImage pload contact
-(void)receivedResponseDataForVideoImageUploadInContact:(NSDictionary *)responseDictionary
{
    NSLog(@"VideoImage=%@",responseDictionary);
    
    if ([[responseDictionary valueForKey:@"success" ]isEqualToString:@"true"])
    {
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        if (isVideoDeleted) {
            [self deleteVideoFromServer];
        }
        else
        {
            [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDictionary valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}



-(void)hideShowPlayVideoButton
{
    UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
    NSData *imgData1 = UIImagePNGRepresentation(placeholderImageVdo.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    
    if (isCompare) {
        [noFileChoosenVideo setHidden:NO];
    }
    else
    {
        [noFileChoosenVideo setHidden:YES];
    }
    
}
-(BOOL)checkImageOrentataded:(UIImage *)image{
    
    if (image.imageOrientation == UIImageOrientationUp)
    {
        return NO;
    }
    return YES;
}


#pragma mark == for roate image

-(IBAction)handleRotateButton:(UIButton *)sender
{
    
    //compare is image Change
    UIImage *secondImage;
    selectedImageTag = sender.tag;
    if(selectedImageTag == 1){
        selectedImageToRotate = imageViewForImage.image;
        secondImage = [UIImage imageNamed:@"default_profile_img.png"];
    }
    else{
        
        if([isImageSelctedFOrVideo isEqualToString:@"Yes"]){
            selectedImageToRotate = placeholderImageVdo.image;
            secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
        }
        else{
            selectedImageToRotate = nil;
        }
    }
    
    NSData *imgData1 = UIImagePNGRepresentation(selectedImageToRotate);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    if(!isCompare){
        
        if(selectedImageToRotate != nil){
            if (IS_IOS8)
            {
                UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Do you want to rotate image?" preferredStyle:UIAlertControllerStyleAlert];
                   UIAlertAction *okAction = [UIAlertAction
                                           actionWithTitle:@"Yes"
                                           style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action)
                                           {
                                               [self dismissViewControllerAnimated:YES completion:nil];
                                               
                                               [self addRotateView];
                                               
                                           }];
                [alertVC addAction:okAction];
                
                UIAlertAction *cancelAction = [UIAlertAction
                                               actionWithTitle:@"No"
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
//                UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to rotate image?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
//                alrt.tag = 6;
//                [alrt show];
            }
        }
    }
}
-(void)addRotateView
{
    rotateView.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height+40)/2);
    rotateView.layer.cornerRadius = 3.0;
    rotateImageView.image=selectedImageToRotate;
    self.view.alpha = 0.3;
    [self.view.window addSubview:rotateView];
}

-(IBAction)rotateImage:(id)sender
{
    UIImage *originalImage = [Parameters rotateImage:selectedImageToRotate byDegree:90];
    rotateImageView.image = originalImage;
    selectedImageToRotate =originalImage;
}

-(IBAction)saveImage:(id)sender
{
    self.view.alpha = 1;
    if(selectedImageTag == 1)
    {
        imageViewForImage.image=rotateImageView.image;
    }
    else{
        placeholderImageVdo.image=rotateImageView.image;
    }
    
    [rotateView removeFromSuperview];
}
-(IBAction)cancleImage:(id)sender
{
    self.view.alpha = 1;
    [rotateView removeFromSuperview];
}

- (IBAction)publicStatusAction:(id)sender
{
    if(self.publicStatusBtn.tag == 1)
    {
        status = 1;
        self.publicStatusBtn.tag = 0;
        [self.publicStatusBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
    }
    else
    {
        
        self.publicStatusBtn.tag = 1;
        [self.publicStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];

    }
    self.privateStatusBtn.tag = 1;
    [self.privateStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
}

- (IBAction)privateStatusAction:(id)sender
{
    if(self.privateStatusBtn.tag == 0)
    {
        self.privateStatusBtn.tag = 1;
        [self.privateStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
    }
    else
    {
        status = 0;
        self.privateStatusBtn.tag = 0;
        [self.privateStatusBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
        
    }
    self.publicStatusBtn.tag = 1;
    [self.publicStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
}

#pragma mark Handle State , City and Zip Code list

- (IBAction)handleStateBtn:(UIButton *)sender
{
    searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    searchVC.editProfessionalVC=self;
    searchVC.title = @"State";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (IBAction)handleCityBtn:(UIButton *)sender
{
    searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    searchVC.editProfessionalVC = self;
    searchVC.title = @"City";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (IBAction)handleZipBtn:(UIButton *)sender
{
    searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    searchVC.editProfessionalVC = self;
    searchVC.title = @"Zip Code";
    //self.cityId = @"0";
    //self.stateId = @"0";
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (IBAction)handleCancelBtnForSCZ:(UIButton *)sender
{
    UIButton *btn=(UIButton *)sender;
    if (btn.tag==100)
    {
        textFieldForState.text=@"";
        self.stateId=@"";
        [cancelStateBtn setHidden:YES];
    }
    if (btn.tag==200)
    {
        textFieldForCity.text=@"";
        self.cityId=@"";
        [cancelCityBtn setHidden:YES];
    }
    if (btn.tag==300)
    {
        textFieldForZipCode.text=@"";
        self.zipCodeId=@"";
        [cancelZipCodeBtn setHidden:YES];
    }
}


@end


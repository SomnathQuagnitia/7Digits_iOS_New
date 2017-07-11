//
//  ZSSDemoViewController.m
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "AddContactViewController.h"
#import "PreviewPostViewController.h"
#import "MenuViewController.h"
#import "ZSSRichTextEditor.h"
#import "Constant.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AddContactViewController ()

@end

@implementation AddContactViewController
@synthesize textfieldForUserName,textfieldForFirstName,textfieldForLastName,textfieldForDigits,textfieldForEmail,dataForEditContactArray,imageViewForImage,addContactVCId,isEditingMyProfile,placeholderImageVdo,videoStringPath,textFieldForOccupation;

@synthesize videoImageFromBack;
@synthesize userImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.publicStatusBtn.tag = 1;
    self.privateStatusBtn.tag = 0;
    isProfileDataSet = @"No";
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    
    videoStringPath = [[NSString alloc]init];
    uploadVideoData = [[NSData alloc]init];
    
    isImageSelctedFOrVideo = @"No";
    isVideoIMage=@"No";
    if ([stringForTitle isEqualToString:@"Update Contact"])
    {
           }
    else
    {
        //        self.title=@"Add Contact";
    }
    self.title=@"Personal Profile";
    // HTML Content to set in the editor
    NSString *html1 = @"";
    
    
    
    // Set the base URL if you would like to use relative links, such as to images.
    self.baseURL = [NSURL URLWithString:@"http://www.google.com"];
    
    // If you want to pretty print HTML within the source view.
    self.formatHTML = YES;
    
    
    [self setHtml:html1];
    
    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    
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
    [Parameters addPaddingView:textfieldForEmail];
    [Parameters addPaddingView:textfieldForDigits];
    [Parameters addPaddingView:textFieldForOccupation];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([isProfileDataSet isEqualToString:@"No"]){
        isProfileDataSet = @"Yes";
        [self setUpViewData];
    }
    [SVProgressHUD dismiss];
}
-(void)setUpViewData
{
    NSString *html;
    profileId=@"";
    if([stringForTitle isEqualToString: @"Update Contact"])
    {
        //  if([isEditingMyProfile isEqualToString: @"Yes"]) //for edit personal profile
        //  {
        self.contactProfilVc.addContVc=self;
        
        int checkstatus = [[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"IsPublic"] intValue];
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
        
        textfieldForFirstName.text=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"FirstName"];
        textfieldForLastName.text=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"LastName"];
        textfieldForUserName.text=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"UserName"];
        textfieldForDigits.text=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"PhoneNumber"];
        textfieldForEmail.text =[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"EmailId"];
        profileId=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileId"];
        textFieldForOccupation.text = [[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"Occupation"];
        
        html = [Parameters decodeDataForEmogies:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"UserNotes"]];
        
        self.imageViewForImage.image = userImage;
        placeholderImageVdo.image = videoImageFromBack;
        
        NSString *urlStr = [NSString stringWithFormat:@"%@",[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileImageName"]];
        
        if ([urlStr hasSuffix:@"default_Contact.png"] || [urlStr hasSuffix:@"noimage.png"])
        {
            self.imageViewForImage.image = [UIImage imageNamed:@"default_profile_img.png"];
            [noFileChoosen setHidden:NO];
        }
        else
        {
            
            
            if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
            {
                NSURL *url = [NSURL URLWithString:[urlStr                                    stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
                    if(!self.imageViewForImage.image)
                    {
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                        NSData *data = [NSData dataWithContentsOfURL:url];
                        if (data)
                        {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                self.imageViewForImage.image = [[UIImage alloc]initWithData:data];
                            });
                        }
                    });
                }
                
                [noFileChoosen setHidden:YES];
            }
            else {
                self.imageViewForImage.image = [UIImage imageNamed:@"default_profile_img.png"];
                [noFileChoosen setHidden:NO];
            }
        }
        
        
        NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileVideoImage"]];
        
        if (videoImageStr!=nil && videoImageStr.length > 0 && ![videoImageStr isEqualToString:@"<null>"]) {
            NSURL *url1 = [NSURL URLWithString:[[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileVideoImage"]                                    stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
          
         isImageSelctedFOrVideo=@"Yes";
     
            if(!placeholderImageVdo.image){
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                    NSData *data = [NSData dataWithContentsOfURL:url1];
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
        
        
        NSString *videoUrlStr = [NSString stringWithFormat:@"%@",[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileVideo"]];
        
        if (videoUrlStr!=nil && videoUrlStr.length > 0 && ![videoUrlStr isEqualToString:@"<null>"]) {
            videoUrlStr = [videoUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            isVideoDeletedFromServer = NO;
            videoStringPath = [NSString stringWithFormat:@"%@",videoUrlStr];
            
            //            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //               NSData *videoUrlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoStringPath]];
            //                dispatch_async(dispatch_get_main_queue(), ^{
            //                    if (videoUrlData !=nil) {
            //                        uploadVideoData = videoUrlData;
            //                        NSLog(@"Video Data: %@",uploadVideoData);
            //                    }
            //                });
            //            });
            
            
            /*
             UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
             NSData *imgData1 = UIImagePNGRepresentation(placeholderImageVdo.image);
             NSData *imgData2 = UIImagePNGRepresentation(secondImage);
             BOOL isCompare =  [imgData1 isEqual:imgData2];
             
             if (isCompare) {
             UIImage *placeHolderImage = [CommonNotification loadImage:[NSURL URLWithString:videoUrlStr]];
             placeholderImageVdo.image = placeHolderImage;
             [noFileChoosenVideo setHidden:YES];
             }
             */
        }
        else
        {
            [noFileChoosenVideo setHidden:NO];
        }
        
        
        //        }
        //        else//for edit contact profile
        //        {
        //            self.contactProfilVc.addContVc=self;
        //            textfieldForFirstName.text = [[dataForEditContactArray objectAtIndex:0]valueForKey:@"FirstName"];
        //            textfieldForLastName.text=[[dataForEditContactArray objectAtIndex:0]valueForKey:@"LastName"];
        //            textfieldForUserName.text=[[dataForEditContactArray objectAtIndex:0]valueForKey:@"UserName"];
        //            textfieldForDigits.text =[[dataForEditContactArray objectAtIndex:0] valueForKey:@"PhoneNumber"];
        //            textfieldForEmail.text =[[dataForEditContactArray objectAtIndex:0]valueForKey:@"EmailId"];
        //
        //            html = [[dataForEditContactArray objectAtIndex:0]valueForKey:@"Notes"];
        //
        //            if ([[NSString stringWithFormat:@"%@",[[dataForEditContactArray objectAtIndex:0]valueForKey:@"ContactImage"]] hasSuffix:@"default_Contact.png"])
        //            {
        //                self.imageViewForImage.image = [UIImage imageNamed:@"default_profile_img.png"];
        //            }
        //            else
        //            {
        //                NSURL *url = [NSURL URLWithString:[[[dataForEditContactArray objectAtIndex:0]valueForKey:@"ContactImage"]
        //                                                   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        //                NSData *data = [NSData dataWithContentsOfURL:url];
        //                self.imageViewForImage.image = [[UIImage alloc]initWithData:data];
        //            }
        //
        //        }
        
        //[self.editorView loadHTMLString:[[dataForEditContactArray objectAtIndex:0]valueForKey:@"Notes"] baseURL:nil];
        //[self setHtml:[[dataForEditContactArray objectAtIndex:0]valueForKey:@"Notes"]];
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
    }
    isVideoChanged = NO;
    isImageChanged = @"No";
    [scrollviewObj setContentSize:CGSizeMake(0, 880)];
    [self setToolbarToPhoneNumber];
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
}

-(void)okToolBarBtn
{
    [self.textfieldForDigits resignFirstResponder];
}
-(void)CancleToolBarBtn
{
    [self.textfieldForDigits resignFirstResponder];
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


-(void)handelBackButton
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
    else if([self.title isEqualToString:@"Update Contact"])
    {
        
        NSString *stringForFirstName;
        NSString *stringForLastName;
        NSString *stringForUserName;
        NSString *stringForEmail;
        NSString *stringForDigits;
        NSString *stringForOccupation;
        NSURL *url1;
        NSString *previousHtml;
        
        
        //        if([isEditingMyProfile isEqualToString: @"Yes"]) //for edit personal profile
        //        {
        stringForFirstName=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"FirstName"];
        stringForLastName=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"LastName"];
        stringForUserName=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"UserName"];
        stringForEmail=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"EmailId"];
        stringForDigits=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"PhoneNumber"];
        stringForOccupation=[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"Occupation"];
        
        
        url1 = [NSURL URLWithString:[[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileImageName"]
                                     stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        previousHtml = [self convertHTML:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"UserNotes"]];
        
        
        //Get Image Data
        
        NSData *data = [NSData dataWithContentsOfURL:url1];
        UIImage *previousImage = [UIImage imageWithData:data];
        CGSize test = previousImage.size;
        UIImage *imagw=imageViewForImage.image;
        CGSize test1 = imagw.size;
        
        
        //Get Hml Message
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
        innerText= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"]];
        //NSComparisonResult result = ;
        if(([textfieldForUserName.text isEqualToString:stringForUserName]) && ([textfieldForFirstName.text isEqualToString:stringForFirstName]) && ([textfieldForLastName.text isEqualToString:stringForLastName])&& ([textfieldForEmail.text isEqualToString:stringForEmail])&& ([textfieldForDigits.text isEqualToString:stringForDigits]) && (test.width == test1.width && test.height == test1.height))
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
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return html;
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if(alertView.tag == 6){
//        if(buttonIndex == 0)
//        {
//            [self addRotateView];
//        }
//    }
//    if (alertView.tag == 3) {
//        if (buttonIndex == 1) {
//            [self handelBrowseImage:nil];
//        }
//    }
//    
//    else if (alertView.tag == 4)
//    {
//        if (buttonIndex==1) {
//            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
//            imgPicker.editing=YES;
//            imgPicker.delegate=self;
//            imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//            media = videoimage;
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


-(IBAction)handelSave:(UIButton *)sender
{
    [currentTextField resignFirstResponder];
    if([self checkTextfield])
    {
        if([isEditingMyProfile isEqualToString:@"Yes"])
        {
            [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self addEditContactPersonalProfile];
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
                [serviceIntegration CheckUserExistWebService:self UserId:CURRENT_USER_ID UserName:textfieldForUserName.text :@selector(receivedResponseDataContactExist:)];
            }
        }
    }
}

-(IBAction)handleDeleteBtn:(id)sender
{
    [noFileChoosen setHidden:NO];
    imageViewForImage.image = [UIImage imageNamed:@"default_profile_img.png"];
}

- (IBAction)publicBtnAction:(id)sender
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

- (IBAction)privateBtnAction:(id)sender
{
    
    if(self.privateStatusBtn.tag == 0)
    {
        
        self.privateStatusBtn.tag = 1;
        [self.privateStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
    }
    else
    {
          self.privateStatusBtn.tag = 0;
         status = 0;
        [self.privateStatusBtn setImage:[UIImage imageNamed:@"select_checkboxNew.png"] forState:UIControlStateNormal];
    }
    
    self.publicStatusBtn.tag = 1;
    [self.publicStatusBtn setImage:[UIImage imageNamed:@"unselect_checkbox.png"] forState:UIControlStateNormal];
}

-(IBAction)handleDeleteVideoBtn:(id)sender
{
    isImageSelctedFOrVideo = @"No";
    isVideoDeletedFromServer = YES;
    [noFileChoosenVideo setHidden:NO];
    placeholderImageVdo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
    
}

-(void)videoDeleteFromServer
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
            
            [serviceIntegration deletePhotoAndVideoFromProfile:self UserId:CURRENT_USER_ID ProfileTypeId:@"1" :@selector(receivedResponseForPersonalDeleteVideoAndImageForProfile:)];
        }
    }
    else if([stringForTitle isEqualToString:@"Update Contact"])
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
            
            [serviceIntegration deletePhotoAndVideoFromProfile:self contactId:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"]
                                                              :@selector( receivedResponseForPersonalDeleteVideoAndImageForContactProfile:)];
        }
    }
    else
    {
        [noFileChoosenVideo setHidden:NO];
        placeholderImageVdo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
    }
}

-(void)receivedResponseForPersonalDeleteVideoAndImageForProfile:(NSDictionary*)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        isVideoDeletedFromServer = YES;
        [SVProgressHUD dismiss];
        [noFileChoosenVideo setHidden:NO];
        placeholderImageVdo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
        uploadVideoData = [[NSData alloc]init];
        
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}


-(void)receivedResponseForPersonalDeleteVideoAndImageForContactProfile:(NSDictionary*)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        isVideoDeletedFromServer = YES;
        [SVProgressHUD dismiss];
        [noFileChoosenVideo setHidden:NO];
        placeholderImageVdo.image = [UIImage imageNamed:@"novideo_default_img-2.png"];
        uploadVideoData = [[NSData alloc]init];
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
    
    if(textfieldForUserName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"User Name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    //    if(textfieldForEmail.text.length ==0)
    //    {
    //        return NO;
    //    }
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
    
    if(textfieldForEmail.text.length > 50)
    {
        [SVProgressHUD showErrorWithStatus:@"Email Id must be less than 50 characters" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    
    if(textfieldForEmail.text.length > 0)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        BOOL isvalidEmil = [emailTest evaluateWithObject:textfieldForEmail.text];
        
        if(isvalidEmil == NO){
            [SVProgressHUD showErrorWithStatus:@"Enter valid email" maskType:SVProgressHUDMaskTypeBlack];
            return NO;
        }
    }
    if(textfieldForFirstName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"First Name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForLastName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Last Name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForFirstName.text.length > 25)
    {
        [SVProgressHUD showErrorWithStatus:@"First name must be less than 25 characters" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    if(textfieldForLastName.text.length > 25)
    {
        [SVProgressHUD showErrorWithStatus:@"Last name must be less than 25 characters" maskType:SVProgressHUDMaskTypeBlack];
        
        return NO;
    }
    
    innerText= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"]];
    if(innerText.length > 250)
    {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"You are %lu characters over the 250 character limit",(long)innerText.length-250] maskType:SVProgressHUDMaskTypeBlack];
        
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
        media = pickImage;
    }
    else
    {
        media = pickVideo;
        imgPicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie, nil];
        imgPicker.videoMaximumDuration = 30;
        imgPicker.allowsEditing = NO;
        [placeholderImageVdo setHidden:NO];
    }
    
    [self presentViewController:imgPicker animated:YES completion:nil];
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, SCREEN_WIDTH, 45);
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (media == pickImage)
    {
        isImageChanged = @"Yes";
        [picker dismissViewControllerAnimated:YES completion:nil];
        imageViewForImage.image = [Parameters scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] maxSize:700];
        
        
        [noFileChoosen setHidden:YES];
    }
    else if(media == pickVideo)
    {
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        isVideoChanged = YES;
        
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:@"public.movie"]){
            //            NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"] relativePath];
            videourl =  [info objectForKey:UIImagePickerControllerMediaURL];
            //            AVURLAsset *sourceAsset = [AVURLAsset URLAssetWithURL:videourl options:nil];
            //            CMTime duration = sourceAsset.duration;
            //            float seconds = CMTimeGetSeconds(duration);
            NSData * movieData = [NSData dataWithContentsOfURL:[info objectForKey:UIImagePickerControllerMediaURL]];
            NSLog(@"%.2f",(float)movieData.length/1024.0f/1024.0f);
            float number = [[NSString stringWithFormat:@"%.2f",(float)movieData.length/1024.0f/1024.0f] floatValue];
            
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
                [self hideShowPlayVideoButton];
                
                [noFileChoosenVideo setHidden:YES];
                isVideoDeletedFromServer = NO;
                videoStringPath = [[NSString alloc]init];
                videoStringPath = [NSString stringWithFormat:@"%@",[info objectForKey:UIImagePickerControllerMediaURL]];
                videoStringPath = [self getaVideoPath:videoStringPath];
                uploadVideoData = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:videoStringPath]];
                placeholderImageVdo.image = [self getimagefromUrl:[info objectForKey:UIImagePickerControllerMediaURL]];
                [self videoUploaded];
            }
        }
    }
    else if (media == videoImage)
    {
        isImageSelctedFOrVideo = @"Yes";
        isVideoIMage=@"Yes";
        [picker dismissViewControllerAnimated:YES completion:nil];
        placeholderImageVdo.image=[Parameters scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] maxSize:480];
    }
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


- (void)exportHTML
{
    
    //NSLog(@"%@", [self getHTML]);
    
}

#pragma mark - Service IntegrationDelegate

- (void)receivedResponseDataContactExist:(NSDictionary *)responseDict
{
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        [SVProgressHUD dismiss];
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addEditContactPersonalProfile];
        });
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)addEditContactPersonalProfile
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
    htmlMessageText=[self replaceHTMLEntitiesInString:htmlMessageText];
    
    //for emogies
    htmlMessageText = [Parameters encodeDataForEmogies:htmlMessageText];
    
    
    // Download Images if not
    if(!self.imageViewForImage.image){
        NSString *urlStr = [NSString stringWithFormat:@"%@",[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileImageName"]];
        if ([urlStr hasSuffix:@".png"] || [urlStr hasSuffix:@".jpg"]|| [urlStr hasSuffix:@".JPG"])
        {
            NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            self.imageViewForImage.image = [[UIImage alloc]initWithData:data];
        }
    }
    
    if(!placeholderImageVdo.image){
        NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileVideoImage"]];
        if (videoImageStr!=nil && videoImageStr.length > 0 && ![videoImageStr isEqualToString:@"<null>"]) {
            NSURL *url1 = [NSURL URLWithString:[videoImageStr                                    stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
            NSData *data = [NSData dataWithContentsOfURL:url1];
            placeholderImageVdo.image = [[UIImage alloc]initWithData:data];
        }
    }
    //compare is image Change
    UIImage *secondImage = [UIImage imageNamed:@"default_profile_img.png"];
    //
    
    NSData *imgData1 = UIImagePNGRepresentation(imageViewForImage.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    
    BOOL isCompare =  [imgData1 isEqual:imgData2];
    
    if([isEditingMyProfile isEqualToString:@"Yes"])
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
            
            if(isCompare)
            {
                [serviceIntegration UpdateLogInUserProfile:self UserName:self.textfieldForUserName.text FirstName:textfieldForFirstName.text LastName:textfieldForLastName.text EmailId:textfieldForEmail.text PhoneNumber:textfieldForDigits.text UserNotes:htmlMessageText UserTitle:@"" UserCompany:@"" UserAddress:@"" ProfileImageName:@"profile" Image:nil ProfileTypeId:@"1" UserId:CURRENT_USER_ID MobileNumber:@"" WorkNumber:@"" isImageChanged:isImageChanged state: @"" city: @"" location:@"" IsPublic:status Occupation:@"" :@selector(receivedResponseDataUpdatePersonalProfile:)];
                
            }
            else
            {
                
                [serviceIntegration UpdateLogInUserProfile:self UserName:self.textfieldForUserName.text FirstName:textfieldForFirstName.text LastName:textfieldForLastName.text EmailId:textfieldForEmail.text PhoneNumber:textfieldForDigits.text UserNotes:htmlMessageText UserTitle:@"" UserCompany:@"" UserAddress:@"" ProfileImageName:@"profile" Image:imageViewForImage.image ProfileTypeId:@"1" UserId:CURRENT_USER_ID MobileNumber:@"" WorkNumber:@"" isImageChanged:isImageChanged state: @"" city: @"" location:@"" IsPublic:status Occupation:@"" :@selector(receivedResponseDataUpdatePersonalProfile:)];
            }
            isImageChanged = @"No";
      
        }
    }
    else if([stringForTitle isEqualToString:@"Update Contact"])
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
               
                
                [serviceIntegration AddContactWebService:self UserId:CURRENT_USER_ID ContactId:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"] UserName:textfieldForUserName.text.length > 0 ? textfieldForUserName.text : @"" FirstName:textfieldForFirstName.text.length > 0 ? textfieldForFirstName.text : @"" LastName:textfieldForLastName.text.length > 0 ? textfieldForLastName.text : @"" Message:htmlMessageText ImageName:@"profile" Image:nil PhoneNumber:textfieldForDigits.text.length > 0 ? textfieldForDigits.text : @"" emailId:textfieldForEmail.text.length > 0 ? textfieldForEmail.text: @"" userNotes:htmlMessageText userCompany:@"" userTitle:@"" userAddress:@"" profileId:profileId MobileNumber:@"" WorkNumber:@"" isImageChanged:isImageChanged state:@"" city:@"" location:@"" IsPublic:status Occupation:textFieldForOccupation.text.length > 0 ? textFieldForOccupation.text : @""  profileType:profileId ? @"1" : @"2" :@selector(receivedResponseDataAddContact:)];
                
            }
            else
            {
                [serviceIntegration AddContactWebService:self UserId:CURRENT_USER_ID ContactId:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"] UserName:textfieldForUserName.text.length > 0 ? textfieldForUserName.text : @"" FirstName:textfieldForFirstName.text.length > 0 ? textfieldForFirstName.text : @"" LastName:textfieldForLastName.text.length > 0 ? textfieldForLastName.text : @"" Message:htmlMessageText ImageName:@"profile" Image:imageViewForImage.image PhoneNumber:textfieldForDigits.text.length > 0 ? textfieldForDigits.text : @"" emailId:textfieldForEmail.text.length > 0 ? textfieldForEmail.text: @"" userNotes:htmlMessageText userCompany:@"" userTitle:@"" userAddress:@"" profileId:profileId MobileNumber:@"" WorkNumber:@"" isImageChanged:isImageChanged state:@"" city:@"" location:@"" IsPublic:status Occupation:textFieldForOccupation.text.length > 0 ? textFieldForOccupation.text : @"" profileType:profileId ? @"1" : @"2" :@selector(receivedResponseDataAddContact:)];
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
 
                [serviceIntegration AddContactWebService:self UserId:CURRENT_USER_ID ContactId:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"] UserName:textfieldForUserName.text.length > 0 ? textfieldForUserName.text : @"" FirstName:textfieldForFirstName.text.length > 0 ? textfieldForFirstName.text : @"" LastName:textfieldForLastName.text.length > 0 ? textfieldForLastName.text : @"" Message:htmlMessageText ImageName:@"profile" Image:imageViewForImage.image PhoneNumber:textfieldForDigits.text.length > 0 ? textfieldForDigits.text : @"" emailId:textfieldForEmail.text.length > 0 ? textfieldForEmail.text: @"" userNotes:htmlMessageText userCompany:@"" userTitle:@"" userAddress:@"" profileId:profileId MobileNumber:@"" WorkNumber:@"" isImageChanged:isImageChanged state:@"" city:@"" location:@"" IsPublic:status Occupation:textFieldForOccupation.text.length > 0 ? textFieldForOccupation.text : @"" profileType:profileId ? @"1" : @"2" :@selector(receivedResponseDataAddContact:)];
            }
            else
            {
 
                [serviceIntegration AddContactWebService:self UserId:CURRENT_USER_ID ContactId:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"] UserName:textfieldForUserName.text.length > 0 ? textfieldForUserName.text : @"" FirstName:textfieldForFirstName.text.length > 0 ? textfieldForFirstName.text : @"" LastName:textfieldForLastName.text.length > 0 ? textfieldForLastName.text : @"" Message:htmlMessageText ImageName:@"profile" Image:imageViewForImage.image PhoneNumber:textfieldForDigits.text.length > 0 ? textfieldForDigits.text : @"" emailId:textfieldForEmail.text.length > 0 ? textfieldForEmail.text: @"" userNotes:htmlMessageText userCompany:@"" userTitle:@"" userAddress:@"" profileId:profileId MobileNumber:@"" WorkNumber:@"" isImageChanged:isImageChanged state:@"" city:@"" location:@"" IsPublic:status Occupation:textFieldForOccupation.text.length > 0 ? textFieldForOccupation.text : @"" profileType:profileId ? @"1" : @"2" :@selector(receivedResponseDataAddContact:)];
            }
            isImageChanged = @"No";
        }
    }
}

-(void)videoUploadOnServer
{
    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
    if (appDeleagated.internetStatus==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Internet connection not available" maskType:SVProgressHUDMaskTypeBlack];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        //        [self postWith:requestDict];
        if(isVideoChanged == YES)
        {
            NSData *videoUrlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoStringPath]];
            if (videoUrlData !=nil) {
                uploadVideoData = videoUrlData;
                // NSLog(@"Video Data: %@",uploadVideoData);
            }
        }
        else{
            uploadVideoData = nil;
        }
        
        
        [self postvideo:uploadVideoData];
    }
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
- (void)receivedResponseDataAddContact:(NSDictionary *)responseDict
{
    
    //NSLog(@"%@",responseDict);
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        addContactVCId=self;
        
        contactIdToAdd = [responseDict valueForKey:@"ContactId"];
        
        NSString *string = [responseDict valueForKey:@"Message"];
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        if (videoStringPath !=nil && ![videoStringPath isEqual: [NSNull null]] && videoStringPath.length > 0 && ![videoStringPath isEqualToString:@""]) {
            [self videoUploadOnServer];
        }
        else
        {
            [self performSelector:@selector(moveToThePrevView) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)moveToThePrevView
{
    [Parameters popToViewControllerNamed:@"ContactViewController" from:addContactVCId];
}

-(void)receivedResponseDataUpdatePersonalProfile:(NSDictionary *)responseDict
{
    NSLog(@"receivedResponseDataUpdatePersonalProfile: %@",responseDict);
    if([isEditingMyProfile isEqualToString:@"Yes"])
    {
        CURRENT_USER_IMAGE= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"image"]];
        
        NSString *string = @"Profile updated successfully";//[responseDict valueForKey:@"msg"];
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        if (videoStringPath !=nil && ![videoStringPath isEqual: [NSNull null]] && videoStringPath.length > 0 && ![videoStringPath isEqualToString:@""]) {
            [self videoUploadOnServer];
        }
        else
        {
            [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
    }
    else
    {
        if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
        {
            addContactVCId=self;
            NSString *string = [responseDict valueForKey:@"msg"];
            [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
            [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"msg"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }
}


-(void)moveToHome
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
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
    // Dispose of any resources that can be recreated.
}
#pragma mark - Phone Number Field Formatting

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 85)
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
    return YES;
}

// to get a thumbnail image from imagepicker controller
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

//to get a video path from image picker controller
-(NSString*)getaVideoPath:(NSString*)path
{
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoStringPath]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *uniqueString = [CommonNotification createRandomName];
    NSString *videopath= [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@.mov",documentsDirectory,uniqueString]];
    BOOL success = [videoData writeToFile:videopath atomically:NO];
    
    NSLog(@"Successs:::: %@", success ? @"YES" : @"NO");
    NSLog(@"video path --> %@",videopath);
    
    return videopath;
    
}


-(void)postvideo:(NSData*)uploadVideo
{
    NSString *uniqueString;
    NSString *videoFileName;
    if(isVideoChanged){
        uniqueString = [CommonNotification createRandomName];
        videoFileName = [NSString stringWithFormat:@"%@%@",@"video_",uniqueString];
    }
    else{
        NSString *videoImageStr = [NSString stringWithFormat:@"%@",[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ProfileVideo"]];
        
        NSArray *arrayWithTwoStrings = [videoImageStr componentsSeparatedByString:@"Video/"];
        videoFileName = [arrayWithTwoStrings objectAtIndex:1];
    }
    
    NSString *urlString;
    if([isEditingMyProfile isEqualToString:@"Yes"])
    {
        if(isVideoChanged){
            urlString = [NSString stringWithFormat:@"%@%@UserId=%@&typeId=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadVideoFile,CURRENT_USER_ID,@"1", videoFileName,@"true"];
        }
        else{
            urlString = [NSString stringWithFormat:@"%@%@UserId=%@&typeId=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadVideoFile,CURRENT_USER_ID,@"1", videoFileName,@"false"];
        }
    }
    else if([stringForTitle isEqualToString:@"Update Contact"])
    {
        if(isVideoChanged){
            urlString = [NSString stringWithFormat:@"%@%@contact_id=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadProfileVideoContact,[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"],videoFileName,@"true"];
        }
        else{
            urlString = [NSString stringWithFormat:@"%@%@contact_id=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadProfileVideoContact,[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"],videoFileName,@"false"];
        }
    }
    else  //for add contact
    {
        if(isVideoChanged){
            urlString = [NSString stringWithFormat:@"%@%@contact_id=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadProfileVideoContact,contactIdToAdd,videoFileName,@"true"];
        }
        else{
            urlString = [NSString stringWithFormat:@"%@%@contact_id=%@&ProfileVideo=%@&IsVideoChange=%@",BASE_URL_GLOBAL,sUploadProfileVideoContact,contactIdToAdd,videoFileName,@"false"];
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
    [body appendData:[NSData dataWithData:uploadVideo]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    NSURLResponse *response;
    NSError *error;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableLeaves error:&error];
    NSLog(@"videoUpload=%@",responseDict);
    
    if([isEditingMyProfile isEqualToString:@"Yes"])
    {
        CURRENT_USER_Video= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"video"]];
        NSString *string = @"Profile updated successfully"; //[responseDict valueForKey:@"msg"];
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        //compare is image Change
        UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
        NSData *imgData1 = UIImagePNGRepresentation(placeholderImageVdo.image);
        NSData *imgData2 = UIImagePNGRepresentation(secondImage);
        BOOL isCompareVideoImage =  [imgData1 isEqual:imgData2];
        
        if (isVideoDeletedFromServer) {
            [self videoDeleteFromServer];
        }
        else
        {
            if (!isCompareVideoImage)
            {
                [self uploadVideoImage];
            }
            else
            {
                [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
            }
        }
    }
    else if([stringForTitle isEqualToString:@"Update Contact"])
    {
        if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
        {
            addContactVCId=self;
            NSString *string = [responseDict valueForKey:@"msg"];
            [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
            
            //compare is image Change
            UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
            NSData *imgData1 = UIImagePNGRepresentation(placeholderImageVdo.image);
            NSData *imgData2 = UIImagePNGRepresentation(secondImage);
            BOOL isCompareVideoImage =  [imgData1 isEqual:imgData2];
            
            if (isVideoDeletedFromServer) {
                [self videoDeleteFromServer];
            }
            else
            {
                if (!isCompareVideoImage)
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
            [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"msg"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }
    else
    {
        if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
        {
            addContactVCId=self;
            NSString *string = [responseDict valueForKey:@"msg"];
            [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
            
            //compare is image Change
            UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
            NSData *imgData1 = UIImagePNGRepresentation(placeholderImageVdo.image);
            NSData *imgData2 = UIImagePNGRepresentation(secondImage);
            BOOL isCompareVideoImage =  [imgData1 isEqual:imgData2];
            
            if (isVideoDeletedFromServer) {
                [self videoDeleteFromServer];
            }
            else
            {
                if (!isCompareVideoImage)
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
            [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"msg"] maskType:SVProgressHUDMaskTypeBlack];
        }
    }
    NSLog(@"%@", responseDict);
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
                                       media = videoimage;
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
        UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to pick a photo for your video" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alrt.tag = 4;
        [alrt show];
    }
}

-(void)uploadVideoImage
{
    
    //compare is image Change
    UIImage *secondImage = [UIImage imageNamed:@"novideo_default_img-2.png"];
    NSData *imgData1 = UIImagePNGRepresentation(placeholderImageVdo.image);
    NSData *imgData2 = UIImagePNGRepresentation(secondImage);
    BOOL isCompareVideoImage =  [imgData1 isEqual:imgData2];
    
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
            
            if(isCompareVideoImage)
            {
                
                [serviceIntegration uploadVideoImage:self UserId:CURRENT_USER_ID ProfileTypeId:@"1" ProfileVideoImageName:videoImageFileName videoImage:nil isImageChanged:isVideoIMage :@selector(receivedResponseDataForVideoImageUpload:)];
                
            }
            else
            {
                
                [serviceIntegration uploadVideoImage:self UserId:CURRENT_USER_ID ProfileTypeId:@"1" ProfileVideoImageName:videoImageFileName videoImage:placeholderImageVdo.image isImageChanged:isVideoIMage :@selector(receivedResponseDataForVideoImageUpload:)];
    
            }
           
        }
         isVideoIMage=@"No";
    }
    else if([stringForTitle isEqualToString:@"Update Contact"])
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
            
            if(isCompareVideoImage)
            {
                [serviceIntegration uploadVideoImageINContact:self contactId:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"] ProfileVideoImageName:videoImageFileName videoImage:nil isImageChanged:isVideoIMage :@selector(receivedResponseDataForVideoImageUploadInPersonalContact:)];
                
                
            }
            else
            {
                [serviceIntegration uploadVideoImageINContact:self contactId:[[[dataForEditContactArray objectAtIndex:0] valueForKey:@"userDTO"]valueForKey:@"ContactId"] ProfileVideoImageName:videoImageFileName videoImage:placeholderImageVdo.image isImageChanged:isVideoIMage :@selector(receivedResponseDataForVideoImageUploadInPersonalContact:)];
            
            }
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
            
            
            NSString *uniqueString = [CommonNotification createRandomName];
            NSString *videoImageFileName = [NSString stringWithFormat:@"%@%@",@"videoImage_",uniqueString];
            
            if(isCompareVideoImage)
            {
                [serviceIntegration uploadVideoImageINContact:self contactId:contactIdToAdd ProfileVideoImageName:videoImageFileName videoImage:nil isImageChanged:isVideoIMage :@selector(receivedResponseDataForVideoImageUploadInPersonalContact:)];
                
                
            }
            else
            {
                [serviceIntegration uploadVideoImageINContact:self contactId:contactIdToAdd ProfileVideoImageName:videoImageFileName videoImage:placeholderImageVdo.image isImageChanged:isVideoIMage :@selector(receivedResponseDataForVideoImageUploadInPersonalContact:)];
           
            }
            isVideoIMage=@"No";
        }
    }
}


-(void)receivedResponseDataForVideoImageUpload:(NSDictionary*)responseDict
{
    NSLog(@"VideoImage=%@",responseDict);
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        if (isVideoDeletedFromServer) {
            [self videoDeleteFromServer];
        }
        else
        {
            [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}

-(void)receivedResponseDataForVideoImageUploadInPersonalContact:(NSDictionary*)responseDict
{
    NSLog(@"VideoImage=%@",responseDict);
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        NSString *string = @"Profile updated successfully";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        
        if (isVideoDeletedFromServer) {
            [self videoDeleteFromServer];
        }
        else
        {
            [self performSelector:@selector(moveToHome) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
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
                UIAlertView *alrt=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to rotate image?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                alrt.tag = 6;
                [alrt show];
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
    if(selectedImageTag == 1){
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


@end

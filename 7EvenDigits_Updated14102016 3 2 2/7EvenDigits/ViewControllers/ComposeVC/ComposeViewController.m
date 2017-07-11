//
//  ZSSDemoViewController.m
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "ComposeViewController.h"
#import "MenuViewController.h"
#import "ZSSRichTextEditor.h"
#import "Constant.h"
#import "PreviewPostViewController.h"
#import "HomeViewController.h"

@interface ComposeViewController ()

@end

@implementation ComposeViewController
@synthesize textfieldForAge,textfieldForCity,textfieldForState,textfieldForTitle,textfieldForZip,stateId,cityId,messagePlianText,prevPost,radioBtnLessThanCompose,htmlMessageText,messageIdForUpdateDraft,CancelDataButton;
@synthesize m2mBtn,m2wBtn,w2mBtn,w2wBtn,everyOneBtn,zipCodeId,objDraftVc,objDraftArray,img;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    isImagePickedInCompose = NO;
    self.navigationController.navigationBarHidden=NO;
    
    self.title = @"Compose";
    radioBtnLessThanCompose.tag=555;
    radioBtnMoreThanCompose.tag=666	;
   // [self callImageUploadWebService];
    
    //NEW Table
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden)
//                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
    [radioBtnLessThanCompose setSelected:YES];
    [noFileChoosen setHidden:NO];
    
    [self.everyOneBtn setSelected:YES];
    
    if([stringForTitle isEqualToString:@"DraftMessage"])
    {
        
        [self.CancelDataButton setHidden:YES];
        prevPost.composeVC=self;
        textfieldForTitle.text=[objDraftArray valueForKey:@"Title"];
        textfieldForAge.text=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"Age"]];
        textfieldForCity.text=[objDraftArray valueForKey:@"CityName"];
        textfieldForState.text=[objDraftArray valueForKey:@"StateName"];
        textfieldForZip.text=[objDraftArray valueForKey:@"ZipCode"];
        messageIdForUpdateDraft=[objDraftArray valueForKey:@"MessageId"];
        self.prevPost.messageIdForEdit=[objDraftArray valueForKey:@"MessageId"];

        [self setHtml:[Parameters decodeDataForEmogies:[objDraftArray valueForKey:@"Message"]]];
        
        self.stateId=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"StateId"]];
        self.zipCodeId=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"ZipcodeId"] ];
        self.cityId=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"CityId"] ];
        
        NSURL *url = [NSURL URLWithString:[[objDraftArray valueForKey:@"ImageName"]
                                           stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.img.image = [[UIImage alloc]initWithData:data];
        
        
        UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButtonInCompose)];
        self.navigationItem.leftBarButtonItem=rightBarBtn;
        NSString *EveryOneBtn=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"EveryOne"]];
        NSString *M2MBtn=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"M2M"]];
        NSString *M2WBtn=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"M2W"]];
        NSString *W2MBtn=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"W2M"]];
        NSString *W2WBtn=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"W2W"]];
        
        NSString *lessthan=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"LessThan30Days"]];
       
        [noFileChoosen setHidden:YES];
        if(strForButtonPrevoiusState!=nil)
        {
            strForButtonPrevoiusState=nil;
        }
        
        if([EveryOneBtn isEqualToString:@"0"])
        {
            [self.everyOneBtn setSelected:NO];
        }
        else
        {
            [self.everyOneBtn setSelected:YES];
            strForButtonPrevoiusState=@"500";
            strForButtonCurrentState=@"500";
            
        }
        if([M2MBtn isEqualToString:@"0"])
        {
            [self.m2mBtn setSelected:NO];
        }
        else
        {
            [self.m2mBtn setSelected:YES];
            strForButtonPrevoiusState=@"100";
            strForButtonCurrentState=@"100";
        }
        if([M2WBtn isEqualToString:@"0"])
        {
            [self.m2wBtn setSelected:NO];
        }
        else
        {
            [self.m2wBtn setSelected:YES];
            strForButtonPrevoiusState=@"200";
            strForButtonCurrentState=@"200";
            
        }
        if([W2MBtn isEqualToString:@"0"])
        {
            [self.w2mBtn setSelected:NO];
        }
        else
        {
            [self.w2mBtn setSelected:YES];
            strForButtonPrevoiusState=@"400";
            strForButtonCurrentState=@"400";
        }
        if([W2WBtn isEqualToString:@"0"])
        {
            [self.w2wBtn setSelected:NO];
        }
        else
        {
            [self.w2wBtn setSelected:YES];
             strForButtonPrevoiusState=@"300";
            strForButtonCurrentState=@"300";
        }
        
        if([lessthan isEqualToString:@"0"])
        {
            [radioBtnLessThanCompose setSelected:NO];
            [radioBtnMoreThanCompose setSelected:YES];
            RadioButtonPrevoiusState=@"666";
            RadioButtonCurrentState=@"666";
        }
        else
        {
            [radioBtnLessThanCompose setSelected:YES];
            [radioBtnMoreThanCompose setSelected:NO];
            RadioButtonPrevoiusState=@"555";
            RadioButtonCurrentState=@"555";
        }
     
    }
    else
    {
        [self.CancelDataButton setHidden:NO];
        [self.cancelStateBtn setHidden:YES];
        [self.cancelCityBtn setHidden:YES];
        [self.cancelZipBtn setHidden:YES];
        
        
        UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
        self.navigationItem.leftBarButtonItem=menuBarBtn;
    }
    
    
    //composeViewControllerFlag=NO;
    [scrollviewObj setContentSize:CGSizeMake(0, 1100)];
    
     [Parameters addPaddingView:textfieldForState];
     [Parameters addPaddingView:textfieldForCity];
     [Parameters addPaddingView:textfieldForZip];
     [Parameters addPaddingView:textfieldForTitle];
     [Parameters addPaddingView:textfieldForAge];
    
    // Export HTML
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportHTML)];
	
    //HTML Content to set in the editor
    NSString *html = @"";
    
    // Set the base URL if you would like to use relative links, such as to images.
    self.baseURL = [NSURL URLWithString:@"http://www.google.com"];
    
    // If you want to pretty print HTML within the source view.
    self.formatHTML = YES;
    
    // Set the toolbar item color
    //self.toolbarItemTintColor = [UIColor greenColor];
    
    // Set the toolbar selected color
    //self.toolbarItemSelectedTintColor = [UIColor brownColor];
    
    // Choose which toolbar items to show
    //self.enabledToolbarItems = ZSSRichTextEditorToolbarSuperscript | ZSSRichTextEditorToolbarUnderline | ZSSRichTextEditorToolbarH1 | ZSSRichTextEditorToolbarH3;
    
    // Set the HTML contents of the editor
    [self setHtml:html];

}

-(void)clearEditorView
{
//    self.title = @"ZSSRichTextEditor";
//    
//    // Export HTML
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportHTML)];
	
    // HTML Content to set in the editor
    NSString *html = @"";
    
    // Set the base URL if you would like to use relative links, such as to images.
    self.baseURL = [NSURL URLWithString:@"http://www.zedsaid.com"];
    
    // If you want to pretty print HTML within the source view.
    self.formatHTML = YES;
    
    // Set the toolbar item color
    //self.toolbarItemTintColor = [UIColor greenColor];
    
    // Set the toolbar selected color
    //self.toolbarItemSelectedTintColor = [UIColor brownColor];
    
    // Choose which toolbar items to show
    //self.enabledToolbarItems = ZSSRichTextEditorToolbarSuperscript | ZSSRichTextEditorToolbarUnderline | ZSSRichTextEditorToolbarH1 | ZSSRichTextEditorToolbarH3;
    
    // Set the HTML contents of the editor
    [self setHtml:html];
}
- (void)keyboardWasShown
{
    //[self.toolbarHolder setUserInteractionEnabled:YES];
    //toolbarKbd.hidden = NO;
}

- (void)keyboardWillBeHidden
{
   // [self.toolbarHolder setUserInteractionEnabled:NO];
    //toolbarKbd.hidden = YES;
}
- (void)viewWillAppear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //[radioBtnLessThanCompose setSelected:YES];
    
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
    if([stringForTitle isEqualToString:@"DraftMessage"])
    {
    [noFileChoosen setHidden:YES];
    }
    else
    {
    //[noFileChoosen setHidden:NO];
    }
}

/*
 - (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring
 {
 // Put anything that starts with this substring into the stateDataAfterSearch array
 // The items in this array is what will show up in the table view
 NSArray *results=[[NSArray alloc]init];
 NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",substring];
 results= [self.stateNameArray filteredArrayUsingPredicate:predicate];
 [self.stateNameArray removeAllObjects];
 for (int i=0; i< results.count; i++)
 {
 [self.stateNameArray addObject:[results  objectAtIndex:i]] ;
 }
 }
 */

//Table for Popover
#pragma mark UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    
    //     [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    //
    //    if (serviceIntegration != nil)
    //    {
    //        serviceIntegration = nil;
    //    }
    //    serviceIntegration = [[ServerIntegration alloc]init];
    //
    //    [serviceIntegration GetStateListWebService:self q:@"A" :@selector(receivedResponseDataForCompose:)];
    
    return YES;
}


-(void)handelBackButtonInCompose
{
    [currentTextField resignFirstResponder];
    [self dismissKeyboard];
    flagForHandelHome=YES;
        NSString *Title=[objDraftArray valueForKey:@"Title"];
        NSString *Age=[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"Age"]];
        NSString *City=[objDraftArray valueForKey:@"CityName"];
        NSString *State=[objDraftArray valueForKey:@"StateName"];
        NSString *Zip=[objDraftArray valueForKey:@"ZipCode"];
    
    //html message
        NSString *previousHtml = [self convertHTML:[objDraftArray valueForKey:@"Message"]];
        NSMutableString *innerText= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"]];
        
    //image
    NSURL *url = [NSURL URLWithString:[[objDraftArray valueForKey:@"ImageName"]
                                       stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *previousImage = [UIImage imageWithData:data];
    CGSize test = previousImage.size;
    
    UIImage *imagw=img.image;
    CGSize test1 = imagw.size;
    
    //buttons
    
    
        if(([textfieldForTitle.text isEqualToString:Title]) && ([textfieldForAge.text isEqualToString:Age])&&([textfieldForCity.text isEqualToString:City]) &&([textfieldForState.text isEqualToString:State]) &&([textfieldForZip.text isEqualToString:Zip]) && [innerText isEqualToString:previousHtml] && (test.width == test1.width && test.height == test1.height) && ([strForButtonCurrentState isEqualToString:strForButtonPrevoiusState]) && ([RadioButtonCurrentState isEqualToString:RadioButtonPrevoiusState]))
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showExitAlertInCompose];
        }
}

-(void)showExitAlertInCompose
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
                                       [self handleYesButtonAction];
                                       
                                   }];
        [alertVC addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"No"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           [self dismissViewControllerAnimated:YES completion:nil];
                                           [self handleNoButtonAction];
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


-(NSString *)convertHTML:(NSString *)html {
    
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

- (void)showInsertURLAlternatePicker
{
    
    [self dismissAlertView];
    
    
}


- (void)showInsertImageAlternatePicker
{
    
    [self dismissAlertView];
    
   
    
}

#pragma mark==Navigate to home view
-(void)handelHome
{
    [self dismissKeyboard];
    [currentTextField resignFirstResponder];
    
    if([self checkIsEMpty] == YES)
    {
//        [self slideViewWithAnimation];
        [self callHomeVC];
    }
    else
    {
        flagForHandelHome=YES;
   [self showExitAlertInCompose];
    }
    
}
-(void)callHomeVC
{
    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
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
    if(strForButtonCurrentState!=nil)
    {
        strForButtonCurrentState=nil;
    }
    strForButtonCurrentState=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    [sender setSelected:YES];
}

-(IBAction)browseImage:(id)sender
{
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    imgPicker.editing=YES;
    imgPicker.delegate=self;
    imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
    
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, SCREEN_WIDTH, 45);
}
-(IBAction)handelRadioButtonLessThanCompose:(UIButton *)sender
{
    [radioBtnLessThanCompose setSelected:NO];
    [radioBtnMoreThanCompose setSelected:NO];
    if(RadioButtonCurrentState !=nil)
    {
        RadioButtonCurrentState=nil;
    }
    RadioButtonCurrentState=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    [sender setSelected:YES];
}
-(IBAction)handelRadioButtonMoreThanCompose:(UIButton *)sender
{
    
}
-(IBAction)handleDeleteBtn:(id)sender
{
    isImagePickedInCompose = NO;
    [noFileChoosen setHidden:NO];
    img.image = [UIImage imageNamed:@"profil_img2.png"];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isImagePickedInCompose=YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
    //img.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    self.img.image=[Parameters scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] maxSize:700];
    [noFileChoosen setHidden:YES];
    
}

#pragma mark - Utilities


-(NSString *) stringByStrippingHTML
{
    NSRange r;
    NSString *s = [self copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

- (NSString *)removeQuotesFromHTML:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    html = [html stringByReplacingOccurrencesOfString:@"&nsbp;"  withString:@""];
    html = [html stringByReplacingOccurrencesOfString:@"&"  withString:@"%26"];

    return html;
}//end

- (NSString *)tidyHTML:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
    if (self.formatHTML) {
        html = [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"style_html(\"%@\");", html]];
    }
    return html;
}//end
-(BOOL)checkIsEMpty
{
    [currentTextField resignFirstResponder];
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
    NSString *myStr=[self stripTags:htmlMessageText];
    
    myStr=[myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    if((textfieldForState.text.length==0)&(textfieldForCity.text.length==0)&(textfieldForTitle.text.length==0)&(textfieldForAge.text.length==0)&[myStr isEqualToString:@""])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
-(IBAction)handelSave:(UIButton *)sender
{
    [self dismissKeyboard];
//    UIButton *btn = (UIButton *)sender;
//    NSLog(@"%ld",(long)sender.tag);
    
    
//    if([self checkIsEMpty] == YES)
//    {
//        
//    }
//    else
//    {
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
        messagePlianText = [self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    
        //for remove &nbsp from html
    
       htmlMessageText = [self replaceHTMLEntitiesInString:htmlMessageText];
    
       htmlMessageText = [Parameters encodeDataForEmogies:htmlMessageText];
    
       messagePlianText = [Parameters encodeDataForEmogies:messagePlianText];
        
              
        
        if (sender.tag == 2)
        {
            //preview post button tapped
            if([self checkTextfield])
            {
                prevPost=[[PreviewPostViewController alloc]initWithNibName:@"PreviewPostViewController" bundle:[NSBundle mainBundle]];
                prevPost.composeVC=self;
                [self.navigationController pushViewController:prevPost animated:YES];
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
                messagePlianText = [self replacePlainMessageAmpercentInString:messagePlianText];

                
                if([stringForTitle isEqualToString:@"DraftMessage"])
                {
//                    if([[objDraftArray valueForKey:@"ImageName"]isEqualToString:@"http://115.113.151.198/socialMedia/content/Message/default_Contact.png"] && isImagePickedInCompose == NO)
                if([[NSString stringWithFormat:@"%@",[objDraftArray valueForKey:@"ImageName"]] hasSuffix:@"default_Contact.png"] && isImagePickedInCompose == NO)
                    {
                        [serviceIntegration PostMessage:self UserId:CURRENT_USER_ID StateId:self.stateId CityId:self.cityId ZipCodeId:self.zipCodeId Title:(textfieldForTitle.text.length == 0 ? @"" :textfieldForTitle.text)  Age:(textfieldForAge.text.length == 0 ? @"" :textfieldForAge.text) M2M:(m2mBtn.selected ? @"true": @"false") M2W:(m2wBtn.selected ? @"true": @"false") W2W:(w2wBtn.selected ? @"true": @"false") W2M:(w2mBtn.selected ? @"true": @"false") Everyone:(everyOneBtn.selected ? @"true": @"false") LessThan30Days:(radioBtnLessThanCompose.selected ? @"true": @"false") MessageHTML:htmlMessageText Message:messagePlianText IsDraft:(sender.tag - 1 ? @"false" : @"true") PostMessageId:messageIdForUpdateDraft ImageName:@"profile" Image:nil :@selector(receivedResponseDataForPostMessageInCompose:)];
                    }
                    else
                    {
                        isImagePickedInCompose = NO;
                        [serviceIntegration PostMessage:self UserId:CURRENT_USER_ID StateId:self.stateId CityId:self.cityId ZipCodeId:self.zipCodeId Title:(textfieldForTitle.text.length == 0 ? @"" :textfieldForTitle.text)  Age:(textfieldForAge.text.length == 0 ? @"" :textfieldForAge.text) M2M:(m2mBtn.selected ? @"true": @"false") M2W:(m2wBtn.selected ? @"true": @"false") W2W:(w2wBtn.selected ? @"true": @"false") W2M:(w2mBtn.selected ? @"true": @"false") Everyone:(everyOneBtn.selected ? @"true": @"false") LessThan30Days:(radioBtnLessThanCompose.selected ? @"true": @"false") MessageHTML:htmlMessageText Message:messagePlianText IsDraft:(sender.tag - 1 ? @"false" : @"true") PostMessageId:messageIdForUpdateDraft ImageName:@"profile" Image:self.img.image :@selector(receivedResponseDataForPostMessageInCompose:)];
                    }
                    
                }
                else
                {
                    
                    if(isImagePickedInCompose == YES)
                    {
                        isImagePickedInCompose = NO;
                        [serviceIntegration PostMessage:self UserId:CURRENT_USER_ID StateId:self.stateId CityId:self.cityId ZipCodeId:self.zipCodeId Title:(textfieldForTitle.text.length == 0 ? @"" :textfieldForTitle.text) Age:(textfieldForAge.text.length == 0 ? @"" :textfieldForAge.text) M2M:(m2mBtn.selected ? @"true": @"false") M2W:(m2wBtn.selected ? @"true": @"false") W2W:(w2wBtn.selected ? @"true": @"false") W2M:(w2mBtn.selected ? @"true": @"false") Everyone:(everyOneBtn.selected ? @"true": @"false") LessThan30Days:(radioBtnLessThanCompose.selected ? @"true": @"false") MessageHTML:htmlMessageText Message:messagePlianText IsDraft:(sender.tag - 1 ? @"false" : @"true") PostMessageId:@"0" ImageName:@"profile" Image:self.img.image :@selector(receivedResponseDataForPostMessageInCompose:)];
                    }
                    else
                    {
                        [serviceIntegration PostMessage:self UserId:CURRENT_USER_ID StateId:self.stateId CityId:self.cityId ZipCodeId:self.zipCodeId Title:(textfieldForTitle.text.length == 0 ? @"" :textfieldForTitle.text) Age:(textfieldForAge.text.length == 0 ? @"" :textfieldForAge.text) M2M:(m2mBtn.selected ? @"true": @"false") M2W:(m2wBtn.selected ? @"true": @"false") W2W:(w2wBtn.selected ? @"true": @"false") W2M:(w2mBtn.selected ? @"true": @"false") Everyone:(everyOneBtn.selected ? @"true": @"false") LessThan30Days:(radioBtnLessThanCompose.selected ? @"true": @"false") MessageHTML:htmlMessageText Message:messagePlianText IsDraft:(sender.tag - 1 ? @"false" : @"true") PostMessageId:@"0" ImageName:@"profile" Image:nil :@selector(receivedResponseDataForPostMessageInCompose:)];
                    }
                    
                }
                
            }
            //            if (stringForTitle!=nil)
            //            {
            //                stringForTitle=nil;
            //            }
            messageIdForUpdateDraft=@"";
        }
        //  }

//    }
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

- (NSString *)replaceHTMLEntitiesInString:(NSString *)str
{
    
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    //str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    str = [str stringByReplacingOccurrencesOfString:@"&amp;" withString:@"%26"];
    return str;
}

-(BOOL)checkTextfield
{
    BOOL isValidAge = [self IsValidNumericValue:textfieldForAge.text];
    
//  NSString *string = [self.editorView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].innerHTML"];
    //BOOL isEmpty = string==nil || [string length]==0;
    
    if (self.textfieldForState.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"State is mandatory" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if (self.textfieldForCity.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"City is mandatory" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if (self.textfieldForTitle.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Title is mandatory" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if (self.textfieldForAge.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Age is mandatory" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
    }
    else if ([self.textfieldForAge.text isEqualToString:@"0"] || (self.textfieldForAge.text.length>3))
    {
        [SVProgressHUD showErrorWithStatus:@"Invalid age" maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    else if([textfieldForAge.text isEqual:@"0"]||[textfieldForAge.text isEqual:@"1"]||[textfieldForAge.text isEqual:@"2"]||[textfieldForAge.text isEqual:@"3"]||[textfieldForAge.text isEqual:@"4"]||[textfieldForAge.text isEqual:@"5"]||[textfieldForAge.text isEqual:@"6"]||[textfieldForAge.text isEqual:@"7"]||[textfieldForAge.text isEqual:@"8"]||[textfieldForAge.text isEqual:@"9"]||[textfieldForAge.text isEqual:@"10"]||[textfieldForAge.text isEqual:@"11"]||[textfieldForAge.text isEqual:@"12"]||[textfieldForAge.text isEqual:@"13"]||[textfieldForAge.text isEqual:@"14"]||[textfieldForAge.text isEqual:@"15"]||[textfieldForAge.text isEqual:@"16"]||[textfieldForAge.text isEqual:@"17"])
    {
        [SVProgressHUD showErrorWithStatus:@"Your age must be 18 years or older" maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    else if ([htmlMessageText length]>0)
    {
        NSString *myStr=[self stripTags:htmlMessageText];
        
        myStr=[myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
         myStr=[myStr stringByReplacingOccurrencesOfString:@" " withString:@""];
         myStr=[myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        if (myStr.length==0)
        {
            [SVProgressHUD showErrorWithStatus:@"Message is mandatory" maskType:SVProgressHUDMaskTypeBlack];
            return NO;
         }
    }
    else if (!isValidAge)
    {
        [SVProgressHUD showErrorWithStatus:@"Age should be numeric"maskType:SVProgressHUDMaskTypeBlack ];

        return NO;
    }
    
    return YES;
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


- (void)textFieldDidBeginEditing:(UITextField *)textField;
{
    currentTextField=textField;
    
    
}// became first responder


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 425, 320, 35)];
    UIBarButtonItem *space =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //toolbar.backgroundColor=[UIColor colorWithRed:147.0f/255.0f green:147.0f/255.0f blue:147.0f/255.0f alpha:1 ];
    toolbar.backgroundColor=[UIColor darkTextColor];
    
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okToolBarBtn)];
    customItem2.tintColor = [UIColor blackColor];
    NSArray *toolbarItems = [NSArray arrayWithObjects: space, customItem2, nil];
    
    [toolbar setItems:toolbarItems];
    
    self.textfieldForAge.inputAccessoryView=toolbar;
    return YES;
}
-(void)okToolBarBtn
{
    [self.textfieldForAge resignFirstResponder];
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


-(IBAction)handelStateName
{
    searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    searchVC.composeVC=self;
    searchVC.title=@"State";
    
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(IBAction)handelCityName
{
    searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    searchVC.composeVC=self;
    searchVC.title=@"City";
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(IBAction)handelZipCode
{
    searchVC=[[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:[NSBundle mainBundle]];
    searchVC.composeVC=self;
    searchVC.title=@"Zip Code";
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)radioButtonLessThanCompse:(id)sender
{
    
}
- (IBAction)handleCancel:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    if (btn.tag==100)
    {
        self.textfieldForState.text=@"";
        self.stateId=@"";
        [self.cancelStateBtn setHidden:YES];
    }
    if (btn.tag==200)
    {
        self.textfieldForCity.text=@"";
        self.cityId=@"";
        [self.cancelCityBtn setHidden:YES];
    }
    if (btn.tag==300)
    {
        self.textfieldForZip.text=@"";
        self.zipCodeId=@"";
        [self.cancelZipBtn setHidden:YES];
    }
}

- (IBAction)handelCancelButton:(id)sender
{
    [self dismissKeyboard];
    [currentTextField resignFirstResponder];
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
    NSString *myStr=[self stripTags:htmlMessageText];
    
    myStr=[myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    if((textfieldForState.text.length==0)&(textfieldForCity.text.length==0)&(textfieldForTitle.text.length==0)&(textfieldForAge.text.length==0)&[myStr isEqualToString:@""])
    {
//        [self slideViewWithAnimation];
        [self callHomeVC];
    }
    else
    {
        flagForHandelCancel=YES;
        [self showExitAlertInCompose];
    }
}

-(void)clearComposeData
{
    textfieldForAge.text=@"";
    textfieldForCity.text=@"";
    textfieldForState.text=@"";
    textfieldForTitle.text=@"";
    textfieldForZip.text=@"";
    self.stateId=@"";
    self.cityId=@"";
    self.zipCodeId=@"";
    
    [self.cancelZipBtn setHidden:YES];
    [self.cancelStateBtn setHidden:YES];
    [self.cancelCityBtn setHidden:YES];
    
    [self.m2mBtn setSelected:NO];
    [self.m2wBtn setSelected:NO];
    [self.w2mBtn setSelected:NO];
    [self.w2wBtn setSelected:NO];
    [self.everyOneBtn setSelected:YES];
    
    //[radioBtnLessThanCompose setSelected:YES];
    [radioBtnLessThanCompose setSelected:YES];
    [radioBtnMoreThanCompose setSelected:NO];

    img.image=[UIImage imageNamed:@"profil_img2.png"];
    
    if (self.sourceView.hidden)
    {
        self.sourceView.text = @"";
        self.sourceView.hidden = YES;
        
        NSString *html = @"";
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
        NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
        NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
        NSString *source = [[NSBundle mainBundle] pathForResource:@"ZSSRichTextEditor" ofType:@"js"];
        NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--content-->" withString:html];
        
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
//-(void)callImageUploadWebService
//{
//    
//    appDeleagated=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    if (appDeleagated.internetStatus==0)
//    {
//    }
//    else
//    {
//         [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
//        
//        if (serviceIntegration != nil)
//        {
//            serviceIntegration = nil;
//        }
//        serviceIntegration = [[ServerIntegration alloc]init];
//        
//        UIImage *image = [UIImage imageNamed:@"profil_img3.png"];
//        
//        [serviceIntegration UploadImage:@"profil_img3" UserId:CURRENT_USER_ID ImageArray:image delegate:self :@selector(receivedResponseDataForImage:)];
//    }
//    
//    //  [serviceIntegration UploadImage:image profileImageName:@"profil_img3" User_id:@"216" delegate:self :@selector(receivedResponseDataForImage:)];
//    
//}
#pragma mark== Receive Response
- (void)receivedResponseDataForImage:(NSMutableArray *)responseArray
{
     [SVProgressHUD dismiss];
    //NSLog(@"Respons%@",responseArray);
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex==0)
//    {
//        [self handleYesButtonAction];
//    }
//    else
//    {
//        [self handleNoButtonAction];
//    }
//    flagForHandelHome=NO;
//    flagForHandelCancel=NO;
//}
-(void)handleYesButtonAction
{
    if(flagForHandelHome)
    {
        flagForHandelHome=NO;
        //[self slideViewWithAnimation];
        UIButton *btn=[[UIButton alloc]init];// = (UIButton *)sender;
        btn.tag=1;
        
        [self handelSave:btn];
    }
    else
    {
        if([stringForTitle isEqualToString:@"DraftMessage"])
        {
            if (stringForTitle!=nil)
            {
                stringForTitle=nil;
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self clearComposeData];
            [self dismissKeyboard];
            [currentTextField resignFirstResponder];
            if (flagForHandelCancel)
            {
                flagForHandelCancel=NO;
                //                    [self slideViewWithAnimation];
                UIButton *btn=[[UIButton alloc]init];// = (UIButton *)sender;
                btn.tag=1;
                [self handelSave:btn];
                //[self callHomeVC];
            }
            //[self slideViewWithAnimation];
        }
    }
    
    flagForHandelHome=NO;
    flagForHandelCancel=NO;
}

-(void)handleNoButtonAction
{
    [self clearComposeData];
    [self dismissKeyboard];
    [currentTextField resignFirstResponder];
    
    [SVProgressHUD showErrorWithStatus:@"Your draft will not be saved" maskType:SVProgressHUDMaskTypeBlack];
    
    [self callHomeVC];
    
    flagForHandelHome=NO;
    flagForHandelCancel=NO;
    
}

#pragma mark== Receive Response
- (void)receivedResponseDataForPostMessageInCompose:(NSMutableArray *)responseArray
{
        
    //NSLog(@"Respons%@",responseArray);
    
    if([[responseArray valueForKey:@"success"]isEqualToString:@"true"])
    {
        [self clearComposeData];
        [self dismissKeyboard];
        [currentTextField resignFirstResponder];
        
        NSString *string = @"Your message is being saved in the draft folder.";
        [SVProgressHUD showSuccessWithStatus:string maskType:SVProgressHUDMaskTypeBlack];
        [self performSelector:@selector(callHomeVC) withObject:self afterDelay:[Parameters getTimeInterValFromString:string]];
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseArray valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
    [currentTextField resignFirstResponder];
}
//To get valid number values
-(BOOL) IsValidNumericValue:( NSString*) value
{
    NSString*numericRegex = @"^([0-9]+)?([\\,\\.]([0-9]{1,2})?)?$";
    NSPredicate*numericTest =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", numericRegex];
    return[numericTest evaluateWithObject:value];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
@end

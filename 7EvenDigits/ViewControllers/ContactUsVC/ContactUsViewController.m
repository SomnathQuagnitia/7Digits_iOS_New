//
//  ZSSDemoViewController.m
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "ContactUsViewController.h"
#import "PreviewPostViewController.h"
#import "MenuViewController.h"
#import "ZSSRichTextEditor.h"
#import "Constant.h"
#import "HomeViewController.h"
@interface ContactUsViewController ()

@end

@implementation ContactUsViewController
@synthesize textFieldForPhoneNo,textFieldForName,textFieldForEmailAddress;
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
    self.navigationController.navigationBarHidden=NO;

    self.title = @"Contact Us";
    
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    
    
    //contactUsViewControllerFlag=NO;
    if (stringForTitle!=nil)
    {
        stringForTitle=nil;
    }
    stringForTitle=self.title;
    
    [scrollviewObj setContentSize:CGSizeMake(0, 750)];
    
    
    [Parameters addPaddingView:textFieldForName];
    [Parameters addPaddingView:textFieldForEmailAddress];
    [Parameters addPaddingView:textFieldForPhoneNo];
    
    UIBarButtonItem *menuBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"home_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelHome)];
    self.navigationItem.leftBarButtonItem=menuBarBtn;
    // Export HTML
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportHTML)];
    
    // HTML Content to set in the editor
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


- (void)showInsertURLAlternatePicker {
    
    [self dismissAlertView];
    
    //    ZSSDemoPickerViewController *picker = [[ZSSDemoPickerViewController alloc] init];
    //    picker.demoView = self;
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    //    nav.navigationBar.translucent = NO;
    //    [self presentViewController:nav animated:YES completion:nil];
    
}


- (void)showInsertImageAlternatePicker {
    
    [self dismissAlertView];
    
    //    ZSSDemoPickerViewController *picker = [[ZSSDemoPickerViewController alloc] init];
    //    picker.demoView = self;
    //    picker.isInsertImagePicker = YES;
    //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:picker];
    //    nav.navigationBar.translucent = NO;
    //    [self presentViewController:nav animated:YES completion:nil];
    
}

#pragma mark==Navigate to home view
-(void)handelHome
{
    [self dismissKeyboard];
    [currentTextField resignFirstResponder];
    
    NSMutableString *htmlMessage= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
    
    NSString *htmlMessageText1 = nil;
    NSRange start = [htmlMessage rangeOfString:@">"];
    if (start.location != NSNotFound)
    {
        htmlMessageText1 = [htmlMessage substringFromIndex:start.location + start.length];
        NSRange end = [htmlMessageText1 rangeOfString:@"</body>"];
        if (end.location != NSNotFound)
        {
            htmlMessageText = [htmlMessageText1 substringToIndex:end.location];
        }
    }
    NSString *myStr=[self stripTags:htmlMessageText1];
    myStr=[myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    if((textFieldForName.text.length==0)&(textFieldForPhoneNo.text.length==0)&(textFieldForEmailAddress.text.length==0)&[myStr isEqualToString:@""])
    {
        textFieldForName.text=@"";
        textFieldForPhoneNo.text=@"";
        textFieldForEmailAddress.text=@"";
        [self dismissKeyboard];
        [currentTextField resignFirstResponder];
        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
        //[self slideViewWithAnimation];
    }
    else
    {
        [self showExitAlertInCOntactUs];
    }
}
-(void)showExitAlertInCOntactUs
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
                                       [self handleYesButtonActionInContctUs];
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
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you want to save changes?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
//        [alert show];
    }
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
-(IBAction)handelSendMail:(UIButton *)sender
{
    if([self validateEmail])
    {
        
        NSMutableString *htmlSourceCodeForContactUs = [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
        
//        htmlSourceCodeForContactUs = (NSMutableString *)[(NSString *)htmlSourceCodeForContactUs encodeString:NSUTF8StringEncoding];
        
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
            
            [serviceIntegration ContactUsWebService:self Name:textFieldForName.text Email:textFieldForEmailAddress.text PhoneNumber:textFieldForPhoneNo.text Message:htmlSourceCodeForContactUs :@selector(receivedResponseContactUs:)];
        }
    }
}
- (NSString *)replaceHTMLEntitiesInString:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];

    return str;
}
- (void)receivedResponseContactUs:(NSArray *)responseDict
{
     
    //NSLog(@"cont Resp%@",responseDict);
    if([[responseDict valueForKey:@"success"]isEqualToString:@"true"])
    {
        [SVProgressHUD showSuccessWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
        [self resetData];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)resetData
{
    textFieldForName.text=@"";
    textFieldForPhoneNo.text=@"";
    textFieldForEmailAddress.text=@"";
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
-(IBAction)handelcancel:(id)sender
{
    
    [currentTextField resignFirstResponder];
    NSMutableString *htmlMessage= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
    
    NSString *htmlMessageText1= nil;
    NSRange start = [htmlMessage rangeOfString:@">"];
    if (start.location != NSNotFound)
    {
        htmlMessageText1 = [htmlMessage substringFromIndex:start.location + start.length];
        NSRange end = [htmlMessageText1 rangeOfString:@"</body>"];
        if (end.location != NSNotFound)
        {
            htmlMessageText = [htmlMessageText1 substringToIndex:end.location];
        }
    }
    NSString *myStr=[self stripTags:htmlMessageText1];
    myStr=[myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    myStr=[myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
    
    if((textFieldForName.text.length==0)&(textFieldForPhoneNo.text.length==0)&(textFieldForEmailAddress.text.length==0)&[myStr isEqualToString:@""])
    {
        //[self slideViewWithAnimation];
        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    }
    else
    {
        cancelButtonClick=YES;
        [self showCancleAlert];
    }
}
-(void)showCancleAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to cancel?" preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"Yes"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                      [self handleYesButtonActionInContctUs];
                                       
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
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to cancel?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
//        [alert show];
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        [self handleYesButtonActionInContctUs];
//    }
//    cancelButtonClick=NO;
//}

-(void)handleYesButtonActionInContctUs
{
    if(cancelButtonClick)
    {
        cancelButtonClick=NO;
        [self resetData];
        //[self slideViewWithAnimation];
        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        [Parameters pushFromView:self toView:homeVC withTransition:UIViewAnimationTransitionNone];
    }
    else
    {
        UIButton *btn= [[UIButton alloc]init];
        [self handelSendMail:btn];
    }
    cancelButtonClick=NO;
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


-(BOOL)validateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL checkEmailFormatFlag = [emailTest evaluateWithObject:textFieldForEmailAddress.text];
    
    if(textFieldForName.text.length==0)
    {
        [SVProgressHUD showErrorWithStatus:@"Name is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
        
    }
    else if(textFieldForEmailAddress.text.length==0 )
    {
         [SVProgressHUD showErrorWithStatus:@"E-mail Address is required" maskType:SVProgressHUDMaskTypeBlack];
        return NO;
        
    }
    else if (textFieldForPhoneNo.text.length >10)
    {
        [SVProgressHUD showErrorWithStatus:@"Enter valid phone number" maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    else if (checkEmailFormatFlag==NO)
    {
        [SVProgressHUD showErrorWithStatus:sEnterValidEmail maskType:SVProgressHUDMaskTypeBlack];

        return NO;
    }
    
    return YES;
    
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 425, 320, 35)];
    UIBarButtonItem *space =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //toolbar.backgroundColor=[UIColor colorWithRed:147.0f/255.0f green:147.0f/255.0f blue:147.0f/255.0f alpha:1 ];
    toolbar.backgroundColor=[UIColor darkTextColor];
    
    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okToolBarBtn)];
    customItem2.tintColor = [UIColor blackColor];
    NSArray *toolbarItems = [NSArray arrayWithObjects: space, customItem2, nil];
    
    
    [toolbar setItems:toolbarItems];
    
    self.textFieldForPhoneNo.inputAccessoryView=toolbar;
    
    return YES;
}
-(void)okToolBarBtn
{
    [self.textFieldForPhoneNo resignFirstResponder];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (void)exportHTML {
    
    //NSLog(@"%@", [self getHTML]);
    
}


#pragma mark Alert View Delegate

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (alertView.tag == 101)
//    {
//        textFieldForName.text = @"";
//        textFieldForEmailAddress.text = @"";
//        textFieldForPhoneNo.text = @"";
//        [self.editorView stringByEvaluatingJavaScriptFromString:@"document.open();document.close()"];
//        NSString *filePath = [[NSBundle mainBundle] pathrswthyaerubhÅ¸≈ForResource:@"editor" ofType:@"html"];
//        NSURL *targetURL = [NSURL fileURLWithPath:filePath];
//        [self.editorView loadRequest:[NSURLRequest requestWithURL:targetURL]];
//    }
//}

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

@end

//
//  ZSSDemoViewController.m
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "ReplyViewController.h"
#import "PreviewPostViewController.h"
#import "MenuViewController.h"
#import "ZSSRichTextEditor.h"
#import "Constant.h"
@interface ReplyViewController ()

@end

@implementation ReplyViewController
@synthesize messageIdForReply,toUser,postedDtlVC,dictionaryForReply,htmlMessageTextinReply,inboxDtlVC,messagePlianTextReply,sendCopyBtn,noFileChoosenInReply;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isImagePickedInReply=NO;
    self.title = @"Reply";
    
    //replyViewControllerFlag=NO;;
    
    
    [noFileChoosenInReply setHidden:NO];

    UIBarButtonItem *rightBarBtn=[[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_btn.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(handelBackButton)];
    self.navigationItem.leftBarButtonItem=rightBarBtn;
    
    // Export HTML
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Export" style:UIBarButtonItemStylePlain target:self action:@selector(exportHTML)];
	
    // HTML Content to set in the editor
    NSString *html = @"";
    
    // Set the base URL if you would like to use relative links, such as to images.
    self.baseURL = [NSURL URLWithString:@"http://www.google.com"];
    
    // If you want to pretty print HTML within the source view.
    self.formatHTML = YES;
    
     [scrollviewObj setContentSize:CGSizeMake(0, 500)];
    
    // Set the toolbar item color
    //self.toolbarItemTintColor = [UIColor greenColor];
    
    // Set the toolbar selected color
    //self.toolbarItemSelectedTintColor = [UIColor brownColor];
    
    // Choose which toolbar items to show
    //self.enabledToolbarItems = ZSSRichTextEditorToolbarSuperscript | ZSSRichTextEditorToolbarUnderline | ZSSRichTextEditorToolbarH1 | ZSSRichTextEditorToolbarH3;
    
    // Set the HTML contents of the editor
    [self setHtml:html];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(BOOL)checkMessageField
{
    NSMutableString *htmlMessage= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
    
    htmlMessageTextinReply = nil;
    NSRange start = [htmlMessage rangeOfString:@">"];
    if (start.location != NSNotFound)
    {
        htmlMessageTextinReply = [htmlMessage substringFromIndex:start.location + start.length];
        NSRange end = [htmlMessageTextinReply rangeOfString:@"</body>"];
        if (end.location != NSNotFound)
        {
            htmlMessageTextinReply = [htmlMessageTextinReply substringToIndex:end.location];
        }
    }
    
    if ([htmlMessageTextinReply length]>0)
    {
        NSString *myStr=[self stripTags:htmlMessageTextinReply];
        
        myStr=[myStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        myStr=[myStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        myStr=[myStr stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@""];
        
        if (myStr.length==0)
        {
            [SVProgressHUD showErrorWithStatus:@"Message field could not be blank" maskType:SVProgressHUDMaskTypeBlack];
            return NO;
        }
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

-(IBAction)handelSubmit:(id)sender
{
    //NSString *yourstring = [self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
//    NSString *yourHTMLSourceCodeString = [self.editorView stringByEvaluatingJavaScriptFromString:@"document.documentElement.outerHTML"];
    
//    htmlMessageText = [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
//    
//    messagePlianText = [self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
    
//    CGFloat height = [[self.editorView stringByEvaluatingJavaScriptFromString:@"document.height"] floatValue];
//    NSNumber *number = [NSNumber numberWithFloat:height];
    if([self checkMessageField])
    {
        NSMutableString *htmlMessage= [NSMutableString stringWithString:[self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.outerHTML"]];
        
        htmlMessageTextinReply = nil;
        NSRange start = [htmlMessage rangeOfString:@">"];
        if (start.location != NSNotFound)
        {
            htmlMessageTextinReply = [htmlMessage substringFromIndex:start.location + start.length];
            NSRange end = [htmlMessageTextinReply rangeOfString:@"</body>"];
            if (end.location != NSNotFound)
            {
                htmlMessageTextinReply = [htmlMessageTextinReply substringToIndex:end.location];
            }
        }
        messagePlianTextReply = [self.editorView stringByEvaluatingJavaScriptFromString:@"document.body.innerText"];
        messagePlianTextReply = [self replacePlainMessageAmpercentInString:messagePlianTextReply];
        
        messagePlianTextReply = [Parameters encodeDataForEmogies:messagePlianTextReply];
        
       
        htmlMessageTextinReply = [self replaceHTMLEntitiesInString:htmlMessageTextinReply];
        htmlMessageTextinReply = [Parameters encodeDataForEmogies:htmlMessageTextinReply];
        
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
         if([stringForTitle isEqualToString:@"Inbox Detail Reply"])
         {
             if (isImagePickedInReply)
             {
                 isImagePickedInReply = NO;
                 [serviceIntegration ReplyMessage:self MessageId:messageIdForReply FromUser:CURRENT_USER_ID ToUser:toUser SendCopy:(sendCopyBtn.selected ? @"true": @"false") Reply:htmlMessageTextinReply PlainMessage:messagePlianTextReply FromInbox:@"true" AttachmentName:@"profile" Attachment:self.imageViewInReply.image :@selector(receivedResponseDataForPostedReplay:)];
             }
             else
             {
             [serviceIntegration ReplyMessage:self MessageId:messageIdForReply FromUser:CURRENT_USER_ID ToUser:toUser SendCopy:(sendCopyBtn.selected ? @"true": @"false") Reply:htmlMessageTextinReply PlainMessage:messagePlianTextReply FromInbox:@"true" AttachmentName:@"profile" Attachment:nil :@selector(receivedResponseDataForPostedReplay:)];
             }
         }
        else
        {
            if (isImagePickedInReply)
            {
                isImagePickedInReply = NO;
                [serviceIntegration ReplyMessage:self MessageId:messageIdForReply FromUser:CURRENT_USER_ID ToUser:toUser SendCopy:(sendCopyBtn.selected ? @"true": @"false") Reply:htmlMessageTextinReply PlainMessage:messagePlianTextReply FromInbox:@"false" AttachmentName:@"profile" Attachment:self.imageViewInReply.image :@selector(receivedResponseDataForPostedReplay:)];
            }
            else
            {
                [serviceIntegration ReplyMessage:self MessageId:messageIdForReply FromUser:CURRENT_USER_ID ToUser:toUser SendCopy:(sendCopyBtn.selected ? @"true": @"false") Reply:htmlMessageTextinReply PlainMessage:messagePlianTextReply FromInbox:@"false" AttachmentName:@"profile" Attachment:nil :@selector(receivedResponseDataForPostedReplay:)];
            }
        
        }

    }
    isImagePickedInReply=NO;
    
}


#pragma mark== Receive Response
- (void)receivedResponseDataForPostedReplay:(NSMutableArray *)responseArray
{
   
   // NSLog(@"Respons%@",responseArray);
    
    if([[responseArray valueForKey:@"success"]isEqualToString:@"true"])
    {
        [self.navigationController popViewControllerAnimated:YES];
        if(![stringForTitle isEqualToString:@"Inbox Detail Reply"])
        {
            [SVProgressHUD showSuccessWithStatus:@"Message has been sent successfully" maskType:SVProgressHUDMaskTypeBlack];
        }
        else
        {
            [SVProgressHUD dismiss];
        }
    }
    else
    {
         [SVProgressHUD dismiss];
    }
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

- (NSString *)replacePlainMessageAmpercentInString:(NSString *)str
{
    str = [str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    str = [str stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    str = [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    str = [str stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    str = [str stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    return str;
}


-(IBAction)handelTrashBtn:(id)sender
{
    [self trashAlert];
}
-(void)trashAlert
{
    if (IS_IOS8)
    {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:kAlertTitle message:@"Are you sure you want to clear this message?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self dismissViewControllerAnimated:YES completion:nil];
                                       [self handleOKAlertAction];
                                   }];
        [alertVC addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:@"Cancel"
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
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Are you sure you want to clear this message?" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
//        [alert show];
    }
}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        [self handleOKAlertAction];
//    }
//}
-(void)handleOKAlertAction
{
    self.imageViewInReply.image=[UIImage imageNamed:@"default_profile_img.png"];
    [sendCopyBtn setSelected:NO];
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
-(void)handelBackButton
{
    [self.navigationController popViewControllerAnimated:YES];
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

-(IBAction)handelSendMail:(id)sender
{
    [SVProgressHUD showSuccessWithStatus:sEmailSendSuccess maskType:SVProgressHUDMaskTypeBlack];
}


- (void)exportHTML {
    
    //NSLog(@"%@", [self getHTML]);
    
}



#pragma mark Alert View Delegate
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handelChooseFileInReply:(id)sender
{
    [noFileChoosenInReply setText:@""];
    UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
    imgPicker.editing=YES;
    imgPicker.delegate=self;
    imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
    
    self.navigationController.navigationBar.frame=CGRectMake(0, 20, SCREEN_WIDTH, 45);
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    isImagePickedInReply=YES;
     [noFileChoosenInReply setHidden:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
    //self.imageViewInReply.image=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.imageViewInReply.image=[Parameters scaleAndRotateImage:[info objectForKey:@"UIImagePickerControllerOriginalImage"] maxSize:700];
    
}
-(IBAction)handleDeleteBtn:(id)sender
{
    isImagePickedInReply=NO;
    [noFileChoosenInReply setHidden:NO];
    [noFileChoosenInReply setText:@"No file Chosen"];
    self.imageViewInReply.image = [UIImage imageNamed:@"default_profile_img.png"];
}
-(IBAction)handelSendCopy:(UIButton *)sender
{
    sender.selected=!sender.isSelected;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self dismissKeyboard];
    [currentTextField resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}
@end

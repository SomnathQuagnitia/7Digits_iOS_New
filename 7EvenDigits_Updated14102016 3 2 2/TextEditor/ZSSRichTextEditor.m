//
//  ZSSRichTextEditorViewController.m
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 11/30/13.
//  Copyright (c) 2013 Zed Said Studio. All rights reserved.
//

#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "ZSSRichTextEditor.h"
#import "ZSSBarButtonItem.h"
#import "HRColorUtil.h"
#import "ZSSTextView.h"
#import "ComposeViewController.h"
#import "Constant.h"
#import "Parameters.h"
#import "PreviewPostViewController.h"


/*
@interface UIWebBrowserView : UIView
@end

@interface UIWebBrowserView (UIWebBrowserView_Additions)
@end

@implementation UIWebBrowserView (UIWebBrowserView_Additions)

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
//    if (action == @selector(_showTextStyleOptions:)) {
//        return NO;
//    } else if (action == @selector(_promptForReplace:)) {
//        return NO;
//    } else if (action == @selector(_define:)) {
//        return NO;
//    }
    
    return [super canPerformAction:action withSender:sender];
}
@end
*/
@interface UIWebView (HackishAccessoryHiding)
@property (nonatomic, assign) BOOL hidesInputAccessoryView;
@end

@implementation UIWebView (HackishAccessoryHiding)

static const char * const hackishFixClassName = "UIWebBrowserViewMinusAccessoryView";
static Class hackishFixClass = Nil;

- (UIView *)hackishlyFoundBrowserView {
    UIScrollView *scrollView = self.scrollView;
    
    UIView *browserView = nil;
    for (UIView *subview in scrollView.subviews) {
        if ([NSStringFromClass([subview class]) hasPrefix:@"UIWebBrowserView"]) {
            browserView = subview;
            break;
        }
    }
    return browserView;
}

- (id)methodReturningNil {
    return nil;
}

- (void)ensureHackishSubclassExistsOfBrowserViewClass:(Class)browserViewClass {
    if (!hackishFixClass) {
        Class newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        newClass = objc_allocateClassPair(browserViewClass, hackishFixClassName, 0);
        IMP nilImp = [self methodForSelector:@selector(methodReturningNil)];
        class_addMethod(newClass, @selector(inputAccessoryView), nilImp, "@@:");
        objc_registerClassPair(newClass);
        
        hackishFixClass = newClass;
    }
}

- (BOOL) hidesInputAccessoryView {
    UIView *browserView = [self hackishlyFoundBrowserView];
    return [browserView class] == hackishFixClass;
}

- (void) setHidesInputAccessoryView:(BOOL)value {
    UIView *browserView = [self hackishlyFoundBrowserView];
    if (browserView == nil) {
        return;
    }
    [self ensureHackishSubclassExistsOfBrowserViewClass:[browserView class]];
	
    if (value) {
        object_setClass(browserView, hackishFixClass);
    }
    else {
        Class normalClass = objc_getClass("UIWebBrowserView");
        object_setClass(browserView, normalClass);
    }
    [browserView reloadInputViews];
}

@end

@interface ZSSRichTextEditor ()
@property (nonatomic, strong) UIScrollView *toolBarScroll;

@property (nonatomic, strong) UIImageView *textViewBackgroundImage;

@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *toolbarHolder;
@property (nonatomic, strong) NSString *htmlString;
//@property (nonatomic, strong) UIWebView *editorView;
//@property (nonatomic, strong) ZSSTextView *sourceView;
@property (nonatomic) CGRect editorViewFrame;

@property (nonatomic, strong) NSArray *editorItemsEnabled;
@property (nonatomic, strong) UIAlertView *alertView;
@property (nonatomic, strong) NSString *selectedLinkURL;
@property (nonatomic, strong) NSString *selectedLinkTitle;
@property (nonatomic, strong) NSString *selectedImageURL;
@property (nonatomic, strong) NSString *selectedImageAlt;
@property (nonatomic, strong) UIBarButtonItem *keyboardItem;
@property (nonatomic, strong) NSMutableArray *customBarButtonItems;
- (NSString *)removeQuotesFromHTML:(NSString *)html;
- (NSString *)tidyHTML:(NSString *)html;
- (void)enableToolbarItems:(BOOL)enable;
- (BOOL)isIpad;
@end

@implementation ZSSRichTextEditor
@synthesize toolbarKbd;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    editorReplyTextHeightArray=[[NSMutableArray alloc]init];
    editorReplyTextArray=[[NSMutableArray alloc]init];
    FontfamilyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
     FontSizes=[[NSArray alloc]initWithObjects: @"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14", nil];
    Formats=[[NSArray alloc]initWithObjects: @"H1",@"H2",@"H3",@"H4",@"H5",@"H6", nil];
    Styles=[[NSArray alloc]initWithObjects:@"BlueTitle",@"RedTitle",@"Marker:Yellow",@"Marker:Red",@"Big",@"Deleted Text",@"Inserted Text",@"Cited Work",@"Language:R-L",@"Language:L-R", nil];

    
    // For style font size buttons
    XPos=15;
    BtnWdth=54;
    BtnHeight=30;
    YforComposeVC=553;
    YforAddContVC=400+20;
    YforContUsVC=223;
    YforReplyVC=83;
    YforEditProfessionalProfileVC = 657+51+64;
    ToolBarHolderHeight=44;
    EidtorHeight=100;
    
    
    
    //Only fo rtext view
    if (SCREEN_HEIGHT< 568.0)//iphone 4
    {
        YComposeTextView=600;
        YAddContactTextView=433+30+40;
        YProfessionalProfileTextView=681+51+30+50;
        YContactUsTextView=265;
        YReplyTextView=120;
        YPostedMessageDetailTextView=123;
        YDraftMessageTextView=600;
    }
    if (SCREEN_HEIGHT == 568.0)//iphone 5
    {
        EidtorHeight=90;
        YComposeTextView=480;
        YAddContactTextView=429;
        YProfessionalProfileTextView=675;//645;
        YContactUsTextView=220;
        YReplyTextView=100;
        YPostedMessageDetailTextView=100;
        YDraftMessageTextView=480;
    }
    if (SCREEN_HEIGHT == 667.0)//iphone 6
    {
        EidtorHeight=70;
        YComposeTextView=400;
        YAddContactTextView=350;
        YProfessionalProfileTextView=570;
        YContactUsTextView=185;
        YReplyTextView=80;
        YPostedMessageDetailTextView=80;
        YDraftMessageTextView=400;
    }
    if (SCREEN_HEIGHT >667.0)//iphone 6+
    {
        
        EidtorHeight=70;
        YComposeTextView=351;
        YAddContactTextView=315;
        YProfessionalProfileTextView=505;
        YContactUsTextView=165;
        YReplyTextView=60;
        YPostedMessageDetailTextView=70;
        YDraftMessageTextView=351;
    }
  
    if([stringForTitle isEqualToString:@"Compose"])
    {
         frame = CGRectMake(10,YComposeTextView, self.view.frame.size.width-20,EidtorHeight);
         toolBarHolderframe=CGRectMake(-3, 502, self.view.frame.size.width+5,ToolBarHolderHeight);
         textStylesFrame=CGRectMake(5, YforComposeVC, BtnWdth, BtnHeight);
         textFormatframe=CGRectMake(60, YforComposeVC, BtnWdth, BtnHeight);
         textFontFrame=CGRectMake(118, YforComposeVC, 40, BtnHeight);
         textSizeFrame=CGRectMake(155, YforComposeVC, BtnWdth, BtnHeight);
         textColorframe=CGRectMake(206, YforComposeVC, 34, BtnHeight);
         textBgColorframe=CGRectMake(244, YforComposeVC, 34, BtnHeight);
         keyBoardBtnframe=CGRectMake(280, YforComposeVC, 34, BtnHeight);
    }
    else if([stringForTitle isEqualToString:@"Add Contact"])
    {
        borderWidth = 2.0f;
        frame = CGRectMake(10,YAddContactTextView, self.view.frame.size.width-30,EidtorHeight);
        toolBarHolderframe=CGRectMake(-3, 435+20, self.view.frame.size.width+5,ToolBarHolderHeight);
        textStylesFrame=CGRectMake(5, YforAddContVC, BtnWdth, BtnHeight);
        textFormatframe=CGRectMake(60, YforAddContVC, BtnWdth, BtnHeight);
        textFontFrame=CGRectMake(118, YforAddContVC, 40, BtnHeight);
        textSizeFrame=CGRectMake(155, YforAddContVC, BtnWdth, BtnHeight);
        textColorframe=CGRectMake(206, YforAddContVC, 34, BtnHeight);
        textBgColorframe=CGRectMake(244, YforAddContVC, 34, BtnHeight);
        keyBoardBtnframe=CGRectMake(280, YforAddContVC, 34, BtnHeight);
    }
    else if([stringForTitle isEqualToString:@"Update Contact"])

    {
        borderWidth = 2.0f;

        frame = CGRectMake(10,YAddContactTextView, self.view.frame.size.width-30,EidtorHeight);  //***nishi

        toolBarHolderframe=CGRectMake(-3,353+65, self.view.frame.size.width+5,ToolBarHolderHeight);
        textStylesFrame=CGRectMake(5, YforAddContVC, BtnWdth, BtnHeight);
        textFormatframe=CGRectMake(60, YforAddContVC, BtnWdth, BtnHeight);
        textFontFrame=CGRectMake(118, YforAddContVC, 40, BtnHeight);
        textSizeFrame=CGRectMake(155, YforAddContVC, BtnWdth, BtnHeight);
        textColorframe=CGRectMake(206, YforAddContVC, 34, BtnHeight);
        textBgColorframe=CGRectMake(244, YforAddContVC, 34, BtnHeight);
        keyBoardBtnframe=CGRectMake(280, YforAddContVC, 34, BtnHeight);

    }
    else if([stringForTitle isEqualToString:@"Update Professional Profile"])
        
    {
        borderWidth = 2.0f;
        frame = CGRectMake(10,YProfessionalProfileTextView, self.view.frame.size.width-30,EidtorHeight);// webview for text
        toolBarHolderframe=CGRectMake(-3,607+51+65, self.view.frame.size.width+5,ToolBarHolderHeight);
        textStylesFrame=CGRectMake(5, YforEditProfessionalProfileVC, BtnWdth, BtnHeight);
        textFormatframe=CGRectMake(60, YforEditProfessionalProfileVC, BtnWdth, BtnHeight);
        textFontFrame=CGRectMake(118, YforEditProfessionalProfileVC, 40, BtnHeight);
        textSizeFrame=CGRectMake(155, YforEditProfessionalProfileVC, BtnWdth, BtnHeight);
        textColorframe=CGRectMake(206, YforEditProfessionalProfileVC, 34, BtnHeight);
        textBgColorframe=CGRectMake(244, YforEditProfessionalProfileVC, 34, BtnHeight);
        keyBoardBtnframe=CGRectMake(280, YforEditProfessionalProfileVC, 34, BtnHeight);
    }
    
    else if([stringForTitle isEqualToString:@"Contact Us"])
    {
        borderWidth = 2.0f;
        frame = CGRectMake(self.view.frame.origin.x+10,YContactUsTextView, self.view.frame.size.width-30,EidtorHeight);
        toolBarHolderframe=CGRectMake(self.view.frame.origin.x-3, 172, self.view.frame.size.width+5,ToolBarHolderHeight);
        textStylesFrame=CGRectMake(5, YforContUsVC, BtnWdth, BtnHeight);
        textFormatframe=CGRectMake(60, YforContUsVC, BtnWdth, BtnHeight);
        textFontFrame=CGRectMake(118, YforContUsVC, 40, BtnHeight);
        textSizeFrame=CGRectMake(155, YforContUsVC, BtnWdth, BtnHeight);
        textColorframe=CGRectMake(206, YforContUsVC, 34, BtnHeight);
        textBgColorframe=CGRectMake(244, YforContUsVC, 34, BtnHeight);
        keyBoardBtnframe=CGRectMake(280, YforContUsVC, 34, BtnHeight);

    }
    else if([stringForTitle isEqualToString:@"Inbox Detail Reply"])
    {
        //borderWidth = 2.0f;
       frame = CGRectMake(self.view.frame.origin.x+10,YReplyTextView, self.view.frame.size.width-24,EidtorHeight);
        
        toolBarHolderframe=CGRectMake(self.view.frame.origin.x-3, 32, self.view.frame.size.width+5,ToolBarHolderHeight);
        textStylesFrame=CGRectMake(5, YforReplyVC, BtnWdth, BtnHeight);
        textFormatframe=CGRectMake(60, YforReplyVC, BtnWdth, BtnHeight);
        textFontFrame=CGRectMake(118, YforReplyVC, 40, BtnHeight);
        textSizeFrame=CGRectMake(155, YforReplyVC, BtnWdth, BtnHeight);
        textColorframe=CGRectMake(206, YforReplyVC, 34, BtnHeight);
        textBgColorframe=CGRectMake(244, YforReplyVC, 34, BtnHeight);
        keyBoardBtnframe=CGRectMake(280, YforReplyVC, 34, BtnHeight);
        submitReplyframe=CGRectMake(self.view.frame.origin.x+25, YforReplyVC+185, self.view.frame.size.width-50, 37);
    }
    else if([stringForTitle isEqualToString:@"Posted Message Detail"])
    {
        frame = CGRectMake(self.view.frame.origin.x+10,YPostedMessageDetailTextView, self.view.frame.size.width-24,EidtorHeight);
        toolBarHolderframe=CGRectMake(self.view.frame.origin.x-3, 32, self.view.frame.size.width+5,ToolBarHolderHeight);
        textStylesFrame=CGRectMake(5, YforReplyVC, BtnWdth, BtnHeight);
        textFormatframe=CGRectMake(60, YforReplyVC, BtnWdth, BtnHeight);
        textFontFrame=CGRectMake(118, YforReplyVC, 40, BtnHeight);
        textSizeFrame=CGRectMake(155, YforReplyVC, BtnWdth, BtnHeight);
        textColorframe=CGRectMake(206, YforReplyVC, 34, BtnHeight);
        textBgColorframe=CGRectMake(244, YforReplyVC, 34, BtnHeight);
        keyBoardBtnframe=CGRectMake(280, YforReplyVC, 34, BtnHeight);
        submitReplyframe=CGRectMake(self.view.frame.origin.x+25, YforReplyVC+185, self.view.frame.size.width-50, 37);
    }
    else if ([stringForTitle isEqualToString:@"DraftMessage"])
    {
        frame = CGRectMake(10,YDraftMessageTextView, self.view.frame.size.width-20,EidtorHeight);
        toolBarHolderframe=CGRectMake(-3, 502, self.view.frame.size.width+5,ToolBarHolderHeight);
        textStylesFrame=CGRectMake(5, YforComposeVC, BtnWdth, BtnHeight);
        textFormatframe=CGRectMake(60, YforComposeVC, BtnWdth, BtnHeight);
        textFontFrame=CGRectMake(118, YforComposeVC, 40, BtnHeight);
        textSizeFrame=CGRectMake(155, YforComposeVC, BtnWdth, BtnHeight);
        textColorframe=CGRectMake(206, YforComposeVC, 34, BtnHeight);
        textBgColorframe=CGRectMake(244, YforComposeVC, 34, BtnHeight);
        keyBoardBtnframe=CGRectMake(280, YforComposeVC, 34, BtnHeight);
    }
    
    self.sourceView = [[ZSSTextView alloc] initWithFrame:frame];
    self.sourceView.frame = CGRectInset(frame, -borderWidth, -borderWidth);
    self.sourceView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.sourceView.layer.borderWidth = borderWidth;
    //[self.sourceView.layer setCornerRadius:10];
    self.sourceView.hidden = YES;
    self.sourceView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.sourceView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.sourceView.font = [UIFont fontWithName:@"Courier" size:13.0];
    self.sourceView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.sourceView.autoresizesSubviews = YES;
    self.sourceView.delegate = self;
    self.sourceView.backgroundColor = [UIColor whiteColor];
    self.sourceView.tag=101;
    self.sourceView.scrollEnabled = YES;
    self.sourceView.scrollsToTop = NO;
    [scrollviewObj addSubview:self.sourceView];
    
    
    
    
    
    // Editor View
    self.editorView = [[UIWebView alloc] initWithFrame:frame];
    self.editorView.frame = CGRectInset(frame, -borderWidth, -borderWidth);
    self.editorView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.editorView.layer.borderWidth = borderWidth;
    //[self.editorView.layer setCornerRadius:5];
    self.editorView.delegate = self;

    //self.editorView.hidesInputAccessoryView = YES;
    self.editorView.scalesPageToFit = NO;
    self.editorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    //self.editorView.dataDetectorTypes = UIDataDetectorTypeNone;
    self.editorView.scrollView.bounces = NO;
    self.editorView.backgroundColor = [UIColor whiteColor];
    self.editorView.tag=102;
    [scrollviewObj addSubview:self.editorView];

    
    
    toolbarKbd = [[UIToolbar alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 251, self.view.frame.size.width, 35)];
    objRefTool=toolbarKbd;
//    toolbarKbd.barTintColor = [UIColor lightGrayColor];
//    toolbarKbd.layer.borderColor = [UIColor blackColor].CGColor;
//    toolbarKbd.layer.borderWidth = 0.2f;
    //[self.editorView.layer setCornerRadius:5];
    
//    UIBarButtonItem *space =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIBarButtonItem *customItem2 = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(okToolBarBtn)];
//    [customItem2 setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor],  UITextAttributeTextColor,nil] forState:UIControlStateNormal];
//
//    NSArray *toolbarItems = [NSArray arrayWithObjects:space, customItem2, nil];
//    [toolbarKbd setItems:toolbarItems];
//    
//    [self.view addSubview:toolbarKbd];
//    toolbarKbd.hidden = YES;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden)
//                                                 name:UIKeyboardWillHideNotification object:self.view.window];
    
   
    // Scrolling View
    self.toolBarScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(-3, 0, [self isIpad] ? self.view.frame.size.width : self.view.frame.size.width+5, 44)];
    //self.toolBarScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(25, 260, [self isIpad] ? frame.size.width : frame.size.width - 44, 44)];
    //self.toolBarScroll.backgroundColor = [UIColor redColor];
    self.toolBarScroll.showsHorizontalScrollIndicator = NO;
    self.toolBarScroll.bounces=NO;
    
    // Toolbar with icons
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectZero];
    self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //self.toolbar.backgroundColor = [UIColor greenColor];
    if (IS_OS_8_OR_LATER) {
     [self.toolbar setBackgroundImage:[UIImage imageNamed:@"editor_bgk.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.toolbar setBackgroundImage:[UIImage imageNamed:@"editor_bg@2x.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
    //[self.toolbar setBackgroundImage:[UIImage imageNamed:@"editor_bg@2x.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.toolBarScroll addSubview:self.toolbar];
    self.toolBarScroll.autoresizingMask = self.toolbar.autoresizingMask;
    
    // Background Toolbar
    UIToolbar *backgroundToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(-3, 0, frame.size.width+5, 44)];
    //UIToolbar *backgroundToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(25, 260, 270,44)];
    backgroundToolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    //Text Font
    textFont=[UIButton buttonWithType:UIButtonTypeCustom];
    [textFont addTarget:self action:@selector(setTextFont) forControlEvents:UIControlEventTouchUpInside];
    [textFont setImage:[UIImage imageNamed:@"editor_font_btn.png"] forState:UIControlStateNormal];
    textFont.frame=textFontFrame;
    [scrollviewObj addSubview:textFont];
    
    //Text Size
    textSize=[UIButton buttonWithType:UIButtonTypeCustom];
    [textSize addTarget:self action:@selector(setTextSize) forControlEvents:UIControlEventTouchUpInside];
    [textSize setImage:[UIImage imageNamed:@"editor_size_btn.png"] forState:UIControlStateNormal];
    textSize.frame=textSizeFrame;
    [scrollviewObj addSubview:textSize];
    
    
    
    //TextColor And textBackgroundcolor
    UIButton *textColorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [textColorBtn addTarget:self action:@selector(textColor) forControlEvents:UIControlEventTouchUpInside];
    [textColorBtn setImage:[UIImage imageNamed:@"editor_textcolor_btn.png"] forState:UIControlStateNormal];
    textColorBtn.frame=textColorframe;
    [scrollviewObj addSubview:textColorBtn];
    
    
    UIButton *textBackgroundColorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [textBackgroundColorBtn addTarget:self action:@selector(bgColor) forControlEvents:UIControlEventTouchUpInside];
    [textBackgroundColorBtn setImage:[UIImage imageNamed:@"editor_textbackground_btn.png"] forState:UIControlStateNormal];
    textBackgroundColorBtn.frame=textBgColorframe;
    [scrollviewObj addSubview:textBackgroundColorBtn];
    
    UIButton *formatBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [formatBtn addTarget:self action:@selector(setTextFormat) forControlEvents:UIControlEventTouchUpInside];
    [formatBtn setImage:[UIImage imageNamed:@"editor_format_btn.png"] forState:UIControlStateNormal];
    formatBtn.frame=textFormatframe;
    [scrollviewObj addSubview:formatBtn];
    
    UIButton *stylesBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [stylesBtn addTarget:self action:@selector(setTextStyle) forControlEvents:UIControlEventTouchUpInside];
    [stylesBtn setImage:[UIImage imageNamed:@"editor_styles_btn.png"] forState:UIControlStateNormal];
    stylesBtn.frame=textStylesFrame;
    [scrollviewObj addSubview:stylesBtn];
    
    
//    UIButton *submitReplyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [submitReplyBtn addTarget:self action:@selector(handelSubmitButtonClkick) forControlEvents:UIControlEventTouchUpInside];
//    [submitReplyBtn setImage:[UIImage imageNamed:@"submit_btn.png"] forState:UIControlStateNormal];
//    submitReplyBtn.frame=submitReplyframe;
//    [scrollviewObj addSubview:submitReplyBtn];
    
    UIButton *keyBoardBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [keyBoardBtn addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
    [keyBoardBtn setImage:[UIImage imageNamed:@"bt_key.png"] forState:UIControlStateNormal];
    keyBoardBtn.frame=keyBoardBtnframe;
    [scrollviewObj addSubview:keyBoardBtn];
    
    
    //    UIImageView *toolbarBackImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tolbc.png"]];
    //    toolbarBackImage.frame=CGRectMake(0, 0, frame.size.width, 44);
    //
    //
    
    
    // Parent holding view
    //self.toolbarHolder = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
    self.toolbarHolder = [[UIView alloc] initWithFrame:toolBarHolderframe];
    //self.toolbar.backgroundColor=[UIColor purpleColor];
    self.toolbarHolder.autoresizingMask = self.toolbar.autoresizingMask;
    [self.toolbarHolder addSubview:self.toolBarScroll];
    [self.toolbarHolder insertSubview:backgroundToolbar atIndex:0];
    
    
    // [self.toolbarHolder addSubview:toolbarBackImage];
    
    // Hide Keyboard
    // if (![self isIpad]) {
    
    /*
    
    // Toolbar holder used to crop and position toolbar
    UIView *toolbarCropper = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width-44, 0, 44, 44)];
    //UIView *toolbarCropper = [[UIView alloc] initWithFrame:CGRectMake(300, 276, 44, 44)];
    toolbarCropper.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    toolbarCropper.clipsToBounds = YES;
    
    // Use a toolbar so that we can tint
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(-7, -1, 44, 44)];
    // UIToolbar *keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(300, 276, 44, 44)];
    [toolbarCropper addSubview:keyboardToolbar];
    
    self.keyboardItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSkeyboard.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissKeyboard)];
    keyboardToolbar.items = @[self.keyboardItem];
    [self.toolbarHolder addSubview:toolbarCropper];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.6f, 44)];
    // UIView *line = [[UIView alloc] initWithFrame:CGRectMake(300, 276, 0.6f, 44)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.7f;
    [toolbarCropper addSubview:line];
    
    */
    
    [scrollviewObj addSubview:self.toolbarHolder];
    
    // Build the toolbar
    [self buildToolbar];
    
    //[self.toolbarHolder setUserInteractionEnabled:NO];

}

//- (void)keyboardWasShown
//{
//    [self.toolbarHolder setUserInteractionEnabled:YES];
//    //toolbarKbd.hidden = NO;
//}
//-(IBAction)handelSave:(id)sender
//{
//    [Parameters showalrt:@"Message Saved Successfuly" aDelegate:self];
//}

//Compse Screen Actions

//- (void)keyboardWillBeHidden
//{
//    [self.toolbarHolder setUserInteractionEnabled:NO];
//    //toolbarKbd.hidden = YES;
//}

-(void)okToolBarBtn
{
    //[self keyboardWillBeHidden];
    [self dismissKeyboard];
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{

    if(self.editorView.tag==102 || self.sourceView.tag==101)
    {
        [self animateTextView: textView up: YES];
        
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if((self.editorView.tag==102 || self.sourceView.tag==101))
    {
        [self animateTextView: textView up: NO];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self scrollTextViewToBottom:textView];
    return YES;
}

-(void)scrollTextViewToBottom:(UITextView *)textView
{
    if(self.sourceView.text.length > 0 )
    {
        NSRange bottom = NSMakeRange(self.sourceView.text.length -1, 2);
        [self.sourceView scrollRangeToVisible:bottom];
    }
}
//Password text animation



- (void) animateTextView: (UITextView*) textField up: (BOOL) up
{
    
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}



- (void)setEnabledToolbarItems:(ZSSRichTextEditorToolbar)enabledToolbarItems {
    _enabledToolbarItems = enabledToolbarItems;
    [self buildToolbar];
}


- (void)setToolbarItemTintColor:(UIColor *)toolbarItemTintColor {
    
    _toolbarItemTintColor = toolbarItemTintColor;
    
    // Update the color
    for (ZSSBarButtonItem *item in self.toolbar.items)
    {
        item.tintColor = [self barButtonItemDefaultColor];
    }
    self.keyboardItem.tintColor = toolbarItemTintColor;
    
}


- (void)setToolbarItemSelectedTintColor:(UIColor *)toolbarItemSelectedTintColor {
    _toolbarItemSelectedTintColor = toolbarItemSelectedTintColor;
}


- (NSArray *)itemsForToolbar {
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    // None
    if(_enabledToolbarItems & ZSSRichTextEditorToolbarNone)
    {
        return items;
    }
    
    // Bold
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarBold || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        bold = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_bold_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]style:UIBarButtonItemStylePlain target:self action:@selector(setBold)];
        bold.label = @"bold";
        [items addObject:bold];
        
    }
    
    // Italic
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarItalic || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        italic = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_italic_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setItalic)];
        italic.label = @"italic";
        [items addObject:italic];
    }
    
    // Underline
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarUnderline || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        underline = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_underline_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setUnderline)];
        underline.label = @"underline";
        [items addObject:underline];
    }

    // Strike Through
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarStrikeThrough || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        strikeThrough = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_strikethrough_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setStrikethrough)];
        strikeThrough.label = @"strikeThrough";
        [items addObject:strikeThrough];
    }
    
    // Subscript
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarSubscript || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        subscript = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_subscript_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setSubscript)];
        subscript.label = @"subscript";
        [items addObject:subscript];
    }
    
    // Superscript
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarSuperscript || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        superscript = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_superscript_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setSuperscript)];
        superscript.label = @"superscript";
        [items addObject:superscript];
    }
    
  
    // Remove Format
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarRemoveFormat || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        removeFormat = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_removeformat_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(removeFormat)];
        removeFormat.label = @"removeFormat";
        [items addObject:removeFormat];
    }
    
    // Ordered List
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarOrderedList || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ol = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_orderedlist_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setOrderedList)];
        ol.label = @"orderedList";
        [items addObject:ol];
    }

    // Unordered List
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarUnorderedList || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ul = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_unorderedlist_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setUnorderedList)];
        ul.label = @"unorderedList";
        [items addObject:ul];
    }
    
    // Outdent
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarOutdent || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        outdent = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_outdent_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setOutdent)];
        outdent.label = @"outdent";
        [items addObject:outdent];
    }
    
    // Indent
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarIndent || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        indent = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_indeed_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setIndent)];
        indent.label = @"indent";
        [items addObject:indent];
    }
    
    // Quoted Justify
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarQuoted || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        quotedJustify = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_quotedjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setQuotedJustify)];
        quotedJustify.label = @"quoted";
        [items addObject:quotedJustify];
    }
    
    // Align Left
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarJustifyLeft || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        alignLeft = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_leftjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(alignLeft)];
        alignLeft.label = @"justifyLeft";
        [items addObject:alignLeft];
    }
    
    // Align Center
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarJustifyCenter || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        alignCenter = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_centerjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(alignCenter)];
        alignCenter.label = @"justifyCenter";
        [items addObject:alignCenter];
    }
    
    // Align Right
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarJustifyRight || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        alignRight = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_rightjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(alignRight)];
        alignRight.label = @"justifyRight";
        [items addObject:alignRight];
    }
    
    // Align Justify
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarJustifyFull || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        alignFull = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_forcejustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(alignFull)];
        alignFull.label = @"justifyFull";
        [items addObject:alignFull];
    }
    
    // Left justfyPie 
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarLeftJustifyPie || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        leftJustifyPie = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_leftjustifypie_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setLeftJustifyPie)];
        leftJustifyPie.label = @"leftJustifyPie";
        [items addObject:leftJustifyPie];
    }
    
    // Right justfyPie
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarRightJustifyPie || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        rightJustifyPie = [[ZSSBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"editor_rightjustifypie_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] style:UIBarButtonItemStylePlain target:self action:@selector(setRightJustifyPie)];
        rightJustifyPie.label = @"leftJustifyPie";
        [items addObject:rightJustifyPie];
    }


    
    
    // Undo
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarUndo || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *undoButton = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSundo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(undo:)];
        undoButton.label = @"undo";
        [items addObject:undoButton];
    }
    /*
    // Redo
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarRedo || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *redoButton = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSredo.png"] style:UIBarButtonItemStylePlain target:self action:@selector(redo:)];
        redoButton.label = @"redo";
        [items addObject:redoButton];
    }
    */
        /*
    // Header 1
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarH1 || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *h1 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh1.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heading1)];
        h1.label = @"h1";
        [items addObject:h1];
    }
    
    // Header 2
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarH2 || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *h2 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh2.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heading2)];
        h2.label = @"h2";
        [items addObject:h2];
    }
    
    // Header 3
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarH3 || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *h3 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh3.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heading3)];
        h3.label = @"h3";
        [items addObject:h3];
    }
    
    // Heading 4
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarH4 || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *h4 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh4.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heading4)];
        h4.label = @"h4";
        [items addObject:h4];
    }
    
    // Header 5
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarH5 || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *h5 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh5.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heading5)];
        h5.label = @"h5";
        [items addObject:h5];
    }
    
    // Heading 6
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarH6 || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *h6 = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSh6.png"] style:UIBarButtonItemStylePlain target:self action:@selector(heading6)];
        h6.label = @"h6";
        [items addObject:h6];
    }
    */
#pragma mark== Text Color
    /*
    // Text Color
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarTextColor || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *textColor = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSStextcolor.png"] style:UIBarButtonItemStylePlain target:self action:@selector(textColor)];
        textColor.label = @"textColor";
        [items addObject:textColor];
    }
    
    // Background Color
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarBackgroundColor || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *bgColor = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSbgcolor.png"] style:UIBarButtonItemStylePlain target:self action:@selector(bgColor)];
        bgColor.label = @"backgroundColor";
        [items addObject:bgColor];
    }
    
     */
     
    
    
    
    /*
    // Horizontal Rule
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarHorizontalRule || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
        ZSSBarButtonItem *hr = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSShorizontalrule.png"] style:UIBarButtonItemStylePlain target:self action:@selector(setHR)];
        hr.label = @"horizontalRule";
        [items addObject:hr];
    }
    */
    
//    // Image
//    if (_enabledToolbarItems & ZSSRichTextEditorToolbarInsertImage || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
//        ZSSBarButtonItem *insertImage = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSimage.png"] style:UIBarButtonItemStylePlain target:self action:@selector(insertImage)];
//        insertImage.label = @"image";
//        [items addObject:insertImage];
//    }
//
//    
//    // Insert Link
//    if (_enabledToolbarItems & ZSSRichTextEditorToolbarInsertLink || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
//        ZSSBarButtonItem *insertLink = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSlink.png"] style:UIBarButtonItemStylePlain target:self action:@selector(insertLink)];
//        insertLink.label = @"link";
//        [items addObject:insertLink];
//    }
//    
//    // Remove Link
//    if (_enabledToolbarItems & ZSSRichTextEditorToolbarRemoveLink || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
//        ZSSBarButtonItem *removeLink = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSunlink.png"] style:UIBarButtonItemStylePlain target:self action:@selector(removeLink)];
//        removeLink.label = @"removeLink";
//        [items addObject:removeLink];
//    }
//    
//    // Quick Link
//    if (_enabledToolbarItems & ZSSRichTextEditorToolbarQuickLink || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
//        ZSSBarButtonItem *quickLink = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSquicklink.png"] style:UIBarButtonItemStylePlain target:self action:@selector(quickLink)];
//        quickLink.label = @"quickLink";
//        [items addObject:quickLink];
//    }
//    
//    // Show Source
//    if (_enabledToolbarItems & ZSSRichTextEditorToolbarViewSource || _enabledToolbarItems & ZSSRichTextEditorToolbarAll) {
//        ZSSBarButtonItem *showSource = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSSviewsource.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showHTMLSource:)];
//        showSource.label = @"source";
//        [items addObject:showSource];
//    }
    
     
    return [NSArray arrayWithArray:items];
    
}
#pragma mark ==TextColor And TextBackgroundColor
//-(void)textColorforCompose
//{
//    [composeVCObj.textColorButton addTarget:self action:@selector(selectTextColor) forControlEvents:UIControlEventTouchUpInside];
//    
//}
-(void)selectTextColor
{
    if (_enabledToolbarItems & ZSSRichTextEditorToolbarTextColor || _enabledToolbarItems & ZSSRichTextEditorToolbarAll)
    {
        ZSSBarButtonItem *textColor = [[ZSSBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ZSStextcolor.png"] style:UIBarButtonItemStylePlain target:self action:@selector(textColor)];
        textColor.label = @"textColor";
    }
}
- (void)buildToolbar {
    
    // Check to see if we have any toolbar items, if not, add them all
    NSArray *items = [self itemsForToolbar];
    if (items.count == 0 && !(_enabledToolbarItems & ZSSRichTextEditorToolbarNone)) {
        _enabledToolbarItems = ZSSRichTextEditorToolbarAll;
        items = [self itemsForToolbar];
    }
    
    // get the width before we add custom buttons
    CGFloat toolbarWidth = items.count == 0 ? 0.0f : (CGFloat)(items.count * 39) - 10;
    
    if(self.customBarButtonItems != nil)
    {
        items = [items arrayByAddingObjectsFromArray:self.customBarButtonItems];
        for(ZSSBarButtonItem *buttonItem in self.customBarButtonItems)
        {
            toolbarWidth += buttonItem.customView.frame.size.width + 11.0f;
        }
    }
    
    self.toolbar.items = items;
    for (ZSSBarButtonItem *item in items) {
        item.tintColor = [self barButtonItemDefaultColor];
    }
    
    self.toolbar.frame = CGRectMake(0, 0, toolbarWidth, 44);
    self.toolBarScroll.contentSize = CGSizeMake(self.toolbar.frame.size.width, 44);
}


- (void)viewWillAppear:(BOOL)animated
{
    //[self keyboardWillBeHidden];
    [super viewWillAppear:animated];
    //[self.toolbarHolder setUserInteractionEnabled:NO];

    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
   //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowOrHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)focusTextEditor
{
    self.editorView.keyboardDisplayRequiresUserAction = NO;
    NSString *js = [NSString stringWithFormat:@"zss_editor.focusEditor();"];
    [self.editorView stringByEvaluatingJavaScriptFromString:js];
}

- (void)blurTextEditor
{
    NSString *js = [NSString stringWithFormat:@"zss_editor.blurEditor();"];
    [self.editorView stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark - Editor Interaction

- (void)setHtml:(NSString *)html
{
    if (!self.resourcesLoaded)
    {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
        NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
        NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
        NSString *source = [[NSBundle mainBundle] pathForResource:@"ZSSRichTextEditor" ofType:@"js"];
        NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
        htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--content-->" withString:html];
        
        [self.editorView loadHTMLString:htmlString baseURL:self.baseURL];
        self.resourcesLoaded = YES;
    }
    self.sourceView.keyboardType = UIKeyboardTypeASCIICapable;
    self.sourceView.text = html;
    NSString *cleanedHTML = [self removeQuotesFromHTML:self.sourceView.text];
	NSString *trigger = [NSString stringWithFormat:@"zss_editor.setHTML(\"%@\");", cleanedHTML];
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
}

- (NSString *)getHTML
{
    NSString *html = [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.getHTML();"];
    html = [self removeQuotesFromHTML:html];
    html = [self tidyHTML:html];
	return html;
}

- (void)dismissKeyboard {
//    [self.editorView stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur()"];
//    [self.sourceView resignFirstResponder];
    [self.view endEditing:YES];
}


//- (void)focus {
//    [self.editorView stringByEvaluatingJavaScriptFromString:@"document.activeElement.focus()"];
//}

- (void)showHTMLSource:(ZSSBarButtonItem *)barButtonItem
{
    if (self.sourceView.hidden) {
        self.sourceView.text = [self getHTML];
        self.sourceView.hidden = NO;
        barButtonItem.tintColor = [UIColor blackColor];
        self.editorView.hidden = YES;
        [self enableToolbarItems:NO];
    } else {
        [self setHtml:self.sourceView.text];
        barButtonItem.tintColor = [self barButtonItemDefaultColor];
        self.sourceView.hidden = YES;
        self.editorView.hidden = NO;
        [self enableToolbarItems:YES];
    }
}

- (void)removeFormat
{
    NSString *trigger = @"zss_editor.removeFormating();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!removeFormatPress)
    {
        removeFormatPress=YES;
        removeFormat.image=[[UIImage imageNamed:@"editor_removeformat_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        removeFormatPress=NO;
        removeFormat.image=[[UIImage imageNamed:@"editor_removeformat_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)alignLeft {
    NSString *trigger = @"zss_editor.setJustifyLeft();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    if(!alignLeftPress)
    {
        if((alignRightPress)||(alignFullPress)||(alignCenterPress))
        {
            alignCenterPress=NO;
            alignCenterPress=NO;
            alignRightPress=NO;
            alignCenter.image=[[UIImage imageNamed:@"editor_centerjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            alignRight.image=[[UIImage imageNamed:@"editor_rightjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            alignFull.image=[[UIImage imageNamed:@"editor_forcejustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];

        }
        alignLeftPress=YES;
        alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        alignLeftPress=NO;
        alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)alignCenter {
    NSString *trigger = @"zss_editor.setJustifyCenter();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    

    if(!alignCenterPress)
    {
        if((alignRightPress)||(alignFullPress)||(alignLeftPress))
        {
            alignCenterPress=NO;
            alignLeftPress=NO;
            alignRightPress=NO;
            
            alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            alignRight.image=[[UIImage imageNamed:@"editor_rightjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            alignFull.image=[[UIImage imageNamed:@"editor_forcejustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            
        }
        alignCenterPress=YES;
        alignCenter.image=[[UIImage imageNamed:@"editor_centerjustify_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        alignCenterPress=NO;
        alignCenter.image=[[UIImage imageNamed:@"editor_centerjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)alignRight {
    NSString *trigger = @"zss_editor.setJustifyRight();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!alignRightPress)
    {
        if((alignCenterPress)||(alignFullPress)||(alignLeftPress))
        {
            alignCenterPress=NO;
            alignLeftPress=NO;
            alignFullPress=NO;
            
            alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            alignCenter.image=[[UIImage imageNamed:@"editor_centerjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            alignFull.image=[[UIImage imageNamed:@"editor_forcejustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            
        }
        alignRightPress=YES;
        alignRight.image=[[UIImage imageNamed:@"editor_rightjustify_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        alignRightPress=NO;
        alignRight.image=[[UIImage imageNamed:@"editor_rightjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)alignFull {
    NSString *trigger = @"zss_editor.setJustifyFull();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!alignFullPress)
    {
        if((leftJustifyPiePress)||(rightJustifyPiePress))
        {
            if((alignRightPress) || (alignLeftPress))
            {
                alignRightPress=NO;
                alignRight.image=[[UIImage imageNamed:@"editor_rightjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
                
                alignLeftPress=NO;
                alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
            }
        }
        alignFullPress=YES;
        alignFull.image=[[UIImage imageNamed:@"editor_forcejustify_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        alignFullPress=NO;
        alignFull.image=[[UIImage imageNamed:@"editor_forcejustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)setBold {
    NSString *trigger = @"zss_editor.setBold();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];

    if(!boldPress)
    {
        boldPress=YES;
    bold.image=[[UIImage imageNamed:@"editor_bold_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        boldPress=NO;
        bold.image=[[UIImage imageNamed:@"editor_bold_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
   
}

- (void)setItalic {

    NSString *trigger = @"zss_editor.setItalic();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!italicPress)
    {
        italicPress=YES;
        italic.image=[[UIImage imageNamed:@"editor_italic_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        italicPress=NO;
        italic.image=[[UIImage imageNamed:@"editor_italic_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
   
}

- (void)setSubscript {
    NSString *trigger = @"zss_editor.setSubscript();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!subscriptPress)
    {
        subscriptPress=YES;
        subscript.image=[[UIImage imageNamed:@"editor_subscript_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        subscriptPress=NO;
        subscript.image=[[UIImage imageNamed:@"editor_subscript_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)setUnderline {
    NSString *trigger = @"zss_editor.setUnderline();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!underlinePress)
    {
        underlinePress=YES;
        underline.image=[[UIImage imageNamed:@"editor_underline_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        underlinePress=NO;
        underline.image=[[UIImage imageNamed:@"editor_underline_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }

}

- (void)setSuperscript {
    NSString *trigger = @"zss_editor.setSuperscript();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!superscriptPress)
    {
        superscriptPress=YES;
        superscript.image=[[UIImage imageNamed:@"editor_superscript_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        superscriptPress=NO;
        superscript.image=[[UIImage imageNamed:@"editor_superscript_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}
-(void)setQuotedJustify
{
    NSString *trigger = @"zss_editor.setJustifyLeft();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!quotedJustifyPress)
    {
        quotedJustifyPress=YES;
        quotedJustify.image=[[UIImage imageNamed:@"editor_quotedjustify_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        leftJustifyPie.image=[[UIImage imageNamed:@"editor_leftjustifypie_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        quotedJustifyPress=NO;
        quotedJustify.image=[[UIImage imageNamed:@"editor_quotedjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
}
-(void)setLeftJustifyPie
{
    
    
    if(!leftJustifyPiePress)
    {
        leftJustifyPiePress=YES;
        rightJustifyPiePress=NO;
        if(alignFullPress)
        {
            NSString *trigger = @"zss_editor.setJustifyFull();";
            [self.editorView stringByEvaluatingJavaScriptFromString:trigger];

            alignLeftPress=NO;
            alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else
        {
            NSString *trigger = @"zss_editor.setJustifyLeft();";
            [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
            
            alignLeftPress=YES;
            alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            
        }
        //set Selected images of left alignment
        
        leftJustifyPie.image=[[UIImage imageNamed:@"editor_leftjustifypie_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        //set UnSelected images of Right alignment
        rightJustifyPie.image=[[UIImage imageNamed:@"editor_rightjustifypie_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        alignRight.image=[[UIImage imageNamed:@"editor_rightjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       
    }
    else
    {
        leftJustifyPiePress=NO;
    }
}
-(void)setRightJustifyPie
{
   
    
    if(!rightJustifyPiePress)
    {
        leftJustifyPiePress=NO;
        rightJustifyPiePress=YES;
        if(alignFullPress)
        {
            NSString *trigger = @"zss_editor.setJustifyFull();";
            [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
            
            alignRightPress=NO;
            alignRight.image=[[UIImage imageNamed:@"editor_rightjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        else
        {
            NSString *trigger = @"zss_editor.setJustifyRight();";
            [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
            
            alignRightPress=YES;
            alignRight.image=[[UIImage imageNamed:@"editor_leftjustify_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }

        
        //set Selected images of Right alignment
        rightJustifyPie.image=[[UIImage imageNamed:@"editor_rightjustifypie_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        //set UnSelected images of Left alignment
        leftJustifyPie.image=[[UIImage imageNamed:@"editor_leftjustifypie_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        alignLeft.image=[[UIImage imageNamed:@"editor_leftjustify_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    else
    {
        rightJustifyPiePress=NO;
    }
}
- (void)setStrikethrough {
    
    NSString *trigger = @"zss_editor.setStrikeThrough();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!strikeThroughPress)
    {
        strikeThroughPress=YES;
        strikeThrough.image=[[UIImage imageNamed:@"editor_strikethrough_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        strikeThroughPress=NO;
        strikeThrough.image=[[UIImage imageNamed:@"editor_strikethrough_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }

}

- (void)setUnorderedList {
    NSString *trigger = @"zss_editor.setUnorderedList();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!ulPress)
    {
        ulPress=YES;
        ul.image=[[UIImage imageNamed:@"editor_unorderedlist_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        ulPress=NO;
        ul.image=[[UIImage imageNamed:@"editor_unorderedlist_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }

}

- (void)setOrderedList {
    NSString *trigger = @"zss_editor.setOrderedList();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!olPress)
    {
        olPress=YES;
        ol.image=[[UIImage imageNamed:@"editor_orderedlist_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        olPress=NO;
        ol.image=[[UIImage imageNamed:@"editor_orderedlist_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)setHR {
    NSString *trigger = @"zss_editor.setHorizontalRule();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)setIndent {
    NSString *trigger = @"zss_editor.setIndent();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!indentPress)
    {
        indentPress=YES;
        indent.image=[[UIImage imageNamed:@"editor_indeed_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        indentPress=NO;
        indent.image=[[UIImage imageNamed:@"editor_indeed_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)setOutdent {
    NSString *trigger = @"zss_editor.setOutdent();";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
    if(!outdentPress)
    {
        outdentPress=YES;
        outdent.image=[[UIImage imageNamed:@"editor_outdent_selected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    else
    {
        outdentPress=NO;
        outdent.image=[[UIImage imageNamed:@"editor_outdent_unselected.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ];
        
    }
}

- (void)heading1 {
    NSString *trigger = @"zss_editor.setHeading('h1');";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading2 {
    NSString *trigger = @"zss_editor.setHeading('h2');";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading3 {
    NSString *trigger = @"zss_editor.setHeading('h3');";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading4 {
    NSString *trigger = @"zss_editor.setHeading('h4');";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading5 {
    NSString *trigger = @"zss_editor.setHeading('h5');";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)heading6 {
    NSString *trigger = @"zss_editor.setHeading('h6');";
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}

-(void)textColor
{
    
    // Save the selection location
    //[self keyboardWillBeHidden];
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    // Call the picker
    HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:[UIColor whiteColor]];
    colorPicker.delegate = self;
    colorPicker.tag = 1;
    colorPicker.title = NSLocalizedString(@"Text Color", nil);
    [self.navigationController pushViewController:colorPicker animated:YES];
    
}

- (void)bgColor {
    //[self keyboardWillBeHidden];
    // Save the selection location
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    // Call the picker
    HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableFullColorPickerViewControllerWithColor:[UIColor whiteColor]];
    colorPicker.delegate = self;
    colorPicker.tag = 2;
    colorPicker.title = NSLocalizedString(@"BG Color", nil);
    [self.navigationController pushViewController:colorPicker animated:YES];
    
}

- (void)setSelectedColor:(UIColor*)color tag:(int)tag {
   
    NSString *hex = [NSString stringWithFormat:@"#%06x",HexColorFromUIColor(color)];
    NSString *trigger;
    if (tag == 1) {
        trigger = [NSString stringWithFormat:@"zss_editor.setTextColor(\"%@\");", hex];
    } else if (tag == 2) {
        trigger = [NSString stringWithFormat:@"zss_editor.setBackgroundColor(\"%@\");", hex];
    }
	[self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
}

- (void)undo:(ZSSBarButtonItem *)barButtonItem {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.undo();"];
}

- (void)redo:(ZSSBarButtonItem *)barButtonItem {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.redo();"];
}

- (void)insertLink {
    
    // Save the selection location
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    // Show the dialog for inserting or editing a link
    [self showInsertLinkDialogWithLink:self.selectedLinkURL title:self.selectedLinkTitle];
    
}


- (void)showInsertLinkDialogWithLink:(NSString *)url title:(NSString *)title {
    
    // Insert Button Title
    NSString *insertButtonTitle = !self.selectedLinkURL ? NSLocalizedString(@"Insert", nil) : NSLocalizedString(@"Update", nil);
    
    self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Insert Link", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:insertButtonTitle, nil];
    self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    self.alertView.tag = 2;
    UITextField *linkURL = [self.alertView textFieldAtIndex:0];
    linkURL.placeholder = NSLocalizedString(@"URL (required)", nil);
    if (url) {
        linkURL.text = url;
    }
    
    // Picker Button
    UIButton *am = [UIButton buttonWithType:UIButtonTypeCustom];
    am.frame = CGRectMake(0, 0, 25, 25);
    [am setImage:[UIImage imageNamed:@"ZSSpicker.png"] forState:UIControlStateNormal];
    [am addTarget:self action:@selector(showInsertURLAlternatePicker) forControlEvents:UIControlEventTouchUpInside];
    linkURL.rightView = am;
    linkURL.rightViewMode = UITextFieldViewModeAlways;
    
    UITextField *alt = [self.alertView textFieldAtIndex:1];
    alt.secureTextEntry = NO;
    alt.placeholder = NSLocalizedString(@"Title", nil);
    if (title) {
        alt.text = title;
    }
    
    [self.alertView show];
    
}


- (void)insertLink:(NSString *)url title:(NSString *)title {
    
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.insertLink(\"%@\", \"%@\");", url, title];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    
}


- (void)updateLink:(NSString *)url title:(NSString *)title {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.updateLink(\"%@\", \"%@\");", url, title];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)dismissAlertView {
    [self.alertView dismissWithClickedButtonIndex:self.alertView.cancelButtonIndex animated:YES];
}

- (void)addCustomToolbarItemWithButton:(UIButton *)button
{
    if(self.customBarButtonItems == nil)
    {
        self.customBarButtonItems = [NSMutableArray array];
    }
    
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:28.5f];
    [button setTitleColor:[self barButtonItemDefaultColor] forState:UIControlStateNormal];
    [button setTitleColor:[self barButtonItemSelectedDefaultColor] forState:UIControlStateHighlighted];
    
    ZSSBarButtonItem *barButtonItem = [[ZSSBarButtonItem alloc] initWithCustomView:button];
    [self.customBarButtonItems addObject:barButtonItem];
    
    [self buildToolbar];
}

- (void)removeLink {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.unlink();"];
}//end

- (void)quickLink {
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.quickLink();"];
}

- (void)insertImage {
    
    // Save the selection location
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    
    [self showInsertImageDialogWithLink:self.selectedImageURL alt:self.selectedImageAlt];
    
}

- (void)showInsertImageDialogWithLink:(NSString *)url alt:(NSString *)alt {
    
    // Insert Button Title
    NSString *insertButtonTitle = !self.selectedImageURL ? NSLocalizedString(@"Insert", nil) : NSLocalizedString(@"Update", nil);
    
    self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Insert Image", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:insertButtonTitle, nil];
    self.alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    self.alertView.tag = 1;
    UITextField *imageURL = [self.alertView textFieldAtIndex:0];
    imageURL.placeholder = NSLocalizedString(@"URL (required)", nil);
    if (url) {
        imageURL.text = url;
    }
    
    // Picker Button
    UIButton *am = [UIButton buttonWithType:UIButtonTypeCustom];
    am.frame = CGRectMake(0, 0, 25, 25);
    [am setImage:[UIImage imageNamed:@"ZSSpicker.png"] forState:UIControlStateNormal];
    [am addTarget:self action:@selector(showInsertImageAlternatePicker) forControlEvents:UIControlEventTouchUpInside];
    imageURL.rightView = am;
    imageURL.rightViewMode = UITextFieldViewModeAlways;
    imageURL.clearButtonMode = UITextFieldViewModeAlways;
    
    UITextField *alt1 = [self.alertView textFieldAtIndex:1];
    alt1.secureTextEntry = NO;
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    test.backgroundColor = [UIColor redColor];
    alt1.rightView = test;
    alt1.placeholder = NSLocalizedString(@"Alt", nil);
    alt1.clearButtonMode = UITextFieldViewModeAlways;
    if (alt) {
        alt1.text = alt;
    }
    
    [self.alertView show];
    
}

- (void)insertImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.insertImage(\"%@\", \"%@\");", url, alt];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)updateImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"zss_editor.updateImage(\"%@\", \"%@\");", url, alt];
    [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)updateToolBarWithButtonName:(NSString *)name {
    
    // Items that are enabled
    NSArray *itemNames = [name componentsSeparatedByString:@","];
    
    // Special case for link
    NSMutableArray *itemsModified = [[NSMutableArray alloc] init];
    for (NSString *linkItem in itemNames) {
        NSString *updatedItem = linkItem;
        if ([linkItem hasPrefix:@"link:"]) {
            updatedItem = @"link";
            self.selectedLinkURL = [linkItem stringByReplacingOccurrencesOfString:@"link:" withString:@""];
        } else if ([linkItem hasPrefix:@"link-title:"]) {
            self.selectedLinkTitle = [self stringByDecodingURLFormat:[linkItem stringByReplacingOccurrencesOfString:@"link-title:" withString:@""]];
        } else if ([linkItem hasPrefix:@"image:"]) {
            updatedItem = @"image";
            self.selectedImageURL = [linkItem stringByReplacingOccurrencesOfString:@"image:" withString:@""];
        } else if ([linkItem hasPrefix:@"image-alt:"]) {
            self.selectedImageAlt = [self stringByDecodingURLFormat:[linkItem stringByReplacingOccurrencesOfString:@"image-alt:" withString:@""]];
        } else {
            self.selectedImageURL = nil;
            self.selectedImageAlt = nil;
            self.selectedLinkURL = nil;
            self.selectedLinkTitle = nil;
        }
        [itemsModified addObject:updatedItem];
    }
    itemNames = [NSArray arrayWithArray:itemsModified];
    //NSLog(@"%@", itemNames);
    self.editorItemsEnabled = itemNames;
    
    // Highlight items
    NSArray *items = self.toolbar.items;
    for (ZSSBarButtonItem *item in items) {
        if ([itemNames containsObject:item.label]) {
            item.tintColor = [self barButtonItemSelectedDefaultColor];
        } else {
            item.tintColor = [self barButtonItemDefaultColor];
        }
    }//end
    
}
    

#pragma mark - UITextView Delegate
    
- (void)textViewDidChange:(UITextView *)textView
{
    if(self.editorView.tag==102 || self.sourceView.tag==101)
    {

      CGRect line = [textView caretRectForPosition:textView.selectedTextRange.start];
      CGFloat overflow = line.origin.y + line.size.height - ( textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top );
      if ( overflow > 0 )
      {
         CGPoint offset = textView.contentOffset;
         offset.y += overflow + 7; // leave 7 pixels margin
         [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
         }];
      }
    }
}


#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = [[request URL] absoluteString];
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
		return NO;
	} else if ([urlString rangeOfString:@"callback://"].location != NSNotFound) {
        
        // We recieved the callback
        NSString *className = [urlString stringByReplacingOccurrencesOfString:@"callback://" withString:@""];
        [self updateToolBarWithButtonName:className];
        
    }
    
    return YES;
    
}//end


#pragma mark - AlertView

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    
    if (alertView.tag == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        UITextField *textField2 = [alertView textFieldAtIndex:1];
        if ([textField.text length] == 0 || [textField2.text length] == 0) {
            return NO;
        }
    } else if (alertView.tag == 2) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        if ([textField.text length] == 0) {
            return NO;
        }
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            UITextField *imageURL = [alertView textFieldAtIndex:0];
            UITextField *alt = [alertView textFieldAtIndex:1];
            if (!self.selectedImageURL) {
                [self insertImage:imageURL.text alt:alt.text];
            } else {
                [self updateImage:imageURL.text alt:alt.text];
            }
        }
    } else if (alertView.tag == 2) {
        if (buttonIndex == 1) {
            UITextField *linkURL = [alertView textFieldAtIndex:0];
            UITextField *title = [alertView textFieldAtIndex:1];
            if (!self.selectedLinkURL) {
                [self insertLink:linkURL.text title:title.text];
            } else {
                [self updateLink:linkURL.text title:title.text];
            }
        }
    }
    
}


#pragma mark - Asset Picker

- (void)showInsertURLAlternatePicker {
    // Blank method. User should implement this in their subclass
}


- (void)showInsertImageAlternatePicker {
    // Blank method. User should implement this in their subclass
}


#pragma mark - Keyboard status

//- (void)keyboardWillShowOrHide:(NSNotification *)notification {
//    
//    // Orientation
//    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
//	
//    // User Info
//    NSDictionary *info = notification.userInfo;
//    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
//    int curve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
//    CGRect keyboardEnd = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    
//    // Toolbar Sizes
//    CGFloat sizeOfToolbar = self.toolbarHolder.frame.size.height;
//    
//    // Keyboard Size
//    CGFloat keyboardHeight = UIInterfaceOrientationIsLandscape(orientation) ? keyboardEnd.size.width : keyboardEnd.size.height;
//    
//    // Correct Curve
//    UIViewAnimationOptions animationOptions = curve << 16;
//    
//	if ([notification.name isEqualToString:UIKeyboardWillShowNotification]) {
//        
//        [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
//            
//            // Toolbar
//            CGRect frame1 = self.toolbarHolder.frame;
//            frame1.origin.y = self.view.frame.size.height - (keyboardHeight + sizeOfToolbar);
//            self.toolbarHolder.frame = frame1;
//            
//            // Editor View
//            CGRect editorFrame = self.editorView.frame;
//            editorFrame.size.height = (self.view.frame.size.height - keyboardHeight) - sizeOfToolbar;
//            self.editorView.frame = editorFrame;
//            self.editorViewFrame = self.editorView.frame;
//            self.editorView.scrollView.contentInset = UIEdgeInsetsZero;
//            self.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
//            
//            // Source View
//            CGRect sourceFrame = self.sourceView.frame;
//            sourceFrame.size.height = (self.view.frame.size.height - keyboardHeight) - sizeOfToolbar;
//            self.sourceView.frame = sourceFrame;
//            
//        } completion:nil];
//        
//	} else {
//        
//		[UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
//            
//            CGRect frame2 = self.toolbarHolder.frame;
//            frame2.origin.y = self.view.frame.size.height + keyboardHeight;
//            self.toolbarHolder.frame = frame2;
//            
//            // Editor View
//            CGRect editorFrame = self.editorView.frame;
//            editorFrame.size.height = self.view.frame.size.height;
//            self.editorView.frame = editorFrame;
//            self.editorViewFrame = self.editorView.frame;
//            self.editorView.scrollView.contentInset = UIEdgeInsetsZero;
//            self.editorView.scrollView.scrollIndicatorInsets = UIEdgeInsetsZero;
//            
//            // Source View
//            CGRect sourceFrame = self.sourceView.frame;
//            sourceFrame.size.height = self.view.frame.size.height;
//            self.sourceView.frame = sourceFrame;
//            
//        } completion:nil];
//        
//	}//end
//    
//}

#pragma mark - Utilities

- (NSString *)removeQuotesFromHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    html = [html stringByReplacingOccurrencesOfString:@"&"  withString:@"%26"];
    return html;
}//end


- (NSString *)tidyHTML:(NSString *)html {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
    if (self.formatHTML) {
        html = [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"style_html(\"%@\");", html]];
    }
    return html;
}//end


- (UIColor *)barButtonItemDefaultColor {
    
    if (self.toolbarItemTintColor) {
        return self.toolbarItemTintColor;
    }
    
    return [UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}


- (UIColor *)barButtonItemSelectedDefaultColor {
    
    if (self.toolbarItemSelectedTintColor) {
        return self.toolbarItemSelectedTintColor;
    }
    
    return [UIColor blackColor];
}


- (BOOL)isIpad {
	return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}//end


- (NSString *)stringByDecodingURLFormat:(NSString *)string {
    NSString *result = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    return result;
}
    

- (void)enableToolbarItems:(BOOL)enable {
    NSArray *items = self.toolbar.items;
    for (ZSSBarButtonItem *item in items) {
        if (![item.label isEqualToString:@"source"]) {
            item.enabled = enable;
        }
    }
}

-(void)handelSubmitButtonClkick
{
}
-(void)setTextFont
{
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    [self showPicker];
}

-(void)setTextSize
{
    [self.editorView stringByEvaluatingJavaScriptFromString:@"zss_editor.prepareInsert();"];
    [self showTextSizePicker];
}

-(void)setTextFormat
{
    [self showTextFormatPicker];
}
-(void)setTextStyle
{
    [self showTextStylePicker];
}

-(void)setSelectedFont:(UIFont*)Font
{
    [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('fontName', false, '%@')", Font]];
    //[self showPicker];
}

-(void)setSelectedSize:(NSString*)Size
{
    [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('fontSize', false, '%d')", [Size intValue]]];
    //[self showTextSizePicker];
}
-(void)setSelectedStyle:(NSString*)Style
{
    [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('fontSize', false, '%@')", Style]];
}
-(void)setSelectedFormat:(NSString*)Format
{
    [self.editorView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.execCommand('fontSize', false, '%@')", Format]];
    //[self showTextSizePicker];
}

#pragma mark - picker delegates
- (void) showPicker
{
    @try
    {
        {
            fontTF=[[UITextField alloc]initWithFrame:textFontFrame];
            
            [ActionSheetStringPicker showPickerWithTitle:@"Select Font" rows:FontfamilyNames initialSelection:0 target:self successAction:@selector(fontWasSelected:element:) cancelAction:@selector(cancelSelection) origin:fontTF];
        }
    } @catch (NSException *ex)
    {
        
	}
}

- (void) showTextSizePicker
{
    @try
    {
        {
            sizeTF=[[UITextField alloc]initWithFrame:textSizeFrame];
            
            [ActionSheetStringPicker showPickerWithTitle:@"Select Size" rows:FontSizes initialSelection:0 target:self successAction:@selector(sizeWasSelected:element:) cancelAction:@selector(cancelSelection) origin:sizeTF];
        }
    } @catch (NSException *ex)
    {
        
	}
}
-(void)showTextStylePicker
{
    @try
    {
        {
            styleTF=[[UITextField alloc]initWithFrame:textStylesFrame];
            
            [ActionSheetStringPicker showPickerWithTitle:@"Select Style" rows:Styles initialSelection:0 target:self successAction:@selector(styleWasSelected:element:) cancelAction:@selector(cancelSelection) origin:styleTF];
        }
    } @catch (NSException *ex)
    {
        
	}
}
-(void)showTextFormatPicker
{
    @try
    {
        {
            formatTF=[[UITextField alloc]initWithFrame:textFormatframe];
            
            [ActionSheetStringPicker showPickerWithTitle:@"Select Format" rows:Formats initialSelection:0 target:self successAction:@selector(formatWasSelected:element:) cancelAction:@selector(cancelSelection) origin:formatTF];
        }
    } @catch (NSException *ex)
    {
        
	}
}
-(void)cancelSelection
{
    @try
    {
        
    }@catch (NSException *ex)
    {
	}
}

- (void)fontWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    // NSLog(@"%@",[FontfamilyNames objectAtIndex:[selectedIndex integerValue]]);
    
    self.selectedIndex = [selectedIndex intValue];
    [self setSelectedFont:[FontfamilyNames objectAtIndex:self.selectedIndex]];
    
    //may have originated from textField or barButtonItem, use an IBOutlet instead of element
    //self.animalTextField.text = (self.animals)[(NSUInteger) self.selectedIndex];
}

- (void)sizeWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    //NSLog(@"sizeWasSelected %@",[FontSizes objectAtIndex:[selectedIndex integerValue]]);
    
    self.selectedIndex = [selectedIndex intValue];
    //[self setSelectedSize:(CGSize *)([FontSizes objectAtIndex:[selectedIndex integerValue]])];
    [self setSelectedSize:[FontSizes objectAtIndex:self.selectedIndex]];

}

- (void)styleWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    //NSLog(@"styleWasSelected %@",[Styles objectAtIndex:[selectedIndex integerValue]]);
   // NSLog(@"ind no %@",selectedIndex);
    self.selectedIndex = [selectedIndex intValue];
    //[self setSelectedSize:(CGSize *)([FontSizes objectAtIndex:[selectedIndex integerValue]])];
    [self setSelectedSize:[Styles objectAtIndex:self.selectedIndex]];
    
    if(self.selectedIndex==0){
        
        NSString *trigger = @"zss_editor.prepareInsertBlueColor();";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
        
        // Call the picker
       // HRColorPickerViewController *colorPicker = [HRColorPickerViewController cancelableBlueColorPickerViewControllerWithColor:[UIColor blueColor]];
      //  NSLog(@"colorPicker %@",colorPicker);
//        colorPicker.delegate = self;
//        colorPicker.tag = 6;
//        colorPicker.title = NSLocalizedString(@"Text Color", nil);
        
        
    }
    //Big
    if(self.selectedIndex==4)
    {
        NSString *trigger = @"zss_editor.setBold();";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }
    //Deleted text
    if(self.selectedIndex==5)
    {
        NSString *trigger = @"zss_editor.setStrikeThrough();";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }
    //Inserted Text
    if(self.selectedIndex==6) {
        NSString *trigger = @"zss_editor.setUnderline();";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }
    //Cited Work
    if(self.selectedIndex==7) {
        NSString *trigger = @"zss_editor.setItalic();";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }

    
    
    
//    if(self.selectedIndex==1){
//        NSString *trigger = @"zss_editor.setHeading('h2');";
//        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
//    }
//    
//    if(self.selectedIndex==2) {
//        NSString *trigger = @"zss_editor.setHeading('h3');";
//        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
//    }
//    
//    if(self.selectedIndex==3) {
//        NSString *trigger = @"zss_editor.setHeading('h4');";
//        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
//    }
//    
//
    
    }

- (void)formatWasSelected:(NSNumber *)selectedIndex element:(id)element
{
    //NSLog(@"formatWasSelected %@",[Formats objectAtIndex:[selectedIndex integerValue]]);
    self.selectedIndex = [selectedIndex intValue];
    //[self setSelectedSize:(CGSize *)([FontSizes objectAtIndex:[selectedIndex integerValue]])];
    [self setSelectedFormat:[Formats objectAtIndex:self.selectedIndex]];
    
    if(self.selectedIndex==0){
        NSString *trigger = @"zss_editor.setHeading('h1');";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }
    
    if(self.selectedIndex==1){
        NSString *trigger = @"zss_editor.setHeading('h2');";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }
    
    if(self.selectedIndex==2) {
        NSString *trigger = @"zss_editor.setHeading('h3');";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }
    
    if(self.selectedIndex==3) {
        NSString *trigger = @"zss_editor.setHeading('h4');";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }
    
    if(self.selectedIndex==4) {
        NSString *trigger = @"zss_editor.setHeading('h5');";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }
    
    if(self.selectedIndex==5) {
        NSString *trigger = @"zss_editor.setHeading('h6');";
        [self.editorView stringByEvaluatingJavaScriptFromString:trigger];
    }

    
}



@end

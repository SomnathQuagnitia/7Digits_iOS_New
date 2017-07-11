//



// onLoad="zss_editor.init();" onclick="void(0)" id="zss_editor_content"><!--content-->


//  ZSSRichTextEditorViewController.h
//  ZSSRichTextEditor
//
//  Created by Nicholas Hubbard on 11/30/13.
//  Copyright (c) 2013 Zed Said Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HRColorPickerViewController.h"
#import "ActionSheetStringPicker.h"
#import "Parameters.h"
#import "ZSSTextView.h"

/**
 *  The types of toolbar items that can be added
 */
typedef NS_ENUM(NSInteger, ZSSRichTextEditorToolbar) {
    ZSSRichTextEditorToolbarBold = 1,
    ZSSRichTextEditorToolbarItalic = 1 << 0,
    ZSSRichTextEditorToolbarSubscript = 1 << 1,
    ZSSRichTextEditorToolbarSuperscript = 1 << 2,
    ZSSRichTextEditorToolbarStrikeThrough = 1 << 3,
    ZSSRichTextEditorToolbarUnderline = 1 << 4,
    ZSSRichTextEditorToolbarRemoveFormat = 1 << 5,
    ZSSRichTextEditorToolbarJustifyLeft = 1 << 6,
    ZSSRichTextEditorToolbarJustifyCenter = 1 << 7,
    ZSSRichTextEditorToolbarJustifyRight = 1 << 8,
    ZSSRichTextEditorToolbarJustifyFull = 1 << 9,
    ZSSRichTextEditorToolbarH1 = 1 << 10,
    ZSSRichTextEditorToolbarH2 = 1 << 11,
    ZSSRichTextEditorToolbarH3 = 1 << 12,
    ZSSRichTextEditorToolbarH4 = 1 << 13,
    ZSSRichTextEditorToolbarH5 = 1 << 14,
    ZSSRichTextEditorToolbarH6 = 1 << 15,
    ZSSRichTextEditorToolbarTextColor = 1 << 16,
    ZSSRichTextEditorToolbarBackgroundColor = 1 << 17,
    ZSSRichTextEditorToolbarUnorderedList = 1 << 18,
    ZSSRichTextEditorToolbarOrderedList = 1 << 19,
    ZSSRichTextEditorToolbarHorizontalRule = 1 << 20,
    ZSSRichTextEditorToolbarIndent = 1 << 21,
    ZSSRichTextEditorToolbarOutdent = 1 << 22,
    ZSSRichTextEditorToolbarInsertImage = 1 << 23,
    ZSSRichTextEditorToolbarInsertLink = 1 << 24,
    ZSSRichTextEditorToolbarRemoveLink = 1 << 25,
    ZSSRichTextEditorToolbarQuickLink = 1 << 26,
    ZSSRichTextEditorToolbarUndo = 1 << 27,
    ZSSRichTextEditorToolbarRedo = 1 << 28,
    ZSSRichTextEditorToolbarViewSource = 1 << 29,
    ZSSRichTextEditorToolbarAll = 1 << 30,
    ZSSRichTextEditorToolbarNone = 1 << 31,
    ZSSRichTextEditorToolbarQuoted = 1 << 32,
    ZSSRichTextEditorToolbarLeftJustifyPie = 1 << 33,
    ZSSRichTextEditorToolbarRightJustifyPie = 1 << 34,
};

@class ZSSBarButtonItem;

/**
 *  The viewController used with ZSSRichTextEditor
 */
@interface ZSSRichTextEditor : BaseViewController <UIWebViewDelegate, HRColorPickerViewControllerDelegate, UITextViewDelegate>
{
    
    NSMutableArray *editorReplyTextArray;
    NSMutableArray *editorReplyTextHeightArray;

    
    IBOutlet UIScrollView *scrollviewObj;

    CGFloat borderWidth;
    CGRect frame;
    CGRect toolBarHolderframe;
    CGRect textColorframe;
    CGRect textBgColorframe;
    CGRect submitReplyframe;
    CGRect textFormatframe;
    CGRect textStyleframe;
    CGRect keyBoardBtnframe;


    
    
    BOOL boldPress;
    BOOL italicPress;
    BOOL subscriptPress;
    BOOL superscriptPress;
    BOOL strikeThroughPress;
    BOOL underlinePress;
    BOOL removeFormatPress;
    BOOL alignLeftPress;
    BOOL alignCenterPress;
    BOOL alignRightPress;
    BOOL alignFullPress;
    BOOL ulPress;
    BOOL olPress;
    BOOL indentPress;
    BOOL outdentPress;
    BOOL quotedJustifyPress;
    BOOL leftJustifyPiePress;
    BOOL rightJustifyPiePress;
    
    ZSSBarButtonItem *bold;
    ZSSBarButtonItem *italic;
    ZSSBarButtonItem *subscript;
    ZSSBarButtonItem *superscript;
    ZSSBarButtonItem *strikeThrough;
    ZSSBarButtonItem *underline;
    ZSSBarButtonItem *removeFormat;
    ZSSBarButtonItem *alignLeft;
    ZSSBarButtonItem *alignCenter;
    ZSSBarButtonItem *alignRight;
    ZSSBarButtonItem *alignFull;
    ZSSBarButtonItem *ul;
    ZSSBarButtonItem *ol;
    ZSSBarButtonItem *indent;
    ZSSBarButtonItem *outdent;
    ZSSBarButtonItem *quotedJustify;
    ZSSBarButtonItem *leftJustifyPie;
    ZSSBarButtonItem *rightJustifyPie;
    
    NSArray *FontfamilyNames;
    NSArray *FontSizes;
    NSArray *Formats;
    NSArray *Styles;
    
    CGRect textFontFrame;
    CGRect textSizeFrame;
    CGRect textStylesFrame;

    
    UIButton *textFont;
    UIButton *textSize;
    
    UITextField *fontTF;
    UITextField *sizeTF;
    UITextField *formatTF;
    UITextField *styleTF;
    
    CGFloat XPos;
    CGFloat BtnWdth;
    CGFloat BtnHeight;
    CGFloat YforComposeVC;
    CGFloat YforAddContVC;
    CGFloat YforContUsVC;
    CGFloat YforReplyVC;
    CGFloat YforEditProfessionalProfileVC;
    CGFloat ToolBarHolderHeight;
    CGFloat EidtorHeight;
    
    CGFloat YComposeTextView;
    CGFloat YAddContactTextView;
    CGFloat YProfessionalProfileTextView;
    CGFloat YContactUsTextView;
    CGFloat YReplyTextView;
    CGFloat YPostedMessageDetailTextView;
    CGFloat YDraftMessageTextView;
    
    //Compse screen outlets
    
    UITextField *currentTextField;
    
    
}
//@property (strong,nonatomic) ShowCustomPickerActionSheetView * objActionSheet;
- (void)dismissKeyboard;

//Compose screen Actions and outlets
//-(IBAction)browseImage:(id)sender;
@property (nonatomic) BOOL resourcesLoaded;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForState;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForCity;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForZip;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForTitle;
@property(strong,nonatomic)IBOutlet UITextField *textfieldForAge;

@property(strong,nonatomic)UIToolbar *toolbarKbd;
//-(IBAction)handelCheckBoxM2M:(UIButton *)sender;
//-(IBAction)handelCheckBoxM2W:(UIButton *)sender;
//-(IBAction)handelCheckBoxW2W:(UIButton *)sender;
//-(IBAction)handelCheckBoxW2M:(UIButton *)sender;
//-(IBAction)handelCheckBoxEveryOne:(UIButton *)sender;
//
//-(IBAction)handleDeleteBtn:(id)sender;



/**
 *  The base URL to use for the webView
 */
@property (nonatomic, strong) NSURL *baseURL;

/**
 *  If the HTML should be formatted to be pretty
 */
@property (nonatomic) BOOL formatHTML;

/**
 *  Toolbar items to include
 */
@property (nonatomic) ZSSRichTextEditorToolbar enabledToolbarItems;

/**
 *  Color to tint the toolbar items
 */
@property (nonatomic, strong) UIColor *toolbarItemTintColor;

/**
 *  Color to tint selected items
 */
@property (nonatomic, strong) UIColor *toolbarItemSelectedTintColor;

/**
 *  The rich text editor
 *
 *  @param html  HTML string to start with
 *
 *  @return id
 */
- (void)setHtml:(NSString *)html;

/**
 *  Returns the HTML from the Rich Text Editor
 *
 *  @return NSString
 */
- (NSString *)getHTML;

/**
 *  Manually focuses on the text editor
 */
- (void)focusTextEditor;

/**
 *  Manually focuses on the text editor
 */
- (void)blurTextEditor;

/**
 *  Shows the insert image dialog with optinal inputs
 *
 *  @param url The URL for the image
 *  @param alt The alt for the image
 */
- (void)showInsertImageDialogWithLink:(NSString *)url alt:(NSString *)alt;

/**
 *  Inserts an image
 *
 *  @param url The URL for the image
 *  @param alt The alt attribute for the image
 */
- (void)insertImage:(NSString *)url alt:(NSString *)alt;

/**
 *  Shows the insert link dialog with optional inputs
 *
 *  @param url   The URL for the link
 *  @param title The tile for the link
 */
- (void)showInsertLinkDialogWithLink:(NSString *)url title:(NSString *)title;

/**
 *  Inserts a link
 *
 *  @param url The URL for the link
 *  @param title The title for the link
 */
- (void)insertLink:(NSString *)url title:(NSString *)title;

/**
 *  Gets called when the insert URL picker button is tapped in an alertView
 *
 *  @warning The default implementation of this method is blank and does nothing
 */
- (void)showInsertURLAlternatePicker;

/**
 *  Gets called when the insert Image picker button is tapped in an alertView
 *
 *  @warning The default implementation of this method is blank and does nothing
 */
- (void)showInsertImageAlternatePicker;

/**
 *  Dismisses the current AlertView
 */
- (void)dismissAlertView;

/**
 *  Add a custom UIBarButtonItem
 */
- (void)addCustomToolbarItemWithButton:(UIButton*)button;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIWebView *editorView;
@property (nonatomic, strong) ZSSTextView *sourceView;


@end

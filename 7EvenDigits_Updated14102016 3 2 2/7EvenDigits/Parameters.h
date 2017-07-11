
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;
static CGFloat animatedDistance;

@interface Parameters : NSObject

+(void)showAlrtForSingleBtn:(NSString *)message view:(UIViewController *)viewController;
+(void)showAlrtForErrorMessage:(NSString *)message view:(UIViewController *)viewController;
+(void)pushFromView:(id)fromView toView:(UIViewController *)toView withTransition:(UIViewAnimationTransition)transition;
+(void)popViewController:(id)viewController withTransition:(UIViewAnimationTransition)transition;
+  (void)popToViewControllerNamed:(NSString *)toViewControllerName from :(id)viewController;

+ (UIImage *)scaleAndRotateImage:(UIImage *)image maxSize:(int) kMaxResolution;
+(void)playReceivedAudio;
+(void)addPaddingView :(UITextField *)textField;

+(NSString*)formatNumber:(NSString*)mobileNumber;
+(NSUInteger)getLength:(NSString*)mobileNumber;

+(NSString *)removeSpecialCharactresFromNumber :(NSString *)str;
+(NSString *)insertNewLineInText :(NSString *)htmlMessage;
+(CGFloat) getTextHeight:(NSString*)str atFont:(UIFont*)font;
+ (void)showAlertControllerWithSingleButtonMessage:(NSString *)message title:(NSString *)titleMessage view:(UIViewController *)viewController delegateClass:(id)delegate;
+ (NSTimeInterval)getTimeInterValFromString:(NSString*)string;
+(NSString *)decodeDataForEmogies:(NSString*)string;
+(NSString *)encodeDataForEmogies:(NSString*)string;
+ (UIImage *)rotateImage:(UIImage*)image byDegree:(CGFloat)degrees;
+ (void)moveTextFieldUpForView:(UIView *)forView forTextField:(UITextField *)textField forSubView:(UIView *)forSubView;
+ (void)moveTextFieldDownforView:(UIView *)forSubView;
+ (void)addBorderToView:(UIView *)view;
+ (void)moveTextViewUpForView:(UIView *)forView forTextView:(UITextView *)textView forSubView:(UIView *)forSubView;
+ (void)moveTextViewDownforView:(UIView *)forSubView;

@end

#define sAlertTitle NSLocalizedString(@"",nil)
#define sEnterUserName NSLocalizedString(@"Please enter username",nil)
#define sEnterPassword NSLocalizedString(@"Please enter password",nil)
#define sEnterAllFields NSLocalizedString(@"Please enter all fields",nil)
#define sEmailSendSuccess NSLocalizedString(@"Email sent successfully",nil)
#define sSaveToDraft NSLocalizedString(@"Do you want to save as draft?",nil)
#define sDeleteMessage NSLocalizedString(@"Do you want to delete this message?",nil)
#define sAddContactSuccessfuly NSLocalizedString(@"Contact added successfully",nil)
#define sPasswordChangedSuccessfuly NSLocalizedString(@"Password changed successfully",nil)
#define sRegisterdSuccessfully NSLocalizedString(@"Registered successfully",nil)
#define sPasswordLengthGreaterThanSix NSLocalizedString(@"The Password must be at least 6 characters long.",nil)
#define sEnterUserID NSLocalizedString(@"Username is required",nil)

#define sEnterRenterPassword NSLocalizedString(@"Please re-enter password",nil)
#define sEnterEmail NSLocalizedString(@"E-mail address is required",nil)
#define sEnterValidEmail NSLocalizedString(@"Please enter valid email",nil)
#define sEnterReEnterSamePassword NSLocalizedString(@"Passwords must match",nil)
//#define kAlertTitle  NSLocalizedString(@"",nil) //@"Alert"

#define SCREEN_HEIGHT [[UIScreen mainScreen ] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen ] bounds].size.width
#define IS_IPAD [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad

#define IS_IOS8 [[UIDevice currentDevice].systemVersion floatValue] >= 8.0
#define TimeStamp [NSString stringWithFormat:@"%d",[[NSDate date] timeIntervalSince1970] * 1000]

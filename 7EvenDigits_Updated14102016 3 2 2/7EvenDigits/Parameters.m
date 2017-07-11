
#import "Parameters.h"

@implementation Parameters




+(void)showAlrtForSingleBtn:(NSString *)message view:(UIViewController *)viewController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:sAlertTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [alertVC dismissViewControllerAnimated:YES completion:nil];
                                   }];
    
    [alertVC addAction:cancelAction];
    [viewController.view.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
    
}

+(void)showAlrtForErrorMessage:(NSString *)message view:(UIViewController *)viewController
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", nil)
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction *action)
                                   {
                                       [alertVC dismissViewControllerAnimated:YES completion:nil];
                                   }];
    
    [alertVC addAction:cancelAction];
    [viewController.view.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}


+(void)pushFromView:(id)fromView toView:(UIViewController *)toView withTransition:(UIViewAnimationTransition)transition
{
    UIViewController *rootView = (UIViewController *)fromView;
    
    if (![rootView isKindOfClass:[toView class]])
    {
        NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithArray:rootView.navigationController.viewControllers];
        for (UIViewController *vc in rootView.navigationController.viewControllers) {
            if ([vc isKindOfClass:[toView class]]) {
                [viewControllers removeObject:vc];
                break;
            }
        }
        rootView.navigationController.viewControllers = viewControllers;
//        [UIView beginAnimations:@"animation" context:nil];
//        [UIView setAnimationDuration:0.7];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:rootView.navigationController.view cache:YES];
        [rootView.navigationController pushViewController: toView animated:NO];
//        [UIView setAnimationDuration:0.7];
//        [UIView setAnimationTransition:transition forView:rootView.navigationController.view cache:NO];
//        [UIView commitAnimations];
        
    }
}


+(void)popViewController:(id)viewController withTransition:(UIViewAnimationTransition)transition
{
    UIViewController *viewContro = (UIViewController *)viewController;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.7];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationTransition:transition forView:viewContro.navigationController.view cache:YES];
    [UIView commitAnimations];
    [viewContro.navigationController popViewControllerAnimated:NO];
}

//+  (void)popToLoginViewController:(id)viewController
+  (void)popToViewControllerNamed:(NSString *)toViewControllerName from :(id)viewController
{
    UIViewController *viewContro = (UIViewController *)viewController;
    //NSLog(@"self.navigationController.viewControllers %@",viewContro.navigationController.viewControllers);
    for (UIViewController *vc in viewContro.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(toViewControllerName)]) {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.7];
            [UIView setAnimationBeginsFromCurrentState:YES];
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:viewContro.navigationController.view cache:YES];
            [UIView commitAnimations];
            [viewContro.navigationController popToViewController:vc animated:NO];
            break;
        }
    }
   // NSLog(@"self.navigationController.viewControllers %@",viewContro.navigationController.viewControllers);
}
+ (NSTimeInterval)getTimeInterValFromString:(NSString*)string {
    return MIN((float)string.length*0.10 + 0.10, 5.0);
}

+(NSString *)decodeDataForEmogies:(NSString*)string
{
    const char *jsonString = [string UTF8String];
    NSData *jsonData = [NSData dataWithBytes:jsonString length:strlen(jsonString)];
    NSString *goodMsg = [[NSString alloc] initWithData:jsonData encoding:NSNonLossyASCIIStringEncoding];
    
    return goodMsg;
}
+(NSString *)encodeDataForEmogies:(NSString*)string;
{
    //To send encoded data for emogies
    NSString *uniText = [NSString stringWithUTF8String:[string UTF8String]];
    NSData *msgData = [uniText dataUsingEncoding:NSNonLossyASCIIStringEncoding];
    string = [[NSString alloc] initWithData:msgData encoding:NSUTF8StringEncoding] ;
    return string;

}
#pragma mark = Image Compression
+(UIImage *)scaleAndRotateImage:(UIImage *)image maxSize:(int) kMaxResolution
{
    @try {
        if (image == nil)
        {
            return nil;
        }
        
        UIImage *imageCopy = nil;
        @try {
            CGImageRef imgRef = image.CGImage;
            if (imgRef == nil)
            {
                return nil;
            }
            
            CGFloat width = CGImageGetWidth(imgRef);
            CGFloat height = CGImageGetHeight(imgRef);
            
            CGAffineTransform transform = CGAffineTransformIdentity;
            CGRect bounds = CGRectMake(0.0, 0.0, width, height);
            if (width > kMaxResolution || height > kMaxResolution) {
                CGFloat ratio = width/height;
                if (ratio > 1.0) {
                    bounds.size.width = kMaxResolution;
                    bounds.size.height = bounds.size.width / ratio;
                }
                else {
                    bounds.size.height = kMaxResolution;
                    bounds.size.width = bounds.size.height * ratio;
                }
            }
            
            CGFloat scaleRatio = bounds.size.width / width;
            CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
            CGFloat boundHeight;
            UIImageOrientation orient = image.imageOrientation;
            switch(orient) {
                case UIImageOrientationUp: //EXIF = 1
                    transform = CGAffineTransformIdentity;
                    break;
                    
                case UIImageOrientationUpMirrored: //EXIF = 2
                    transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
                    transform = CGAffineTransformScale(transform, -1.0, 1.0);
                    break;
                    
                case UIImageOrientationDown: //EXIF = 3
                    transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
                    transform = CGAffineTransformRotate(transform, M_PI);
                    break;
                    
                case UIImageOrientationDownMirrored: //EXIF = 4
                    transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
                    transform = CGAffineTransformScale(transform, 1.0, -1.0);
                    break;
                    
                case UIImageOrientationLeftMirrored: //EXIF = 5
                    boundHeight = bounds.size.height;
                    bounds.size.height = bounds.size.width;
                    bounds.size.width = boundHeight;
                    transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
                    transform = CGAffineTransformScale(transform, -1.0, 1.0);
                    transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                    break;
                    
                case UIImageOrientationLeft: //EXIF = 6
                    boundHeight = bounds.size.height;
                    bounds.size.height = bounds.size.width;
                    bounds.size.width = boundHeight;
                    transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
                    transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
                    break;
                    
                case UIImageOrientationRightMirrored: //EXIF = 7
                    boundHeight = bounds.size.height;
                    bounds.size.height = bounds.size.width;
                    bounds.size.width = boundHeight;
                    transform = CGAffineTransformMakeScale(-1.0, 1.0);
                    transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                    break;
                    
                case UIImageOrientationRight: //EXIF = 8
                    boundHeight = bounds.size.height;
                    bounds.size.height = bounds.size.width;
                    bounds.size.width = boundHeight;
                    transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
                    transform = CGAffineTransformRotate(transform, M_PI / 2.0);
                    break;
                    
                default:
                    [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            }
            
            UIGraphicsBeginImageContext(bounds.size);
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            
            if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
                CGContextScaleCTM(context, -scaleRatio, scaleRatio);
                CGContextTranslateCTM(context, -height, 0);
            }
            else {
                CGContextScaleCTM(context, scaleRatio, -scaleRatio);
                CGContextTranslateCTM(context, 0, -height);
            }
            
            CGContextConcatCTM(context, transform);
            
            CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
            imageCopy = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        } @catch (NSException *ex)
        {
            //DebugLog(@"EXCEPTION: %s: %@", func, ex);
        }
        
        return imageCopy;
    } @catch (NSException *ex)
    {
		//[DebugHelper handleException:__FILE__ function:NSStringFromSelector(_cmd) exception:ex];
	}
}
static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

+ (UIImage *)rotateImage:(UIImage*)image byDegree:(CGFloat)degrees
{
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    
    CGContextTranslateCTM(bitmap, rotatedSize.width, rotatedSize.height);
    
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width, -image.size.height, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
+(void)playReceivedAudio
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:@"messageSent" ofType:@"aiff"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
    [audioPlayer prepareToPlay];
    [audioPlayer play];
}
+(void)addPaddingView :(UITextField *)textField
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 34)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}

+(NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSUInteger length = [mobileNumber length];
    if(length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    return mobileNumber;
}


+(NSUInteger)getLength:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    NSUInteger length = [mobileNumber length];
    return length;
}


+(NSString *)removeSpecialCharactresFromNumber :(NSString *)str
{
    NSMutableCharacterSet *characterSet =[NSMutableCharacterSet characterSetWithCharactersInString:@"()-"];
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [str componentsSeparatedByCharactersInSet:characterSet];
    // Create string from the array components
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    
    NSMutableString *num = [[NSMutableString alloc]initWithString:strOutput];
    
    NSString *s = [num stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return  s;
}
+ (CGFloat) getTextHeight:(NSString*)str atFont:(UIFont*)font
{
    CGSize size = CGSizeMake(300, 9999);// here is some trick.
    //CGSize textSize = [str sizeWithFont:font constrainedToSize:size];
    CGRect textRect = [str boundingRectWithSize:size
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{NSFontAttributeName:font}
                                        context:nil];
    
    CGSize size1 = textRect.size;
    return size1.height;
}

+ (void)moveTextFieldUpForView:(UIView *)forView forTextField:(UITextField *)textField forSubView:(UIView *)forSubView
{
    CGRect textFieldRect =
    [forView.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [forView.window convertRect:forSubView.bounds fromView:forSubView];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = forSubView.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [forSubView setFrame:viewFrame];
    
    [UIView commitAnimations];
}
+ (void)moveTextFieldDownforView:(UIView *)forSubView{
    CGRect viewFrame = forSubView.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [forSubView setFrame:viewFrame];
    
    [UIView commitAnimations];
}

+ (void)moveTextViewUpForView:(UIView *)forView forTextView:(UITextView *)textView forSubView:(UIView *)forSubView
{
    CGRect textViewRect =
    [forView.window convertRect:textView.bounds fromView:textView];
    CGRect viewRect =
    [forView.window convertRect:forSubView.bounds fromView:forSubView];
    
    CGFloat midline = textViewRect.origin.y + 0.5 * textViewRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = forSubView.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [forSubView setFrame:viewFrame];
    
    [UIView commitAnimations];
}
+ (void)moveTextViewDownforView:(UIView *)forSubView
{
    CGRect viewFrame = forSubView.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [forSubView setFrame:viewFrame];
    
    [UIView commitAnimations];
}

+(NSString *)insertNewLineInText :(NSString *)htmlMessage
{
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"editor" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    NSString *source = [[NSBundle mainBundle] pathForResource:@"ZSSRichTextEditor" ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--content-->" withString:htmlMessage];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"%26" withString:@"&"];
    return htmlString;
    
    
//    NSMutableString *userNotes = [[NSMutableString alloc]initWithString:htmlMessage];
//    [userNotes insertString:@"<div style=\"width: 280px; word-wrap: break-word\">" atIndex:0];
//    [userNotes insertString:@"</div>" atIndex:htmlMessage.length];
//    return userNotes;
    
//        NSMutableString *userNotes = [[NSMutableString alloc]initWithString:htmlMessage];
//        NSInteger templeng  = 0;
//        NSInteger range = 35;
//    
//    while (templeng < userNotes.length)
//        {
//            NSRange start = [userNotes rangeOfString:@"<"];
//            if (start.location != NSNotFound)
//            {
//                NSRange end = [userNotes rangeOfString:@">"];
//                if (end.location != NSNotFound)
//                {
//                    if(templeng > range)
//                    {
//                        [userNotes insertString:@"\n" atIndex:end.location];
//                        range = range+35;
//                    }
//                    templeng  = templeng+1;
//                    //htmlMessageText = [htmlMessageText substringToIndex:end.location];
//                }
//            }
//            templeng  = templeng+1;
//        }
//        return userNotes;
    
//    NSMutableString *userNotes = [[NSMutableString alloc]initWithString:str];
//    NSInteger templeng  = 34;
//    NSInteger range = 35;
//    while (templeng < userNotes.length)
//    {
//        if(templeng > range)
//        {
//            [userNotes insertString:@"\n" atIndex:range];
//            range = range+35;
//        }
//        templeng  = templeng+1;
//    }
}


+ (void)showAlertControllerWithSingleButtonMessage:(NSString *)message title:(NSString *)titleMessage view:(UIViewController *)viewController delegateClass:(id)delegate
{
    if (IS_IOS8)
    {
        
        NSMutableAttributedString *messageToDisplay = [[NSMutableAttributedString alloc] initWithString:message];
        
        [messageToDisplay addAttribute:NSFontAttributeName
                                 value:[UIFont systemFontOfSize:12.0]
                                 range:NSMakeRange(0, messageToDisplay.length)];
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@",messageToDisplay] preferredStyle:UIAlertControllerStyleAlert];
        
        [alertVC setValue:messageToDisplay forKey:@"attributedMessage"];
        
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"Ok", nil)
                                       style:UIAlertActionStyleCancel
                                       handler:^(UIAlertAction *action)
                                       {
                                           [alertVC dismissViewControllerAnimated:YES completion:nil];
                                       }];
        
        [alertVC addAction:cancelAction];
        [viewController.view.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
        
    }
    else
    {
//        UIAlertView *saveAlert=[[UIAlertView alloc]initWithTitle:titleMessage message:message delegate:delegate cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [saveAlert show];
    }
}

+ (void)addBorderToView:(UIView *)view{
    CGFloat borderWidth = 2.0f;
    view.frame = CGRectInset(view.frame, -borderWidth, -borderWidth);
    view.layer.borderColor = [UIColor blackColor].CGColor;
    view.layer.borderWidth = borderWidth;
}

@end


/*
 
//Play You tube Videos
 - (void)embedYouTube:(NSString*)url frame:(CGRect)frame
 {
 NSString* embedHTML = @"<html><head> <style type=\"text/css\">body {background-color: transparent;color: white;}</style></head><body style=\"margin:0\"><embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" width=\"%0.0f\" height=\"%0.0f\"></embed></body></html>";
 NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
 
 UIWebView *webView =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 480)];
 [webView loadHTMLString:html baseURL:nil];
 [self.view addSubview:webView];
 }
 - (void)viewDidLoad
 {
 [self embedYouTube:@"http://www.youtube.com/watch?v=lzsBwnv_dAg&feature=player_embedded" frame:CGRectMake(0, 0, SCREEN_WIDTH, 480)];
 [super viewDidLoad];
 }
 
 */

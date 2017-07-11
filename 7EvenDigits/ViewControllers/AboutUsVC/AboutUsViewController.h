//
//  AboutUsViewController.h
//  7EvenDigits
//
//  Created by Krishna on 30/09/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MenuViewController;
@interface AboutUsViewController : BaseViewController<UIWebViewDelegate>
{
    
}
@property (strong, nonatomic)IBOutlet UIWebView *aboutUsWebView;

@end

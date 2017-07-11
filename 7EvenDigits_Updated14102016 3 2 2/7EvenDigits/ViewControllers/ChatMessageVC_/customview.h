//
//  customview.h
//  ImageUpload
//
//  Created by Neha_Mac on 22/09/16.
//  Copyright © 2016 zak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface customview : UIView
{
    float current_value;
    float new_to_value;
    
   // UILabel *ProgressLbl;
    
    id delegate;
    UIView *circleviews;
    
    BOOL IsAnimationInProgress;
}
@property id delegate;
@property float current_value;
@property (strong ,nonatomic) UILabel *ProgressLbl;
- (id)init:(UIView *)views;
- (void)setProgress:(NSNumber*)value;

@end

@protocol CustomProgressViewDelegate
- (void)didFinishAnimation:(customview*)progressView;

@end

//
//  customview.m
//  ImageUpload
//
//  Created by Neha_Mac on 22/09/16.
//  Copyright © 2016 zak. All rights reserved.
//

#import "customview.h"

@implementation customview
@synthesize ProgressLbl,current_value;
- (id)init:(UIView *)views
{
    circleviews=views;
    self = [super initWithFrame:views.frame];
    if (self) {
        // Initialization code
        current_value = 0.0;
        new_to_value = 0.0;
        IsAnimationInProgress = NO;
        
        self.alpha = 0.95;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.6];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        ProgressLbl = [[UILabel alloc] initWithFrame:CGRectMake(circleviews.frame.size.width/3-10,50,100,30)];
        ProgressLbl.font = [UIFont boldSystemFontOfSize:14.0];
        ProgressLbl.text = @"0%";
        ProgressLbl.backgroundColor = [UIColor clearColor];
        ProgressLbl.textColor = [UIColor whiteColor];
        ProgressLbl.textAlignment = NSTextAlignmentCenter ;
        ProgressLbl.alpha = self.alpha;
      // [self addSubview:ProgressLbl];
    }
    return self;
}
-(void)UpdateLabelsWithValue:(NSString*)value
{
    ProgressLbl.text = value;
}
-(void)setProgressValue:(float)to_value withAnimationTime:(float)animation_time
{
    float timer = 0;
    
    float step = 0.1;
    
    float value_step = (to_value-self.current_value)*step/animation_time;
    int final_value = self.current_value*100;
    
    while (timer<animation_time-step) {
        final_value += floor(value_step*100);
        [self performSelector:@selector(UpdateLabelsWithValue:) withObject:[NSString stringWithFormat:@"%i%%", final_value] afterDelay:timer];
        timer += step;
    }
    
    [self performSelector:@selector(UpdateLabelsWithValue:) withObject:[NSString stringWithFormat:@"%.0f%%", to_value*100] afterDelay:animation_time];
}
-(void)SetAnimationDone
{
    IsAnimationInProgress = NO;
    if (new_to_value>self.current_value)
        [self setProgress:[NSNumber numberWithFloat:new_to_value]];
}

- (void)setProgress:(NSNumber*)value{
    
    float to_value = [value floatValue];
    
    if (to_value<=self.current_value)
        return;
    else if (to_value>1.0)
        to_value = 1.0;
    
    if (IsAnimationInProgress)
    {
        new_to_value = to_value;
        return;
    }
    
    IsAnimationInProgress = YES;
    
    float animation_time = to_value-self.current_value;
    
    [self performSelector:@selector(SetAnimationDone) withObject:Nil afterDelay:animation_time];
    
    if (to_value == 1.0 && delegate && [delegate respondsToSelector:@selector(didFinishAnimation:)])
        [delegate performSelector:@selector(didFinishAnimation:) withObject:self afterDelay:animation_time];
    
    [self setProgressValue:to_value withAnimationTime:animation_time];
    
    float start_angle = 2*M_PI*self.current_value-M_PI_2;
    float end_angle = 2*M_PI*to_value-M_PI_2;
    
    float radius = 22.0;
    
    CAShapeLayer *circle = [CAShapeLayer layer];
    
    // Make a circular shape
    
    circle.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/3,self.frame.size.height/3)
                                                 radius:radius startAngle:start_angle endAngle:end_angle clockwise:YES].CGPath;
    
    // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor orangeColor].CGColor;
    circle.lineWidth = 2;
    
    if (IS_IPHONE_6)
    {
        circle.frame=CGRectMake(41, 31, 10, 10);
    }
    else if(IS_IPHONE_6P)
    {
        circle.frame=CGRectMake(45, 31, 10, 10);
    }
    else
    {
        circle.frame=CGRectMake(33, 31, 10, 10);
    }
    [self.layer addSublayer:circle];
    
    // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    drawAnimation.duration            = animation_time;
    drawAnimation.repeatCount         = 0.0;  // Animate only once..
    drawAnimation.removedOnCompletion = NO;   // Remain stroked after the animation..
    
    // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0];
    
    // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
    self.current_value = to_value;
}


@end

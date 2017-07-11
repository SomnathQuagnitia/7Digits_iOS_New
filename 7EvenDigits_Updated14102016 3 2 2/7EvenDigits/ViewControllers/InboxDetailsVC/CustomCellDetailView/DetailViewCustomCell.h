//
//  DetailViewCustomCell.h
//  7EvenDigits
//
//  Created by Krishna on 08/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewCustomCell : UITableViewCell

@property(strong,nonatomic)IBOutlet UIImageView *imageViewInReply;
@property(strong,nonatomic)IBOutlet UILabel *dateInInboxDetail;
@property(strong,nonatomic)IBOutlet UILabel *fromNameLabel;
@property(strong,nonatomic)IBOutlet UILabel *toNameLabel;
@property(strong,nonatomic)IBOutlet UILabel *postingTitleLabel;
@property(strong,nonatomic)IBOutlet UIWebView *messageWebView;

@end

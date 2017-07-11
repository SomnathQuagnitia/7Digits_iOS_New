//
//  InboxMessageCustomCell.h
//  7EvenDigits
//
//  Created by Krishna on 08/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InboxMessageCustomCell : UITableViewCell
@property(strong, nonatomic)IBOutlet UILabel *nameLabel;
@property(strong, nonatomic)IBOutlet UILabel *dateLabel;
@property(strong, nonatomic)IBOutlet UILabel *messageLabel;
@property (strong, nonatomic) IBOutlet UIButton *checkBoxButton;
@property (strong, nonatomic) IBOutlet UIImageView *isAttachment;

@end

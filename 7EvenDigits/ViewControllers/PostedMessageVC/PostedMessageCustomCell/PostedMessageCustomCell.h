//
//  PostedMessageCustomCell.h
//  7EvenDigits
//
//  Created by Krishna on 09/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostedMessageCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageViewForProfileImage;
@property (strong, nonatomic) IBOutlet UILabel *labelForMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelForState;
@property (strong, nonatomic) IBOutlet UILabel *labelForeAge;
@property (strong, nonatomic) IBOutlet UILabel *labelForCity;
@property (strong, nonatomic) IBOutlet UILabel *labelForMessageFrom;
@property (strong, nonatomic) IBOutlet UILabel *labelForPostedDate;
@property (strong, nonatomic) IBOutlet UILabel *labelForStartedByName;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewForStatusImage;

@property (strong, nonatomic) IBOutlet UIButton *startedByButton;

@property (strong, nonatomic) IBOutlet UIButton *statusButton;

@property (strong, nonatomic) IBOutlet UIButton *buttonForAddContact;
@end

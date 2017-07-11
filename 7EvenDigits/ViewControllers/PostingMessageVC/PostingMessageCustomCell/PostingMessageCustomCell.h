//
//  PostingMessageCustomCell.h
//  7EvenDigits
//
//  Created by Krishna on 09/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostingMessageCustomCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIImageView *statusImage;
@property(strong,nonatomic)IBOutlet UILabel *labelforMessage;
@property(strong,nonatomic)IBOutlet UILabel *labelForDate;
@property(strong,nonatomic)IBOutlet UILabel *labelForStatus;
@property(strong,nonatomic)IBOutlet UILabel *labelForTitle;




@end

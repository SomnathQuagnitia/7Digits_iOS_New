//
//  DraftCustomCell.h
//  7EvenDigits
//
//  Created by Krishna on 08/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraftCustomCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIImageView *imageViewForDraftStatusImage;
@property(strong,nonatomic)IBOutlet UILabel *labelForDraftTitle;
@property(strong,nonatomic)IBOutlet UILabel *labelForMessage;
@property(strong,nonatomic)IBOutlet UILabel *labelForDraftDate;
@property(strong,nonatomic)IBOutlet UIButton *deleteDraftButton;
@end

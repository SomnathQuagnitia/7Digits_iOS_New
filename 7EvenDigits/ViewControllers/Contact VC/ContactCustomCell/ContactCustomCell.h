//
//  ContactCustomCell.h
//  7EvenDigits
//
//  Created by Krishna on 08/10/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactCustomCell : UITableViewCell
@property(strong,nonatomic)IBOutlet UIImageView *imageViewForContactImage;
@property(strong,nonatomic)IBOutlet UIImageView *imageViewForContactStatusImage;
@property(strong,nonatomic)IBOutlet UILabel *labelForContactName;
@property(strong,nonatomic)IBOutlet UILabel *labelForContactID;
    @property(strong,nonatomic)IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UILabel *ProfileType;
@property (strong, nonatomic) IBOutlet UIScrollView *contactIDScrollView;





@end

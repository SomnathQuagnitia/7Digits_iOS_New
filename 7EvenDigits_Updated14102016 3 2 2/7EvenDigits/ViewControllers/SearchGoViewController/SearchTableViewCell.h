//
//  SearchTableViewCell.h
//  7EvenDigits
//
//  Created by nikhil on 9/16/16.
//  Copyright © 2016 Quagnitia Systems. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *professionalImgView;
@property (strong, nonatomic) IBOutlet UIImageView *personalImgView;
@property (strong, nonatomic) IBOutlet UILabel *occupationLbl;
@property (strong, nonatomic) IBOutlet UILabel *compnayNameLbl;
@property (strong, nonatomic) IBOutlet UILabel *stateLbl;
@property (strong, nonatomic) IBOutlet UILabel *cityLbl;
@property (strong, nonatomic) IBOutlet UILabel *UserIdLbl;
@property (strong, nonatomic) IBOutlet UIButton *PersonalBtnAction;
@property (strong, nonatomic) IBOutlet UIButton *ProfessionalBtnAction;
@property (strong, nonatomic) IBOutlet UIButton *professionalImgBtn;
@property (strong, nonatomic) IBOutlet UIButton *personalImgBtn;
@property (strong, nonatomic) IBOutlet UILabel *userExitsMsg;
@property (strong, nonatomic) IBOutlet UILabel *professionalProfileLbl;
@property (strong, nonatomic) IBOutlet UILabel *personalProfileLbl;
@property (strong, nonatomic) IBOutlet UILabel *LastName;

@property (strong, nonatomic) IBOutlet UIScrollView *titleScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *companyScrollView;

@end

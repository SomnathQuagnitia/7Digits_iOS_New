//
//  ChatViewController.h
//  7EvenDigits
//
//  Created by Krishna on 06/10/14.
//  Copyright (c) 2014 Krishna. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ChatViewController : BaseViewController
{
    UITextField *textFieldObj;
    NSString *otherUsersID;
    NSString *otherUsersName;
    BOOL islogEditing;
    NSString *isChattingWithUser;
    int padding;
    BOOL isInternetAvailable;
    NSMutableArray *chatMessageArray;

    NSMutableDictionary *chatMessageDict;
    CGFloat height;
}

@property(nonatomic, retain) IBOutlet UITableView *tableViewObj;
@property(strong, nonatomic) IBOutlet UITextField *textFieldObj;

@end



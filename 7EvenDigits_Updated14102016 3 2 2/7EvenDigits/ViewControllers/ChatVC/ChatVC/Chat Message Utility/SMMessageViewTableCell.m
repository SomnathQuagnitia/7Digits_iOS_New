//
//  SMMessageViewTableCell.m
//  JabberClient
//
//  Created by cesarerocchi on 9/8/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "SMMessageViewTableCell.h"
#import "Parameters.h"


@implementation SMMessageViewTableCell

@synthesize senderAndTimeLabel, messageContentView, bgImageView,replyImageView,senderImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) 
    {
        //senderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(175, 5, 400, 30)];
        
        replyImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:replyImageView];
        
        senderImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:senderImageView];

        senderAndTimeLabel = [[UILabel alloc] init];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            [senderAndTimeLabel setFrame:CGRectMake(175, 5, 400, 30)];
            senderAndTimeLabel.font = [UIFont systemFontOfSize:12.0];
            [senderAndTimeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        }
        else
        {
            [senderAndTimeLabel setFrame:CGRectMake(0, 5, SCREEN_WIDTH, 25)];
            senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
            [senderAndTimeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:11]];
        }
		senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
		senderAndTimeLabel.textColor = [UIColor lightGrayColor];
        senderAndTimeLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:senderAndTimeLabel];
		
		bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        bgImageView.userInteractionEnabled = false;
		[self.contentView addSubview:bgImageView];
		
		messageContentView = [[UITextView alloc] init];
		messageContentView.backgroundColor = [UIColor clearColor];
		messageContentView.editable = NO;
		messageContentView.scrollEnabled = NO;
        messageContentView.userInteractionEnabled = false;
		[messageContentView sizeToFit];
		[self.contentView addSubview:messageContentView];
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}








@end

//
//  FeedViewWebService.h
//  Precog
//
//  Created by sachin on 05/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParserDelegate <NSObject>
- (void)receivedfeeds:(NSDictionary *)theItems;
@end


@interface FeedViewWebService : NSObject 
{
	id _delegate;
	NSDictionary *items;
    NSURLConnection *theConnection;
    NSMutableData *webData;
    NSString *userStatus;
}
@property (retain, nonatomic) NSDictionary *items;

- (id)delegate;
- (void)setDelegate:(id)new_delegate;
//- (void)getFeeds:(id)aDelegate :(NSString *)urlString;
//- (void)parserDidEndDocument;
- (void)alertViewMethod:(NSString *)alertTitle :(NSString *)message;
//-(void)urlConnectionMethod:(NSMutableURLRequest *)theRequest;

@end

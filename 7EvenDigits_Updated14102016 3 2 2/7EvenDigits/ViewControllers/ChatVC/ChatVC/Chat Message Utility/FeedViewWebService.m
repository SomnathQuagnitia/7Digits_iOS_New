//
//  FeedViewWebService.m
//  Precog
//
//  Created by sachin on 05/09/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FeedViewWebService.h"
//#import "Constant.h"
//#import "JSON.h"
//#import "AppDelegate_iPad.h"
//#import "AppDelegate_iPhone.h"

@implementation FeedViewWebService
@synthesize items;
-(id)init
{
	return self;
}

/*
-(void)getFeeds:(id)aDelegate :(NSString *)urlString
{
	[self setDelegate:aDelegate];
	NSString* url=[NSString stringWithFormat:@"%@changestatus.php",BASE_URL_GLOBLE ];
	
	
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60.0];
	//do post request for parameter passing 
	[theRequest setHTTPMethod:@"POST"];
	//set the content type to JSON
    
    //udid,flag
    [theRequest setValue:urlString forHTTPHeaderField:@"flag"];
    userStatus = [[NSString alloc]initWithFormat:@"%@",urlString];
    //userid
    [theRequest setValue:user_idStr forHTTPHeaderField:@"userid"];
    NSString *deviceUDID =[[NSString alloc] initWithFormat:@"%@", [UIDevice currentDevice].uniqueIdentifier];
    //    //NSLog(@"deviceUDID : %@",deviceUDID);
    [theRequest addValue:[NSString stringWithString:deviceUDID] forHTTPHeaderField:@"udid"];
    
    [self urlConnectionMethod:theRequest];
    
}
*/
/*
-(void)urlConnectionMethod:(NSMutableURLRequest *)theRequest
{
    if (theConnection!=nil)
	{
		theConnection=nil;
	}
    //	theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    
    theConnection = [[NSURLConnection alloc] init];
    
    NSURLResponse *responceObj = [[NSURLResponse alloc] init];
    NSError *error;
    NSData *data =     [NSURLConnection sendSynchronousRequest:theRequest returningResponse:&responceObj error:&error];
	NSString *result = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];
//	//NSLog(@"JSON Data-%@",result);
    
    SBJSON *parser=[[SBJSON alloc]init];
    
    if ([userStatus isEqualToString:@"1"])
    {
        @try 
        {
            if([[parser objectWithString:result error:nil] isKindOfClass:[NSMutableDictionary class]])
            {
                NSMutableDictionary *validDict = [parser objectWithString:result error:nil] ;
                
                [ChatNotification synchroniseUserDefault];
                
                if ([[validDict valueForKey:@"sentMessageUserDetail"] isKindOfClass:[NSArray class]])
                {
                    int i;
                    for ( i = 0; i < [[validDict valueForKey:@"sentMessageUserDetail"] count]; i ++)
                    {
                        [ChatNotification setUserInChatRoom:[[[validDict valueForKey:@"sentMessageUserDetail"]objectAtIndex:i] valueForKey:@"user_id"] userDetail:[[validDict valueForKey:@"sentMessageUserDetail"]objectAtIndex:i]];
                        
                        NSMutableArray *messageArray = [[NSMutableArray alloc] initWithArray:[[[validDict valueForKey:@"sentMessageUserDetail"]objectAtIndex:i]valueForKey:@"messages"]];
                        for (int i = 0; i < [messageArray count]; i++)
                        {
                            NSMutableDictionary *messageDict = [[messageArray objectAtIndex:i] valueForKey:@"aps"];
                            
                            if ([[messageDict valueForKey:@"F"] intValue] == 1 )
                            {
                                [ChatNotification isDeletedMessageLogWithUserID:[messageDict valueForKey:@"sid"] messageDetail:messageDict];
                            }
                            else
                            {
                                [ChatNotification setUserNotificationCountToUserID:[messageDict valueForKey:@"sid"] messageDict:messageDict appBubboleView:YES];
                            }
                        }
                    }
                    [self setTabBarBadge];
                }
            }
        }
        @catch (NSException *exception) 
        {
            //NSLog(@"Exception :: %@",[exception reason]);
        }
    }
}
*/
//- (void)setTabBarBadge
//{
//    if ([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad)
//    {
//        AppDelegate_iPad *iPad_Dalegate = (AppDelegate_iPad *)[[UIApplication sharedApplication] delegate];
//        [iPad_Dalegate setTabBarItemBadge];
//    }
//    else
//    {
//        AppDelegate_iPhone *iPhone_Dalegate = (AppDelegate_iPhone *)[[UIApplication sharedApplication] delegate];
//        [iPhone_Dalegate setTabBarItemBadge];
//    }
//}
/*
#pragma mark -
#pragma mark Connection delegate for login service

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //     //NSLog(@"ERROR with theConenction |%@|",error);   
    //	if ([_delegate respondsToSelector:@selector(receivedfeeds:)])
    //	{
    //		[_delegate receivedfeeds:items];
    //	}
    //	else
    //	{ 
    //		[NSException raise:NSInternalInconsistencyException
    //					format:@"Delegate doesn't respond to receivedfeeds:"];
    //	}
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //	NSString *result = [[NSString alloc]initWithData:webData encoding:NSASCIIStringEncoding];
    //	//NSLog(@"JSON Data-%@",result);
}
*/
//- (void)parserDidEndDocument
//{
//	if ([_delegate respondsToSelector:@selector(receivedfeeds:)])
//        [_delegate receivedfeeds:items];
//    else
//    { 
//        [NSException raise:NSInternalInconsistencyException
//					format:@"Delegate doesn't respond to receivedfeeds:"];
//    }
//}

#pragma mark AlertView Method
-(void)alertViewMethod:(NSString *)alertTitle :(NSString *)message
{
//	UIAlertView *alertObj=[[UIAlertView alloc]initWithTitle:alertTitle message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
//	[alertObj show];
}

#pragma mark ----------------------------Delegate methods----------------------------
- (id)delegate 
{
	return _delegate;
}

- (void)setDelegate:(id)new_delegate 
{
	_delegate = new_delegate;
}

@end


//
//  ConnectionManager.m
//  WSTest
//
//  Created by Vijay on 17/09/13.
//  Copyright (c) 2013 Vijay. All rights reserved.
//

#import "ConnectionManager.h"
#import "AddContactViewController.h"
@implementation ConnectionManager
@synthesize webData;

- (id)initWithTarget: (id) delegate_in selector:(SEL) function
{
	if ((self = [super init])) {
		aDelegate = delegate_in;
		selector = function;
	}
	return self;
}

- (void)getWebDataFromRequestData:(NSData*)reqData URL:(NSString *)Baseurl
{
    
    NSString *url=Baseurl;
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]
															cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
														timeoutInterval:120.0];
    [theRequest setHTTPMethod:@"GET"];
    [theRequest setHTTPBody:reqData];
    if (serverConnectionObj) {
        serverConnectionObj = nil;
    }
    serverConnectionObj = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    self.webData = [[NSMutableData alloc] init];
}

- (void)getWebData:(id)aDelegate commandURL:(NSString*)commandURL
{
 
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:commandURL]
															cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
														timeoutInterval:120.0];
	
	[theRequest setHTTPMethod:@"GET"];
    [theRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (serverConnectionObj) {
        serverConnectionObj = nil;
    }

	serverConnectionObj= [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	if( serverConnectionObj)
	{
		self.webData= [[NSMutableData alloc] init];
	}
	else
	{
    }
}


- (void)UploadImage:(NSString *)ImageName Image:(UIImage *)Image commandURL:(NSString*)commandURL
{
    
    commandURL=[commandURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
   
    NSURL* requestURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",commandURL]];
    
    ImageName = [NSString stringWithFormat:@"%@.jpg",ImageName];
    
    
    NSMutableURLRequest *urequest = [NSMutableURLRequest requestWithURL:requestURL];
    
    [urequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urequest setHTTPShouldHandleCookies:NO];
    [urequest setTimeoutInterval:60];
    [urequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  
    [urequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
 
    NSData *imageData = UIImageJPEGRepresentation(Image, 1.0);


    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"ImageArray\"; filename=\"image.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urequest setHTTPBody:body];
  
    
    if (serverConnectionObj)
    {
        serverConnectionObj = nil;
    }
    
	serverConnectionObj= [[NSURLConnection alloc] initWithRequest:urequest delegate:self];
	if( serverConnectionObj)
	{
		self.webData= [[NSMutableData alloc] init];
	}
	else
	{
		
	}
}

-(void)uploadChatVideo:(NSString *)VideoName uploadVideo:(NSData *)uploadVideo commandURL:(NSString*)commandURL
{
    commandURL=[commandURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
     NSURL* requestURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",commandURL]];
    
    VideoName = [NSString stringWithFormat:@"%@.mp4",VideoName];
    NSMutableURLRequest *urequest = [NSMutableURLRequest requestWithURL:requestURL];
    
    [urequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urequest setHTTPShouldHandleCookies:NO];
    [urequest setTimeoutInterval:150];
    
    [urequest setHTTPMethod:@"POST"];
    NSString *boundary = @"+++++ABck";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urequest addValue:contentType forHTTPHeaderField:@"Content-Type"];
    deleteURL=urequest;
    NSMutableData *body = [NSMutableData data];
    
    if(uploadVideo)
    {
      [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",VideoName] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[@"Content-Type: video/quicktime\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
      [body appendData:[NSData dataWithData:uploadVideo]];
      [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [urequest setHTTPBody:body];
    mediaType = @"Video";
   
    if (serverConnectionObj)
    {
        serverConnectionObj = nil;
    }
    serverConnectionObj= [[NSURLConnection alloc] initWithRequest:urequest delegate:self];
    if( serverConnectionObj)
    {
        self.webData= [[NSMutableData alloc] init];
    }
}


- (void)UploadChatImage:(NSString *)ImageName Image:(UIImage *)Image commandURL:(NSString*)commandURL
{
    commandURL=[commandURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL* requestURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",commandURL]];
    NSMutableURLRequest *urequest = [NSMutableURLRequest requestWithURL:requestURL];
    [urequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urequest setHTTPShouldHandleCookies:NO];
    [urequest setTimeoutInterval:100];
    [urequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [urequest setValue:contentType forHTTPHeaderField: @"Content-Type"];

    NSMutableData *body = [NSMutableData data];
    NSData *imageData = UIImageJPEGRepresentation(Image, 1.0);
    NSString *imgStr=[NSString stringWithFormat:@"%0.0f_%@.jpg",([[NSDate date] timeIntervalSince1970]  *1000),CURRENT_USER_ID];

    
    if (imageData)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[ [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ImageArray\"; filename=%@\r\n", imgStr] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData: imageData];
        
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [urequest setHTTPBody:body];
     mediaType = @"Image";
   if (serverConnectionObj)
    {
        serverConnectionObj = nil;
    }
    
    serverConnectionObj= [[NSURLConnection alloc] initWithRequest:urequest delegate:self];
    if( serverConnectionObj)
    {
        self.webData= [[NSMutableData alloc] init];
        //deleteData=[[NSMutableData alloc]initWithData:webData];
    }
    else
    {
    }
    
}


-(void)uploadVideo:(NSString *)VideoName Video:(NSData *)Video commandURL:(NSString*)commandURL
{
   
    commandURL=[commandURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL* requestURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",commandURL]];
    
    VideoName = [NSString stringWithFormat:@"%@.mp4",VideoName];
    NSMutableURLRequest *urequest = [NSMutableURLRequest requestWithURL:requestURL];
    
    [urequest setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [urequest setHTTPShouldHandleCookies:NO];
    [urequest setTimeoutInterval:60];
    [urequest setHTTPMethod:@"POST"];
    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [urequest setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    
    
    if (Video)
    {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"ImageArray\"; filename=%@\"\r\n" , VideoName] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:Video];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urequest setHTTPBody:body];
   
    
    if (serverConnectionObj)
    {
        serverConnectionObj = nil;
    }
    
    serverConnectionObj= [[NSURLConnection alloc] initWithRequest:urequest delegate:self];
    if(serverConnectionObj)
    {
        self.webData= [[NSMutableData alloc] init];
    }
    else
    {
    }
}


#pragma mark NSURLConnection delegate method starts
-(void) connection:(NSURLConnection * ) connection didFailWithError:(NSError *)error
{
    if([mediaType isEqualToString:@"Video"] || [mediaType isEqualToString:@"Image"])
    {
       
        if (error.code == NSURLErrorTimedOut){
         NSLog(@"Request time out");
             [SVProgressHUD showErrorWithStatus:@"Request time out"];
            [SVProgressHUD dismiss];
        }
    }
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[self.webData setLength: 0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.webData appendData:data];
}

-(void)connection:(NSURLConnection *)connection di9ailWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"Check connectivity and try again" maskType:SVProgressHUDMaskTypeBlack];
}

-(void)connectionDidFinishLoading:(NSURLConnection *) connection
{
   NSString *responseString = [[NSString alloc] initWithData:self.webData encoding:NSUTF8StringEncoding];
   NSLog(@"responseString: %@",responseString);
    serverConnectionObj = nil;
    id dict = [NSJSONSerialization JSONObjectWithData:self.webData options:kNilOptions  error:nil];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self getMethodSignature]];
	[invocation setSelector:selector];
	[invocation setTarget: aDelegate];
	[invocation setArgument:&dict atIndex:2];
	[invocation invoke];
}


- (NSMethodSignature *) getMethodSignature
{
	SEL mySelector;
	mySelector = @selector(webOperationEnded:);
    NSMethodSignature * sig = nil;
	sig = [[self class] instanceMethodSignatureForSelector:mySelector];
	return sig;
}
- (void)webOperationEnded:(NSDictionary *)responseDict{
    
}

//- (void)webOperationEndForVideo{  
//    [serverConnectionObj cancel];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(uploadChatVideo:uploadVideo:commandURL:) object:self.webData];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self.webData];
//    [self.webData setLength:0];
//     [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [self getMethodSignature];
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    serverConnectionObj =nil;
//    NSLog(@"Your data has been cleared");
//    [SVProgressHUD dismiss];
//}
//- (void)setTimeoutInterval:(NSTimeInterval)timeoutInterval
//{
//    
//}

@end

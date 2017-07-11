



//
//  ServerIntegration.m
//  WSTest
//
//  Created by Vijay on 17/09/13.
//  Copyright (c) 2013 Vijay. All rights reserved.
//

#import "ServerIntegration.h"

@implementation ServerIntegration

//for Registration
-(void)RegistrationWebService:(id)theDelegate UserName:(NSString *)UserName Password:(NSString *)Password ConfirmPassword:(NSString *)ConfirmPassword Email:(NSString *)Email  DeviceId:(NSString *)DeviceId RegisterFrom:(int)RegisterFrom :(SEL) function
{
    
    aDelegate = theDelegate;
    selector = function;
    
    UserName = [UserName urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Password = [Password urlEncodeUsingEncoding:NSUTF8StringEncoding];
    ConfirmPassword = [ConfirmPassword urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Email = [Email urlEncodeUsingEncoding:NSUTF8StringEncoding];
  // DeviceId =
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserName=%@&Password=%@&ConfirmPassword=%@&Email=%@&DeviceId=%@&RegisterFrom=%d",BASE_URL_GLOBAL,sRegistration,UserName,Password,ConfirmPassword,Email,DeviceId,RegisterFrom];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//for Login
-(void)LoginWebService:(id)theDelegate UserName:(NSString *)UserName Password:(NSString *)Password DeviceId:(NSString *)DeviceId IsBackground:(NSString *)IsBackground :(SEL) function;
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserName=%@&Password=%@&DeviceId=%@&IsBackground=%@",BASE_URL_GLOBAL,sLogin,UserName,Password,DeviceId,IsBackground];
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    NSLog(@"Request: %@", urlStr);
    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}


//ForgotUserName
-(void)ForgotUserNameWebService:(id)theDelegate Email:(NSString *)Email :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@Email=%@",BASE_URL_GLOBAL,sForgotUserName,Email];
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    NSLog(@"Request: %@", urlStr);
    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
    
}

//For Change Password
-(void)ChangePasswordWebService:(id)theDelegate UserId:(NSString *)UserId Password:(NSString *)Password NewPassword:(NSString *)NewPassword ConfirmPassword:(NSString *)ConfirmPassword  :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&Password=%@&NewPassword=%@&ConfirmPassword=%@",BASE_URL_GLOBAL,sChangePassword,UserId,Password,NewPassword,ConfirmPassword];
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    NSLog(@"Request: %@", urlStr);
    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
    
}

//State list
-(void)GetStateList:(id)theDelegate q:(NSString *)q :(SEL) function; //for Get State
{
    aDelegate = theDelegate;
    selector = function;
    
    q = [q urlEncodeUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@q=%@",BASE_URL_GLOBAL,sGetStateList,q];
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
    
}



//City list
-(void)GetCityListWebService:(id)theDelegate StateId:(NSString *)StateId q:(NSString *)q :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    q = [q urlEncodeUsingEncoding:NSUTF8StringEncoding];
    NSString *urlStr=[NSString stringWithFormat:@"%@%@StateId=%@&q=%@",BASE_URL_GLOBAL,sGetCityList,StateId,q];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
    
}

//Zip list
-(void)GetZipListWebService:(id)theDelegate  CityId:(NSString *)CityId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@CityId=%@",BASE_URL_GLOBAL,sGetZipCodeList,CityId];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    
    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
    
}
//ForgotPassword
-(void)ForgotPasswordWebService:(id)theDelegate UserName:(NSString *)UserName Email:(NSString *)Email :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    UserName = [UserName urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Email = [Email urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserName=%@&Email=%@",BASE_URL_GLOBAL,sForgotPassword,UserName,Email];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

// PostMessage
-(void)PostMessage :(id)theDelegate UserId:(NSString *)UserId StateId:(NSString *)StateId CityId:(NSString *)CityId ZipCodeId:(NSString *)ZipCodeId Title:(NSString *)Title  Age:(NSString *)Age M2M:(NSString *)M2M  M2W:(NSString *)M2W  W2W:(NSString *)W2W W2M:(NSString *)W2M Everyone:(NSString *)Everyone LessThan30Days:(NSString *)LessThan30Days MessageHTML:(NSString *)MessageHTML Message:(NSString *)Message IsDraft:(NSString *)IsDraft PostMessageId:(NSString *)PostMessageId ImageName:(NSString *)ImageName Image:(UIImage *)Image :(SEL) function;
{
    aDelegate = theDelegate;
    selector = function;
    
    
    Title = [Title urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Message = [Message urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&StateId=%@&CityId=%@&ZipCodeId=%@&Title=%@&Age=%@&M2M=%@&M2W=%@&W2W=%@&W2M=%@&Everyone=%@&LessThan30Days=%@&MessageHTML=%@&Message=%@&IsDraft=%@&PostMessageId=%@&ImageName=%@",BASE_URL_GLOBAL,sPostMessage,UserId,StateId,CityId,ZipCodeId,Title,Age,M2M,M2W,W2W,W2M,Everyone,LessThan30Days,MessageHTML,Message,IsDraft,PostMessageId,ImageName];
    NSLog(@"Request: %@", urlStr);
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    
    [objConnectionManager UploadImage:ImageName Image:Image commandURL:urlStr];
}

//Contact list
-(void)GetContactListWebService:(id)theDelegate UserId:(NSString *)UserId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@",BASE_URL_GLOBAL,sGetContactList,UserId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//AddContact
-(void)AddContactWebService:(id)theDelegate UserId:(NSString *)UserId ContactId:(NSString *)ContactId UserName:(NSString *)UserName FirstName:(NSString *)FirstName LastName:(NSString *)LastName  Message:(NSString *)Message ImageName:(NSString *)ImageName Image:(UIImage *)Image PhoneNumber:(NSString *)PhoneNumber emailId:(NSString *)emailId userNotes:(NSString *)userNotes userCompany:(NSString *)userCompany userTitle:(NSString *)userTitle userAddress:(NSString *)userAddress profileId:(NSString *)profileId MobileNumber:(NSString *)MobileNumber WorkNumber:(NSString *)WorkNumber isImageChanged : (NSString *)isImageChanged state:(NSString *)state city:(NSString *)city location:(NSString *)location IsPublic:(int)IsPublic Occupation:(NSString *)Occupation profileType:(NSString*)profileType :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
  
    FirstName = [FirstName urlEncodeUsingEncoding:NSUTF8StringEncoding];
    LastName = [LastName urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Message = [Message urlEncodeUsingEncoding:NSUTF8StringEncoding];
    emailId = [emailId urlEncodeUsingEncoding:NSUTF8StringEncoding];
    userCompany = [userCompany urlEncodeUsingEncoding:NSUTF8StringEncoding];
    userTitle = [userTitle urlEncodeUsingEncoding:NSUTF8StringEncoding];
    userAddress = [userAddress urlEncodeUsingEncoding:NSUTF8StringEncoding];
    isImageChanged = [isImageChanged urlEncodeUsingEncoding:NSUTF8StringEncoding];
    state = [state urlEncodeUsingEncoding:NSUTF8StringEncoding];
    city = [city urlEncodeUsingEncoding:NSUTF8StringEncoding];
    location = [location urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Occupation = [Occupation urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&ContactId=%d&UserName=%@&FirstName=%@&LastName=%@&Message=%@&ImageName=%@&PhoneNumber=%@&EmailId=%@&userNotes=%@&userCompany=%@&userTitle=%@&userAddress=%@&profileId=%d&MobileNumber=%@&WorkNumber=%@&isImageChanged=%@&state=%@&city=%@&location=%@&IsPublic=%d&Occupation=%@&profileType=%d",BASE_URL_GLOBAL,sAddContact,UserId,[ContactId intValue],UserName,FirstName,LastName,Message,ImageName,PhoneNumber,emailId,userNotes,userCompany,userTitle,userAddress,[profileId intValue],MobileNumber,WorkNumber,isImageChanged,state,city,location,IsPublic,Occupation,[profileType intValue]];
    NSLog(@"Request: %@", urlStr);
    
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager UploadImage:ImageName Image:Image commandURL:urlStr];

}

//for CheckUserExist
-(void)CheckUserExistWebService:(id)theDelegate UserId:(NSString *)UserId UserName:(NSString *)UserName :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&UserName=%@",BASE_URL_GLOBAL,sCheckUserExist,UserId,UserName];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for ContactProfile
-(void)ContactProfileWebService:(id)theDelegate ContactId:(NSString *)ContactId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@ContactId=%@",BASE_URL_GLOBAL,sContactProfile,ContactId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for Logout
//-(void)LogoutWebService:(id)theDelegate UserId:(NSString *)UserId  :(SEL) function
-(void)LogoutWebService:(id)theDelegate UserId:(NSString *)UserId IsBackground:(NSString *)IsBackground :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&IsBackground=%@",BASE_URL_GLOBAL,sLogout,UserId,IsBackground];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//for PostingMessageList
-(void)PostingMessageListWebService:(id)theDelegate UserId:(NSString *)UserId  :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@PostUserId=%@",BASE_URL_GLOBAL,sPostMessageList,UserId];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for GetDraftMessageList
-(void)GetDraftMessageListWebService:(id)theDelegate UserId:(NSString *)UserId  :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@DraftUserId=%@",BASE_URL_GLOBAL,sGetDraftMessageList,UserId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for ContactUs
-(void)ContactUsWebService:(id)theDelegate Name:(NSString *)Name Email:(NSString *)Email PhoneNumber:(NSString *)PhoneNumber Message:(NSString *)Message :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    Name = [Name urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Message = [Message urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Email = [Email urlEncodeUsingEncoding:NSUTF8StringEncoding];

    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@Name=%@&Email=%@&PhoneNumber=%@&Message=%@",BASE_URL_GLOBAL,sContactUs,Name,Email,PhoneNumber,Message];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for GetZipCodeListByState
-(void)GetZipCodeListByState:(id)theDelegate StateId:(NSString *)StateId CityId:(NSString *)CityId Zip:(NSString *)Zip :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@StateId=%@&CityId=%@&Zip=%@",BASE_URL_GLOBAL,sGetZipCodeListByState,StateId,CityId,Zip];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
-(void)PostedMessageList :(id)theDelegate UserId:(NSString *)UserId KeyWord:(NSString *)KeyWord StateId:(NSString *)StateId CityId:(NSString *)CityId ZipCodeId:(NSString *)ZipCodeId M2M:(NSString *)M2M  M2W:(NSString *)M2W  W2W:(NSString *)W2W W2M:(NSString *)W2M Everyone:(NSString *)Everyone LessThan30Days:(NSString *)LessThan30Days :(SEL) function; //posted Message List
{
    aDelegate = theDelegate;
    selector = function;
    
    KeyWord = [KeyWord urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&KeyWord=%@&StateId=%@&CityId=%@&ZipCodeId=%@&M2M=%@&M2W=%@&W2W=%@&W2M=%@&Everyone=%@&LessThan30Days=%@",BASE_URL_GLOBAL,sPostedMessageList,UserId,KeyWord,StateId,CityId,ZipCodeId,M2M,M2W,W2W,W2M,Everyone,LessThan30Days];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
    
}

-(void)SearchPostedMessage :(id)theDelegate UserId:(NSString *)UserId KeyWord:(NSString *)KeyWord :(SEL) function; //Search posted Message List
{
    aDelegate = theDelegate;
    selector = function;
    
    KeyWord = [KeyWord urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&KeyWord=%@",BASE_URL_GLOBAL,sSearchPostedMessageList,UserId,KeyWord];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for PostedMessageDetail
-(void)PostedMessageDetail:(id)theDelegate UserId:(NSString *)UserId MessageId:(NSString *)MessageId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&MessageId=%@",BASE_URL_GLOBAL,sPostedMessageDetail,UserId,MessageId];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//Reply Messages
-(void)ReplyMessage:(id)theDelegate MessageId:(NSString *)MessageId FromUser:(NSString *)FromUser ToUser:(NSString *)ToUser SendCopy:(NSString *)SendCopy Reply:(NSString *)Reply  PlainMessage:(NSString *)PlainMessage FromInbox:(NSString *)FromInbox AttachmentName:(NSString *)AttachmentName Attachment:(UIImage *)Attachment :(SEL) function;
{
    aDelegate = theDelegate;
    selector = function;
    
    PlainMessage = [PlainMessage urlEncodeUsingEncoding:NSUTF8StringEncoding];

    NSString *urlStr=[NSString stringWithFormat:@"%@%@MessageId=%@&FromUser=%@&ToUser=%@&SendCopy=%@&Reply=%@&PlainMessage=%@&FromInbox=%@&AttachmentName=%@",BASE_URL_GLOBAL,sReplyMessage,MessageId,FromUser,ToUser,SendCopy,Reply,PlainMessage,FromInbox,AttachmentName];
    NSLog(@"Request: %@", urlStr);
    
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager UploadImage:AttachmentName Image:Attachment commandURL:urlStr];
}

//Inbox Message List
-(void)InboxMessagesList:(id)theDelegate UserId:(NSString *)UserId :(SEL) function;
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@",BASE_URL_GLOBAL,sInboxMessageList,UserId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
    
}

//DeletePostingMessage
-(void)DeletePostingMessage:(id)theDelegate MessageId:(NSString *)MessageId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@postMessageId=%@",BASE_URL_GLOBAL,sDeletePostingMessage,MessageId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//DeleteInboxMessage
-(void)DeleteInboxMessage:(id)theDelegate ReplyMessageId:(NSString *)ReplyMessageId UserId:(NSString *)UserId ProfileIds:(NSString *)ProfileIds :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@MessageId=%@&UserId=%@&ProfileIds=%@",BASE_URL_GLOBAL,sDeleteInboxMessage,ReplyMessageId,UserId,ProfileIds];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//AddContactFromPostMessageList
-(void)AddContactFromPostMessageList:(id)theDelegate UserId:(NSString *)UserId ContactId:(NSString *)ContactId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&ContactId=%@",BASE_URL_GLOBAL,sAddContactFromPostMessageList,UserId,ContactId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for RepostMessage

-(void)RepostMessage:(id)theDelegate  MessageId:(NSString *)MessageId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@MessageId=%@",BASE_URL_GLOBAL,sRepostMessage,MessageId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//DeleteContact
-(void)DeleteContact:(id)theDelegate ContactId:(NSString *)ContactId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@Contact=%@",BASE_URL_GLOBAL,sDeleteContact,ContactId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//for InboxDetailsList
-(void)InboxDetailsList:(id)theDelegate UserId:(NSString *)UserId MessageId:(NSString *)MessageId PostedById:(NSString *)PostedById FromInbox:(NSString *)FromInbox :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&MessageId=%@&PostedById=%@&FromInbox=%@",BASE_URL_GLOBAL,sInboxDetailsList,UserId,MessageId,PostedById,FromInbox];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

-(void)InsertChatMessage:(id)theDelegate FromUser:(NSString *)FromUser ToUser:(NSString *)ToUser ChatMessage:(NSString *)ChatMessage Type:(NSString *)Type data:(UIImage *)data fileName:(NSString *)fileName videoData:(NSData *)videoData :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@FromUser=%@&ToUser=%@&ChatMessage=%@&Type=%@&data=%@",BASE_URL_GLOBAL,sChat,FromUser,ToUser,ChatMessage,Type,nil];
    NSLog(@"Request URL : %@",urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    if ([Type isEqualToString:@"Image"])
    {
        [objConnectionManager UploadChatImage:fileName Image:data commandURL:urlStr];
    }
    else
    {
        [objConnectionManager uploadChatVideo:fileName uploadVideo:videoData commandURL:urlStr];
    }
}

//For Exits Contact(Search Profile)
-(void)IsContactAvailable:(id)theDelegate UserId:(NSString *)UserId Profileid:(int)Profileid :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&Profileid=%d",BASE_URL_GLOBAL,sCheckExitsUserContact,UserId,Profileid];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for GetChatHistory
-(void)GetChatHistory:(id)theDelegate userId:(NSString *)userId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@userId=%@",BASE_URL_GLOBAL,sGetChatHistory,userId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for GetOfflineChat
-(void)GetOfflineChat:(id)theDelegate userId:(NSString *)userId ContactId:(NSString *)ContactId  :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@user=%@&Contact=%@",BASE_URL_GLOBAL,sGetOfflineChat,userId,ContactId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//for GetContactsBadge
-(void)GetContactsBadge:(id)theDelegate userId:(NSString *)userId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@userId=%@",BASE_URL_GLOBAL,sGetContactsBadge,userId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];

}
//for CheckBackgroundStatus
-(void)CheckBackgroundStatus:(id)theDelegate userId:(NSString *)userId DeviceID:(NSString *)DeviceID IsBackground:(NSString *)IsBackground :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserID=%@&DeviceID=%@&IsBackground=%@",BASE_URL_GLOBAL,sCheckBackgroundStatus,userId,DeviceID,IsBackground];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
#pragma mark == Profile Web Sevices
//for GetLogInUserProfile
-(void)GetLogInUserProfile:(id)theDelegate userId:(NSString *)userId profileTypeId:(NSString *)profileTypeId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserID=%@&ProfileTypeId=%@",BASE_URL_GLOBAL,sViewLogInUserProfile,userId,profileTypeId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}


// New Update professional and Personal profile

-(void)UpdateLogInUserProfile:(id)theDelegate UserName:(NSString *)UserName FirstName:(NSString *)FirstName LastName:(NSString *)LastName EmailId:(NSString *)EmailId PhoneNumber:(NSString *)PhoneNumber  UserNotes:(NSString *)UserNotes UserTitle:(NSString *)UserTitle UserCompany:(NSString *)UserCompany UserAddress:(NSString *)UserAddress ProfileImageName:(NSString *)ProfileImageName Image:(UIImage *)Image ProfileTypeId:(NSString *)ProfileTypeId UserId:(NSString *)UserId MobileNumber:(NSString *)MobileNumber WorkNumber:(NSString *)WorkNumber isImageChanged:(NSString *)isImageChanged state:(NSString *)state city:(NSString *)city location:(NSString *)location IsPublic:(int)IsPublic Occupation:(NSString *)Occupation :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    FirstName = [FirstName urlEncodeUsingEncoding:NSUTF8StringEncoding];
    LastName = [LastName urlEncodeUsingEncoding:NSUTF8StringEncoding];
    UserNotes = [UserNotes urlEncodeUsingEncoding:NSUTF8StringEncoding];
    UserTitle = [UserTitle urlEncodeUsingEncoding:NSUTF8StringEncoding];
    UserCompany = [UserCompany urlEncodeUsingEncoding:NSUTF8StringEncoding];
    UserAddress = [UserAddress urlEncodeUsingEncoding:NSUTF8StringEncoding];
    EmailId =  [EmailId urlEncodeUsingEncoding:NSUTF8StringEncoding];
    UserName = [UserName urlEncodeUsingEncoding:NSUTF8StringEncoding];
    isImageChanged = [isImageChanged urlEncodeUsingEncoding:NSUTF8StringEncoding];
    state = [state urlEncodeUsingEncoding:NSUTF8StringEncoding];
   // city = [city urlEncodeUsingEncoding:NSUTF8StringEncoding];
    location = [location urlEncodeUsingEncoding:NSUTF8StringEncoding];
    Occupation = [Occupation urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@UserName=%@&FirstName=%@&LastName=%@&EmailId=%@&PhoneNumber=%@&UserNotes=%@&UserTitle=%@&UserCompany=%@&UserAddress=%@&ProfileImageName=%@&ProfileTypeId=%@&UserId=%@&MobileNumber=%@&WorkNumber=%@&isImageChanged=%@&state=%@&city=%@&location=%@&IsPublic=%d&Occupation=%@",BASE_URL_GLOBAL,sUpdateLogInUserProfile,UserName,FirstName,LastName,EmailId,PhoneNumber,UserNotes,UserTitle,UserCompany,UserAddress,ProfileImageName,ProfileTypeId,UserId,MobileNumber,WorkNumber,isImageChanged,state,city,location,IsPublic,Occupation];
    NSLog(@"Request: %@", urlStr);
    
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager UploadImage:ProfileImageName Image:Image commandURL:urlStr];
    
}


//for Send Profile
-(void)SendUserProfile:(id)theDelegate userId:(NSString *)userId reciverUserId:(NSString *)reciverUserId profileId:(NSString *)profileId Message:(NSString *)Message isRequest:(NSString*)isRequest :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&reciverUserId=%@&ProfileType=%@&Message=%@&isRequest=%@",BASE_URL_GLOBAL,sSendUserProfile,userId,reciverUserId,profileId,Message, isRequest];
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    NSLog(@"Request: %@", urlStr);
    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}


//for Ignore Profile
-(void)IgnoreUserProfile:(id)theDelegate profileId:(NSString *)profileId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;

    NSString *urlStr=[NSString stringWithFormat:@"%@%@/%@",BASE_URL_GLOBAL,sIgnoreUserProfile,profileId];
    NSLog(@"Request: %@", urlStr);
  //  urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}



//for Accept Profile
-(void)AcceptUserProfile:(id)theDelegate userId:(NSString *)userId isOverrride:(NSString *)isOverrride profileId:(NSString *)profileId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&isoverride=%@&id=%@",BASE_URL_GLOBAL,sAcceptUserProfile,userId,isOverrride,profileId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//for CheckContactAddedForAcceptProfile =
-(void)CheckContactAddedForAcceptProfile:(id)theDelegate userId:(NSString *)userId profileId:(NSString *)profileId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&id=%@",BASE_URL_GLOBAL,sAcceptUserProfile,userId,profileId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}



//for Accept Profile
-(void)CheckProfileUserExist:(id)theDelegate UserName:(NSString *)UserName :(SEL) function;
{
    aDelegate = theDelegate;
    selector = function;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserName=%@",BASE_URL_GLOBAL,sProfileUserExist,UserName];
    NSLog(@"Accept Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}
//For view Inbox Other User Profile
-(void)ViewInboxOtherUserProfile:(id)theDelegate profileId:(NSString *)profileId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@ProfileId=%@",BASE_URL_GLOBAL,sViewInboxProfile,profileId];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//For ViewContactProfile
-(void)ViewContact:(id)theDelegate contactId:(NSString *)contactId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@/%@",BASE_URL_GLOBAL,sViewContact,contactId];
    NSLog(@"Request: %@", urlStr);
    //urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//For Search View Profile

-(void)SearchViewProfile:(id)theDelegate UserProfileID:(int )UserProfileID :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserProfileID=%d",BASE_URL_GLOBAL,sViewSearchProfile,UserProfileID];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}


//upload videoImage in profiles
-(void)uploadVideoImage:(id)theDelegate UserId:(NSString *)UserId ProfileTypeId:(NSString *)ProfileTypeId ProfileVideoImageName:(NSString *)ProfileVideoImageName videoImage:(UIImage *)videoImage isImageChanged:(NSString *)isImagehanged :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&typeId=%@&ProfileVideoImage=%@&isImageChanged=%@",BASE_URL_GLOBAL,sUploadVideoImage,UserId,ProfileTypeId,ProfileVideoImageName,isImagehanged];
    NSLog(@"Request: %@", urlStr);
    
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager UploadImage:ProfileVideoImageName Image:videoImage commandURL:urlStr];
    
}

//upload videoImage in contact profile
-(void)uploadVideoImageINContact:(id)theDelegate contactId:(NSString *)contactId ProfileVideoImageName:(NSString *)ProfileVideoImageName videoImage:(UIImage *)videoImage isImageChanged:(NSString *)isImagehanged :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr=[NSString stringWithFormat:@"%@%@contact_id=%@&ProfileVideoImage=%@&isImageChanged=%@",BASE_URL_GLOBAL,sUploadProfileVideoImageContact,contactId,ProfileVideoImageName,isImagehanged];
    NSLog(@"Request: %@", urlStr);
    
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager UploadImage:ProfileVideoImageName Image:videoImage commandURL:urlStr];
}

//Delete photo and video from profile
-(void)deletePhotoAndVideoFromProfile:(id)theDelegate UserId:(NSString *)UserId ProfileTypeId:(NSString *)ProfileTypeId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@UserId=%@&typeId=%@",BASE_URL_GLOBAL,sDeleteVideoAndImageProfile,UserId,ProfileTypeId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//Delete photo and video from contact profile
-(void)deletePhotoAndVideoFromProfile:(id)theDelegate contactId:(NSString *)contactId :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    NSString *urlStr=[NSString stringWithFormat:@"%@%@contact_id=%@",BASE_URL_GLOBAL,sDeletePictureVideoContact,contactId];
    NSLog(@"Request: %@", urlStr);
   // urlStr=[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager=[[ConnectionManager alloc] initWithTarget:self  selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//For Search Profile
-(void)SearchUser:(id)theDelegate firstname:(NSString *)firstname lastname:(NSString *)lastname Company:(NSString *)Company Title:(NSString *)Title State:(NSString *)State city:(NSString *)city IsProfileType:(NSString *)IsProfileType :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@firstname=%@&lastname=%@&Company=%@&Title=%@&State=%@&city=%@&IsProfileType=%@",BASE_URL_GLOBAL,sSearchUser,firstname,lastname,Company,Title,State,city,IsProfileType];
    NSLog(@"Request: %@", urlStr);
   // urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager = [[ConnectionManager alloc] initWithTarget:self selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

//For CheckLoginUser
-(void)ChkLoginDevice :(id)theDelegate UsetID:(int)UsetID :(SEL) function
{
    aDelegate = theDelegate;
    selector = function;
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@UsetID=%d",BASE_URL_GLOBAL,sCheckUserLogin,UsetID];
    NSLog(@"Request: %@", urlStr);
    //urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    if (objConnectionManager!=nil)
    {
        objConnectionManager=nil;
    }
    objConnectionManager = [[ConnectionManager alloc] initWithTarget:self selector:@selector(getResponseFinished:)];
    [objConnectionManager getWebData:self commandURL:urlStr];
}

#pragma mark == Selector Methods
- (void)getResponseFinished:(NSDictionary *)responseDict
{
    objConnectionManager = nil;
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(receivedResponseData:)]];
    [invocation setSelector:selector];
    [invocation setTarget: aDelegate];
    [invocation setArgument:&responseDict atIndex:2];
    [invocation invoke];
}

- (void)receivedResponseData:(NSDictionary *)responseDict
{
    
}
- (NSMethodSignature *) getMethodSignature
{
    SEL mySelector;
    mySelector = @selector(webOperationEnded:);
    NSMethodSignature * sig = nil;
    sig = [[self class] instanceMethodSignatureForSelector:mySelector];
    return sig;
}

@end

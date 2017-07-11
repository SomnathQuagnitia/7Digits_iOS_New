//
//  ServerIntegration.h
//  WSTest
//
//  Created by Vijay on 17/09/13.
//  Copyright (c) 2013 Vijay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionManager.h"
#import "Constant.h"

@interface ServerIntegration : NSObject <NSURLConnectionDelegate>
    {
        id aDelegate;
        SEL selector;
        ConnectionManager *objConnectionManager;
    }
    


-(void)RegistrationWebService:(id)theDelegate UserName:(NSString *)UserName Password:(NSString *)Password ConfirmPassword:(NSString *)ConfirmPassword Email:(NSString *)Email  DeviceId:(NSString *)DeviceId RegisterFrom:(int)RegisterFrom :(SEL) function;  //for Registration
    
-(void)LoginWebService:(id)theDelegate UserName:(NSString *)UserName Password:(NSString *)Password DeviceId:(NSString *)DeviceId IsBackground:(NSString *)IsBackground :(SEL) function;//for Login
    
-(void)ForgotUserNameWebService:(id)theDelegate Email:(NSString *)Email :(SEL) function;//for ForgotUserName
    
-(void)ForgotPasswordWebService:(id)theDelegate UserName:(NSString *)UserName Email:(NSString *)Email :(SEL) function;//for ForgotPassword
    
-(void)ChangePasswordWebService:(id)theDelegate UserId:(NSString *)UserId Password:(NSString *)Password NewPassword:(NSString *)NewPassword ConfirmPassword:(NSString *)ConfirmPassword  :(SEL) function;//for ChangePassword
    

-(void)GetStateList:(id)theDelegate q:(NSString *)q :(SEL) function; //for Get State
    
-(void)GetCityListWebService:(id)theDelegate StateId:(NSString *)StateId q:(NSString *)q :(SEL) function;//City list
    
-(void)GetZipListWebService:(id)theDelegate  CityId:(NSString *)CityId :(SEL) function;//Zip list
    
-(void)GetContactListWebService:(id)theDelegate UserId:(NSString *)UserId :(SEL) function;//Contact list
    


-(void)AddContactWebService:(id)theDelegate UserId:(NSString *)UserId ContactId:(NSString *)ContactId UserName:(NSString *)UserName FirstName:(NSString *)FirstName LastName:(NSString *)LastName  Message:(NSString *)Message ImageName:(NSString *)ImageName Image:(UIImage *)Image PhoneNumber:(NSString *)PhoneNumber emailId:(NSString *)emailId userNotes:(NSString *)userNotes userCompany:(NSString *)userCompany userTitle:(NSString *)userTitle userAddress:(NSString *)userAddress profileId:(NSString *)profileId MobileNumber:(NSString *)MobileNumber WorkNumber:(NSString *)WorkNumber isImageChanged:(NSString *)isImageChanged state:(NSString *)state city:(NSString *)city location:(NSString *)location IsPublic:(int)IsPublic Occupation:(NSString *)Occupation profileType:(NSString*)profileType :(SEL) function;


-(void)ContactProfileWebService:(id)theDelegate ContactId:(NSString *)ContactId :(SEL) function;//for ContactProfile
    
-(void)CheckUserExistWebService:(id)theDelegate UserId:(NSString *)UserId UserName:(NSString *)UserName :(SEL) function;//for CheckUserExist
    


-(void)PostMessage :(id)theDelegate UserId:(NSString *)UserId StateId:(NSString *)StateId CityId:(NSString *)CityId ZipCodeId:(NSString *)ZipCodeId Title:(NSString *)Title  Age:(NSString *)Age M2M:(NSString *)M2M  M2W:(NSString *)M2W  W2W:(NSString *)W2W W2M:(NSString *)W2M Everyone:(NSString *)Everyone LessThan30Days:(NSString *)LessThan30Days MessageHTML:(NSString *)MessageHTML Message:(NSString *)Message IsDraft:(NSString *)IsDraft PostMessageId:(NSString *)PostMessageId ImageName:(NSString *)ImageName Image:(UIImage *)Image :(SEL) function; //posted Message

-(void)LogoutWebService:(id)theDelegate UserId:(NSString *)UserId IsBackground:(NSString *)IsBackground :(SEL) function;//for Logout


-(void)PostingMessageListWebService:(id)theDelegate UserId:(NSString *)UserId  :(SEL) function;//for PostingMessageList
    
-(void)GetDraftMessageListWebService:(id)theDelegate UserId:(NSString *)UserId  :(SEL) function;//for GetDraftMessageList
    
-(void)ContactUsWebService:(id)theDelegate Name:(NSString *)Name Email:(NSString *)Email PhoneNumber:(NSString *)PhoneNumber Message:(NSString *)Message :(SEL) function;//for ContactUs
    
-(void)GetZipCodeListByState:(id)theDelegate StateId:(NSString *)StateId CityId:(NSString *)CityId Zip:(NSString *)Zip :(SEL) function;//for GetZipCodeListByState
    
-(void)PostedMessageList :(id)theDelegate UserId:(NSString *)UserId KeyWord:(NSString *)KeyWord StateId:(NSString *)StateId CityId:(NSString *)CityId ZipCodeId:(NSString *)ZipCodeId M2M:(NSString *)M2M  M2W:(NSString *)M2W  W2W:(NSString *)W2W W2M:(NSString *)W2M Everyone:(NSString *)Everyone LessThan30Days:(NSString *)LessThan30Days :(SEL) function; //posted Message List
    
-(void)SearchPostedMessage :(id)theDelegate UserId:(NSString *)UserId KeyWord:(NSString *)KeyWord :(SEL) function; //Search posted Message List
    
-(void)PostedMessageDetail:(id)theDelegate UserId:(NSString *)UserId MessageId:(NSString *)MessageId :(SEL) function;//postedMessageDetail
    
-(void)ReplyMessage:(id)theDelegate MessageId:(NSString *)MessageId FromUser:(NSString *)FromUser ToUser:(NSString *)ToUser SendCopy:(NSString *)SendCopy Reply:(NSString *)Reply  PlainMessage:(NSString *)PlainMessage FromInbox:(NSString *)FromInbox  AttachmentName:(NSString *)AttachmentName Attachment:(UIImage *)Attachment :(SEL) function; //Reply Messages
    
-(void)InboxMessagesList:(id)theDelegate UserId:(NSString *)UserId :(SEL) function; //Inbox Message List
    
-(void)DeletePostingMessage:(id)theDelegate MessageId:(NSString *)MessageId :(SEL) function; //DeletePostingMessage
    
-(void)DeleteInboxMessage:(id)theDelegate ReplyMessageId:(NSString *)ReplyMessageId UserId:(NSString *)UserId ProfileIds:(NSString *)ProfileIds :(SEL) function;


//DeleteInboxMessage
    
-(void)DeleteContact:(id)theDelegate ContactId:(NSString *)ContactId :(SEL) function; //DeleteContact
    
-(void)AddContactFromPostMessageList:(id)theDelegate UserId:(NSString *)UserId ContactId:(NSString *)ContactId :(SEL) function; //for AddContactFromPostMessageList
    
-(void)RepostMessage:(id)theDelegate  MessageId:(NSString *)MessageId :(SEL) function; //for RepostMessage

-(void)InboxDetailsList:(id)theDelegate UserId:(NSString *)UserId MessageId:(NSString *)MessageId PostedById:(NSString *)PostedById FromInbox:(NSString *)FromInbox :(SEL) function;//for InboxDetailsList

-(void)InsertChatMessage:(id)theDelegate FromUser:(NSString *)FromUser ToUser:(NSString *)ToUser ChatMessage:(NSString *)ChatMessage Type:(NSString *)Type data:(UIImage *)data fileName:(NSString *)fileName videoData:(NSData *)videoData :(SEL) function;//for InsertChatMessage

-(void)GetChatHistory:(id)theDelegate userId:(NSString *)userId  :(SEL) function;//for GetChatHistory

-(void)GetOfflineChat:(id)theDelegate userId:(NSString *)userId ContactId:(NSString *)ContactId  :(SEL) function;//for GetOfflineChat
-(void)GetContactsBadge:(id)theDelegate userId:(NSString *)userId :(SEL) function;//for GetContactsBadge

-(void)CheckBackgroundStatus:(id)theDelegate userId:(NSString *)userId DeviceID:(NSString *)DeviceID IsBackground:(NSString *)IsBackground :(SEL) function;//for CheckBackgroundStatus

#pragma mark == Profile W.S
//for GetLogInUserProfile
-(void)GetLogInUserProfile:(id)theDelegate userId:(NSString *)userId profileTypeId:(NSString *)profileTypeId :(SEL) function;

//for UpdateLogInUserProfile
-(void)UpdateLogInUserProfile:(id)theDelegate UserName:(NSString *)UserName FirstName:(NSString *)FirstName LastName:(NSString *)LastName EmailId:(NSString *)EmailId PhoneNumber:(NSString *)PhoneNumber  UserNotes:(NSString *)UserNotes UserTitle:(NSString *)UserTitle UserCompany:(NSString *)UserCompany UserAddress:(NSString *)UserAddress ProfileImageName:(NSString *)ProfileImageName Image:(UIImage *)Image ProfileTypeId:(NSString *)ProfileTypeId UserId:(NSString *)UserId MobileNumber:(NSString *)MobileNumber WorkNumber:(NSString *)WorkNumber isImageChanged:(NSString *)isImageChanged state:(NSString *)state city:(NSString *)city location:(NSString *)location IsPublic:(int)IsPublic Occupation:(NSString *)Occupation :(SEL) function;

//for Ignore Profile
-(void)IgnoreUserProfile:(id)theDelegate profileId:(NSString *)profileId :(SEL) function;

//for Send Profile
-(void)SendUserProfile:(id)theDelegate userId:(NSString *)userId reciverUserId:(NSString *)reciverUserId profileId:(NSString *)profileId Message:(NSString *)Message isRequest:(NSString*)isRequest :(SEL) function;

//for CheckProfileUserExist
-(void)CheckProfileUserExist:(id)theDelegate UserName:(NSString *)UserName :(SEL) function;

//For view Inbox Other User Profile
-(void)ViewInboxOtherUserProfile:(id)theDelegate profileId:(NSString *)profileId :(SEL) function;

//for Accept Profile
-(void)AcceptUserProfile:(id)theDelegate userId:(NSString *)userId isOverrride:(NSString *)isOverrride profileId:(NSString *)profileId :(SEL) function;

//for CheckContactAddedForAcceptProfile
-(void)CheckContactAddedForAcceptProfile:(id)theDelegate userId:(NSString *)userId profileId:(NSString *)profileId :(SEL) function;

//for ViewContact
-(void)ViewContact:(id)theDelegate contactId:(NSString *)contactId :(SEL) function;

-(void)uploadVideoImage:(id)theDelegate UserId:(NSString *)UserId ProfileTypeId:(NSString *)ProfileTypeId ProfileVideoImageName:(NSString *)ProfileVideoImageName videoImage:(UIImage *)videoImage isImageChanged:(NSString *)isImagehanged :(SEL) function;

-(void)deletePhotoAndVideoFromProfile:(id)theDelegate UserId:(NSString *)UserId ProfileTypeId:(NSString *)ProfileTypeId :(SEL) function;
-(void)uploadVideoImageINContact:(id)theDelegate contactId:(NSString *)contactId ProfileVideoImageName:(NSString *)ProfileVideoImageName videoImage:(UIImage *)videoImage isImageChanged:(NSString *)isImagehanged :(SEL) function;

-(void)deletePhotoAndVideoFromProfile:(id)theDelegate contactId:(NSString *)contactId :(SEL) function;

-(void)SearchUser:(id)theDelegate firstname:(NSString *)firstname lastname:(NSString *)lastname Company:(NSString *)Company Title:(NSString *)Title State:(NSString *)State city:(NSString *)city IsProfileType:(NSString *)IsProfileType :(SEL) function;

//For Search Profile View
-(void)SearchViewProfile:(id)theDelegate UserProfileID:(int )UserProfileID :(SEL) function;

//For ExitsContact
-(void)IsContactAvailable:(id)theDelegate UserId:(NSString *)UserId Profileid:(int)Profileid :(SEL) function;

//For UserLoginCheck
-(void)ChkLoginDevice:(id)theDelegate UsetID:(int)UsetID :(SEL) function;
@end

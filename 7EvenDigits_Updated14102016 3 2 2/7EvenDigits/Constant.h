
@class ChatMeassageVC;

//Bundle Identifier       :   com.7evendigits.7EvenDigits     //vesna

#define IS_IOS7 [[UIDevice currentDevice].systemVersion floatValue] >= 7.0
#define IS_HEIGHT_GTE_568 [[UIScreen mainScreen ] bounds].size.height >= 568.0f
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IPHONE [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPhone_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)

#define kAlertTitle @""

//#define BASE_URL_GLOBAL @"http://115.113.151.198/SocialMedia/Api/"         //Staging server
//#define BASE_URL_GLOBAL @"http://115.113.151.198/sevendigitinternal/api/"  //Staging server for multiple reply
#define BASE_URL_GLOBAL @"http://www.7evendigits.com/api/"                 //Live Server URL
//#define BASE_URL_GLOBAL @"http://115.113.151.199:8007/api/"                 //New Update URl 17/01/2017

//#define BASE_URL_GLOBAL @"http://192.168.0.16:8007/api/"                     //New Updated URL
//#define BASE_URL_GLOBAL @"http://162.144.141.77:808/api/"                    //host getar server url
//#define BASE_URL_GLOBAL @"192.168.0.93/SocialMedia/api/"                       //Local Production
//#define BASE_URL_GLOBAL @"192.168.0.74:8788/api/"                               //profile
//#define BASE_URL_GLOBAL @"http://115.113.151.198:8180/Api/"
//#define BASE_URL_GLOBAL @"http://dotnetdemo2.quagnitia.com:8009/api/"   //Staging
//#define BASE_URL_GLOBAL @"http://dotnetdemo2.quagnitia.com:8008/api/"


//Account URL's
#define sLogin @"iOSAccount/Login?"
#define sLogout @"iOSAccount/Logout?"
#define sRegistration @"iOSAccount/SignUp?"
#define sContactUs @"iOSAccount/ContactUs?"
#define sForgotUserName @"iOSAccount/ForgotUsername?"
#define sForgotPassword @"iOSAccount/ForgotPassword?"
#define sChangePassword @"iOSAccount/ChangePassword?"
#define sCheckUserLogin @"iOSChatting/ChkLoginDevice?"

//Chat URL's
#define sChat @"iOSChatting/InsertChatMessage?"
#define sGetChatHistory @"iOSChatting/GetChatHistory?"
#define sGetOfflineChat @"iOSChatting/GetOfflineChat?"
#define sGetContactsBadge @"iOSChatting/GetContactsBadge?"

//Contact URL's
#define sAddContact @"iOSContact/AddContact?"
#define sGetContactList @"iOSContact/GetContactList?"
#define sCheckUserExist @"iOSContact/CheckUserExist?"
#define sContactProfile @"iOSContact/ContactProfile?"
#define sDeleteContact @"iOSContact/DeleteContact?"
#define sAddContactFromPostMessageList @"iOSContact/AddContactFromPostMessageList?"

//Master URL's
#define sGetStateList @"iOSMaster/GetStateList?"
#define sGetCityList @"iOSMaster/GetCityList?"
#define sGetZipCodeList @"iOSMaster/GetZipCodeList?"
#define sGetZipCodeListByState @"iOSMaster/GetZipCodeListByState?"

//Messages URL's
#define sInboxMessages @"iOSMessage/InboxMessages?"
#define sUploadImage @"iOSMessage/post"
#define sPostMessage @"iOSMessage/PostMessage?"
#define sPostedMessageList @"iOSMessage/PostedMessageList?"
#define sInboxMessageList @"iOSMessage/InboxMessageList?"
#define sReplyMessage @"iOSMessage/ReplyMessage?"
#define sSearchPostedMessageList @"iOSMessage/SearchPostedMessage?"
#define sPostMessageList @"iOSMessage/PostMessageList?"
#define sGetDraftMessageList @"iOSMessage/GetDraftMessageList?"
#define sPostedMessageDetail @"iOSMessage/PostedMessageDetail?"
#define sDeletePostingMessage @"iOSMessage/DeletePostingMessage?"
#define sDeleteInboxMessage @"iOSMessage/DeleteInboxMessage?"
#define sRepostMessage @"iOSMessage/RepostMessage?"
#define sInboxDetailsList @"iOSMessage/InboxDetailsList?"

#define sCheckBackgroundStatus @"iOSChatting/CheckBackgroundStatus?"

//Profile URL's
#define sViewLogInUserProfile @"iOSProfile/ViewProfile?"
#define sUpdateLogInUserProfile @"iOSProfile/Update?"
#define sIgnoreUserProfile @"iOSProfile/Ignore"  //dont put ? here for ignor w.s
#define sAcceptUserProfile @"iOSProfile/Accept?"
#define sSendUserProfile @"iOSProfile/SendProfile?"
#define sProfileUserExist @"iOSProfile/checkIsExistUserName?"
#define sViewInboxProfile @"iOSProfile/ViewRequest?"
#define sViewContact @"iOSMessage/ViewContact"  //dont put ? here for ViewContact w.s
#define sViewSearchProfile @"iOSProfile/SearchViewProfile?"

//Check Exit Contact
#define sCheckExitsUserContact @"iOSProfile/IsContactAvailable?"

//upload video file
#define sUploadVideoFile @"iOSProfile/UploadProfileVideo?"

//upload video image
#define sUploadVideoImage @"IOSProfile/UploadProfileVideoImage?"

//delete video & videoimage
#define sDeleteVideoAndImageProfile @"iosprofile/DeletePictureVideo?"


//For contact

#define sUploadProfileVideoImageContact @"iOSContact/UploadProfileVideoImageContact?"
#define sUploadProfileVideoContact @"iOSContact/UploadProfileVideoContact?"
#define sDeletePictureVideoContact @"iOSContact/DeletePictureVideoContact?"

//For Search
#define sSearchUser @"iOSProfile/SearchUser?"



id objRefTool;

NSString *CURRENT_USER_ID;

NSString *CURRENT_USER_NAME;

NSString *CURRENT_USER_IMAGE;

NSString *CURRENT_USER_Video;

//NSString *iOSDeviceToken;

NSString *stringForTitle;



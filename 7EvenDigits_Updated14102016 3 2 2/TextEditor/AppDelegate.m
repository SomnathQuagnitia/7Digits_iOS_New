//
//  AppDelegate.m
//  TextEditor
//
//  Created by NikhilD on 9/29/14.
//  Copyright (c) 2014 Quagnitia Systems. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Constant.h"
#import "ChatMeassageVC.h"
#import "MenuViewController.h"
#import "Reachability.h"
#import "HomeViewController.h"

@implementation AppDelegate
@synthesize obj,userInfoDictionary,menuVcObj;
@synthesize splashViewController,navigationController,internetStatus,loginViewController,chatMessage,chatContVC,iOSDeviceToken;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(checkNetworkStatus:) name: kReachabilityChangedNotification object: nil];
    
    [self checkConnetion];
    
    [self registerforPushNotification];
#if TARGET_IPHONE_SIMULATOR
    iOSDeviceToken = @"ea17ddd2243d9402d3f45058420c767506d98ac6059462ac5ed7c139cfa37bc2";
#endif
    falgForChat = false;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window.backgroundColor = [UIColor whiteColor];
    
    //Check User already login or not
    NSUserDefaults *applicationUserDefault;
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    
    
    NSString *username = [applicationUserDefault valueForKey:@"CURRENT_USER_NAME"];
    NSString *userId = [applicationUserDefault valueForKey:@"CURRENT_USER_ID"];
    NSString *userIMage = [applicationUserDefault valueForKey:@"CURRENT_USER_IMAGE"];
    userIsDirctlyLogging = NO;
    
    if(username != nil) //if username is not blank
    {
        
        //NOTE: - Rechability is called after LOGIN w.s so network falg is aunvalible so we call it in "checkNetworkStatus:" and check that if directly login or not.
        
        
        userIsDirctlyLogging = YES;
        
        
        //set all these data for temporary
        CURRENT_USER_NAME = username;
        CURRENT_USER_ID = userId;
        CURRENT_USER_IMAGE = userIMage;
        
        HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
        navigationController=[[UINavigationController alloc]initWithRootViewController:homeVC];
    }
    else
    {
//        splashViewController=[[SplashViewController alloc]initWithNibName:@"SplashViewController" bundle:[NSBundle mainBundle]];
        loginViewController=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        navigationController=[[UINavigationController alloc]initWithRootViewController:loginViewController];
    }
    
    //Set navigation bar Title color
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
   
    if(IS_IOS7)
    {
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:235.0f/255.0f green:110.0f/255.0f blue:30.0f/255.0f alpha:1 ]];
    }
    
    self.window.rootViewController=navigationController;
    [self.window makeKeyAndVisible];
    
    
//   
    // Set the App ID for your app
    [[Harpy sharedInstance] setAppID:@"992762548"];
   
    [Harpy sharedInstance].delegate = self;
    
    // Set the UIViewController that will present an instance of UIAlertController
    [[Harpy sharedInstance] setPresentingViewController:_window.rootViewController];
    
    
    /* (Optional) Set the Alert Type for your app
     By default, Harpy is configured to use HarpyAlertTypeOption */
    [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
    
    
    // Perform check for new version of your app
    [[Harpy sharedInstance] checkVersion];
   
    
//    Appdate* appdate = [Appdate appdateWithAppleId: 992762548];
//    appdate.delegate = self;
//    
//    #if NS_BLOCKS_AVAILABLE
//    [appdate checkNowWithBlock: ^(NSError* error, NSDictionary* appInfo, BOOL updateAvailable) {
//        if (!error)
//        {
//            NSLog(@"New version Available");
//        }
//    }];
//    #endif
    
    isAcceptAlertShow=YES;
    
    return YES;
}

#pragma harpy Update Alerts

- (void)harpyDidShowUpdateDialog
{
    NSLog(@"Harpy show alert");
}
- (void)harpyUserDidLaunchAppStore
{
     NSLog(@"Harpy launch appstore");
}
- (void)harpyUserDidSkipVersion
{
    NSLog(@"Harpy skip update");
}
- (void)harpyUserDidCancel
{
    NSLog(@"Harpy update cancel");
}


-(void)callLoginWebService
{
    NSUserDefaults *applicationUserDefault;
    
    applicationUserDefault = [NSUserDefaults standardUserDefaults];
    NSString *username = [applicationUserDefault valueForKey:@"CURRENT_USER_NAME"];
    NSString *password = [applicationUserDefault valueForKey:@"CURRENT_USER_PASSWORD"];
    
    if (self.internetStatus==0)
    {
        //  [SVProgressHUD showErrorWithStatus:@"Internet connection not available"];
    }
    else
    {
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        if(iOSDeviceToken.length>0 )
        {
            
            [serviceIntegration LoginWebService:self UserName:username Password:password DeviceId:iOSDeviceToken IsBackground:@"False" :@selector(receivedResponseDataLoginInAppdelgte:)];
        }
        else
        {
            
            [serviceIntegration LoginWebService:self UserName:username Password:password DeviceId:@"" IsBackground:@"False" :@selector(receivedResponseDataLoginInAppdelgte:)];
        }
    }
}

- (void)receivedResponseDataLoginInAppdelgte:(NSDictionary *)responseDict
{
    NSLog(@"%@",responseDict);
    
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        //here we update all the data
        CURRENT_USER_ID = [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"UserId"]];
        
        CURRENT_USER_NAME= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"UserName"]];
        CURRENT_USER_IMAGE= [[NSString alloc] initWithFormat:@"%@",[responseDict valueForKey:@"Image"]];
        
    }
    else
    {
    }
}

//-(void)checkUpdateLocation
//{
//    // NSLocationAlwaysUsageDescription
//    CLLocationManager* locationManager = [[CLLocationManager alloc] init];
//    locationManager.delegate = self;
//    
//    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//        [locationManager requestAlwaysAuthorization];
//    }
//    
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//    [locationManager startUpdatingLocation];
//}



#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"didFailWithError locationManager: %@", error);
    //    UIAlertView *errorAlert = [[UIAlertView alloc]
    //                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //    NSLog(@"didUpdateToLocation: %@", newLocation);
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    //    HomeViewController *homeVC=[[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:[NSBundle mainBundle]];
    //    [homeVC slideViewWithAnimation];
    
    //    UIViewController* viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
    //
    //
    //    if ([viewController isKindOfClass:[BaseViewController class]] )
    //    {
    //        BaseViewController *currentViewObj = (BaseViewController*)viewController;
    //        [currentViewObj.objMenuViewController reArrangeView];
    //    }
    //    else if ([viewController isKindOfClass:[InboxMessageViewController class]] )
    //    {
    //        InboxMessageViewController *currentViewObj = (InboxMessageViewController*)viewController;
    //        [currentViewObj.objMenuViewController reArrangeView];
    //    }
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //Check Applcation State
    
    bgTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler: ^{[[UIApplication sharedApplication] endBackgroundTask:bgTask]; }];
    
    if (self.internetStatus==0)
    {
        //  [SVProgressHUD showErrorWithStatus:@"Internet connection not available"];
        
    }
    else
    {
        //  [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
        
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        
        if(CURRENT_USER_ID != nil)
        {
            if(iOSDeviceToken.length>0 )
            {
                [serviceIntegration CheckBackgroundStatus:self userId:CURRENT_USER_ID DeviceID:iOSDeviceToken IsBackground:@"True" :@selector(receivedResponseBackGroundStatusChk:)];
            }
            else
            {
                [serviceIntegration CheckBackgroundStatus:self userId:CURRENT_USER_ID DeviceID:@"" IsBackground:@"True" :@selector(receivedResponseBackGroundStatusChk:)];
            }
        }
    }
}

- (void)receivedResponseBackGroundStatusChk:(NSDictionary *)responseDict
{
    NSLog(@"%@",responseDict);
}
- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    NetworkStatus netStatus = [internetReachable currentReachabilityStatus];
    
    switch (netStatus)
    {
        case ReachableViaWWAN:
        {
            break;
        }
        case ReachableViaWiFi:
        {
            //[self callChatHistoryWebService];
            UIViewController* viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
            if ([viewController isKindOfClass:[ChatContactsViewController class]])
            {
                chatContVC=(ChatContactsViewController *)viewController;
                [chatContVC CallChatContactListWebService];
            }
            break;
        }
        case NotReachable:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"We are unable to make a internet connection at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            break;
        }
            
    }
    
    //Check Background to foreground
    
    if (self.internetStatus==0)
    {
    }
    else
    {
        
        if (serviceIntegration != nil)
        {
            serviceIntegration = nil;
        }
        serviceIntegration = [[ServerIntegration alloc]init];
        if(CURRENT_USER_ID != nil)
        {
            if(iOSDeviceToken.length>0 )
            {
                [serviceIntegration CheckBackgroundStatus:self userId:CURRENT_USER_ID DeviceID:iOSDeviceToken IsBackground:@"False" :@selector(receivedResponseBackGroundStatusChk:)];
            }
            else
            {
                
                [serviceIntegration CheckBackgroundStatus:self userId:CURRENT_USER_ID DeviceID:@"" IsBackground:@"False" :@selector(receivedResponseBackGroundStatusChk:)];
            }
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Check internet reachability
- (void)checkConnetion
{
    @try
    {
        
        
        internetReachable = [Reachability reachabilityForInternetConnection];
        [internetReachable startNotifier];
        
        // check if a pathway to a random host exists
        hostReachable = [Reachability reachabilityWithHostName: @"www.google.com"];
        [hostReachable startNotifier];
        
    } @catch (NSException *ex)
    {
    }
}


-(void) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    internetStatus = [internetReachable currentReachabilityStatus];
    NSLog(@"InternaetStatus :%ld",(long)internetStatus);
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            break;
        }
    }
    
    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            break;
        }
    }
    
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetworkStatus" object:nil];
    }
    //Rechability is called after login w.s so network falg is aunvalible so we call here and check that if directly login or not.
    if(userIsDirctlyLogging){
        [self callLoginWebService];
    }
}
- (void)receivedResponseDataChatHistory:(NSDictionary *)responseDict
{
    //    NSLog(@"chat history %@",responseDict);
}
- (void)registerforPushNotification
{

    
    if(IS_OS_8_OR_LATER)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"])
    {
        
    }
    else if ([identifier isEqualToString:@"answerAction"])
    {
        
    }
}
#endif

//The application delegate for registering APNS
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    iOSDeviceToken = [[NSString alloc] initWithFormat:@"%@",newToken];
    NSLog(@"iOSDeviceToken %@",iOSDeviceToken);
    
    //[self sendPushRegstraionInfoToserver];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Error in registration. Error: %@", err);
}

-(void)callChatHistoryWebService:(NSString *)chatUserID
{
    if (serviceIntegration != nil)
    {
        serviceIntegration = nil;
    }
    serviceIntegration = [[ServerIntegration alloc]init];
    [serviceIntegration GetOfflineChat:self userId:CURRENT_USER_ID ContactId:chatUserID :@selector(receivedResponseDataChatHis:)];
}

- (void)receivedResponseDataChatHis:(NSArray *)responseDict
{
    if(responseDict.count > 0)
    {
        for (int i=0; i<[responseDict count]; i++)
        {
            NSMutableDictionary *messageDict = [[NSMutableDictionary alloc]init];
            [messageDict setValue:[[responseDict objectAtIndex:i]valueForKey:@"ChatMessage"]  forKey:@"msg"];
            [messageDict setValue:[NSDate date] forKey:@"date"];
            [messageDict setValue:[NSString stringWithFormat:@"%ld",(long)JSBubbleMessageTypeIncoming] forKey:@"msgType"];
            [CommonNotification setMessageDetailsForChatWithUserID:[[responseDict objectAtIndex:0]valueForKey:@"FromUserId"] :messageDict];
        }
    }
}

//The application delegate for receiving APNS
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"userInfo %@",userInfo);
    userInfoDictionary=[[NSMutableDictionary alloc]initWithDictionary:userInfo];
    if([[userInfo valueForKey:@"NotificationType"]isEqualToString:@"InboxMessage"])
    {
        [self checkApplicationState];
    }
    if([[userInfo valueForKey:@"NotificationType"]isEqualToString:@"LoginNotification"])
    {
        [self checkApplicationState];
    }
    else if([[userInfo valueForKey:@"NotificationType"]isEqualToString:@"ChatMessage"])
    {
        mainBundle = [NSBundle mainBundle];
        filePath = [mainBundle pathForResource:@"receivedMessage" ofType:@"mp3"];
        fileData = [NSData dataWithContentsOfFile:filePath];
        
        NSError *error = nil;
        
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData error:&error];
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer pause];
        [self.audioPlayer play];
        
        if ([[NSString stringWithFormat:@"%@",[userInfo valueForKey:@"Added" ]] isEqualToString:@"1"])
        {
            [self checkApplicationState];
        }
        else
        {
            if (isAcceptAlertShow)
            {
                NSString *message=[NSString stringWithFormat:@"%@ wants to chat with you. Do you want to chat?",[userInfo valueForKey:@"FromUserName"]];
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                alert.tag = 44;
                [alert show];
                isAcceptAlertShow=NO;
            }
            else
            {
                //isAcceptAlertShow=NO;
            }
        }
    }
    

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 44){
    if(buttonIndex==0)
    {
        if (self.internetStatus==0)
        {
            //[SVProgressHUD showErrorWithStatus:@"Internet connection not available"];
        }
        else
        {
            if (serviceIntegration != nil)
            {
                serviceIntegration = nil;
            }
            
            serviceIntegration = [[ServerIntegration alloc]init];
            
            [serviceIntegration AddContactFromPostMessageList:self UserId:CURRENT_USER_ID ContactId:[userInfoDictionary valueForKey:@"SenderUserId"] :@selector(receivedResponseAddContactForChat:)];
            
            isAcceptAlertShow=YES;
        }
    }
    else
    {
        isAcceptAlertShow=YES;
    }
    }
}

- (void)receivedResponseAddContactForChat:(NSDictionary *)responseDict
{
    //NSLog(@"%@",responseDict);
    if ([[responseDict valueForKey:@"success" ]isEqualToString:@"true"])
    {
        falgForChat = YES;
        [self checkApplicationState];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:[responseDict valueForKey:@"Message"] maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)checkApplicationState
{
    UIApplication*application;
    if(application.applicationState == UIApplicationStateActive)
    {
        UIViewController* viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
        
        
        if([[userInfoDictionary valueForKey:@"NotificationType"]isEqualToString:@"InboxMessage"])
        {
            if ([viewController isKindOfClass:[HomeViewController class]] )
            {
                if (((BaseViewController *)viewController).objMenuViewController.isMenuOpen) {
                    [((BaseViewController *)viewController).objMenuViewController fillInboxMessageData];
                }
            }
        }
        if([[userInfoDictionary valueForKey:@"NotificationType"]isEqualToString:@"LoginNotification"])
        {
            if ([viewController isKindOfClass:[ChatContactsViewController class]])
            {
                chatContVC=(ChatContactsViewController *)viewController;
                [chatContVC CallChatContactListWebService];
            }
        }
        else if([[userInfoDictionary valueForKey:@"NotificationType"]isEqualToString:@"ChatMessage"])
        {
            if (falgForChat)
            {
                falgForChat = false;
                id parent=self;
                chatMessage=[[ChatMeassageVC alloc]initWithNibName:@"ChatMeassageVC" bundle:[NSBundle mainBundle]];
                chatMessage.chatUserID=[NSString stringWithFormat:@"%@",[userInfoDictionary valueForKey:@"SenderUserId"]];
                chatMessage.titleName=[userInfoDictionary valueForKey:@"FromUserName"];
                //                NSURL *url = [NSURL URLWithString:[[userInfoDictionary valueForKey:@"SenderImage"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                //                NSData *data = [NSData dataWithContentsOfURL:url];
                //                chatMessage.chatUserImageData = data;
                
                if ([viewController isKindOfClass:[HomeViewController class]])
                {
                    BaseViewController *currentViewObj = ((BaseViewController *)viewController);
                    //[currentViewObj.objMenuViewController tableView:currentViewObj.objMenuViewController.tableViewObj didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
                    [Parameters pushFromView:parent toView:chatMessage withTransition:UIViewAnimationTransitionNone];
                    [currentViewObj.objMenuViewController reArrangeView];
                }
                else
                {
                    [Parameters pushFromView:parent toView:chatMessage withTransition:UIViewAnimationTransitionNone];
                }
            }
            if ([viewController isKindOfClass:[ChatMeassageVC class]] )
            {
                chatMessage = (ChatMeassageVC*)viewController;
                if([chatMessage.titleName isEqualToString:[userInfoDictionary valueForKey:@"FromUserName"]])
                {
                    chatMessage.chatUserID=[NSString stringWithFormat:@"%@",[userInfoDictionary valueForKey:@"SenderUserId"]];
                    chatMessage.titleName=[userInfoDictionary valueForKey:@"FromUserName"];
                    [chatMessage callChatHistoryWebService];
                }
            }
            if ([viewController isKindOfClass:[HomeViewController class]] )
            {
                if (((BaseViewController *)viewController).objMenuViewController.isMenuOpen) {
                    [((BaseViewController *)viewController).objMenuViewController callChatBoxCountWebService];
                }
            }
            if ([viewController isKindOfClass:[ChatContactsViewController class]])
            {
                chatContVC=(ChatContactsViewController *)viewController;
                [chatContVC CallChatContactListWebService];
            }
        }
    }
    else if(application.applicationState == UIApplicationStateBackground || application.applicationState == UIApplicationStateInactive)
    {
        if([[userInfoDictionary valueForKey:@"NotificationType"]isEqualToString:@"InboxMessage"])
        {
        }
        else if([[userInfoDictionary valueForKey:@"NotificationType"]isEqualToString:@"ChatMessage"])
        {
            UIViewController* viewController = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count - 1];
            
            if ([viewController isKindOfClass:[BaseViewController class]] )
            {
                BaseViewController *currentViewObj = (BaseViewController*)viewController;
                [currentViewObj.objMenuViewController tableView:currentViewObj.objMenuViewController.tableViewObj didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
                [currentViewObj.objMenuViewController reArrangeView];
            }
            else if ([viewController isKindOfClass:[InboxMessageViewController class]] )
            {
                InboxMessageViewController *currentViewObj = (InboxMessageViewController*)viewController;
                [currentViewObj.objMenuViewController tableView:currentViewObj.objMenuViewController.tableViewObj didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
                [currentViewObj.objMenuViewController reArrangeView];
            }
            id parent=self;
            //[Parameters playReceivedAudio];
            chatMessage=[[ChatMeassageVC alloc]initWithNibName:@"ChatMeassageVC" bundle:[NSBundle mainBundle]];
            chatMessage.chatUserID=[NSString stringWithFormat:@"%@",[userInfoDictionary valueForKey:@"SenderUserId"]];
            chatMessage.titleName=[userInfoDictionary valueForKey:@"FromUserName"];
            //            NSURL *url = [NSURL URLWithString:[[userInfoDictionary valueForKey:@"SenderImage"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            //            NSData *data = [NSData dataWithContentsOfURL:url];
            //            chatMessage.chatUserImageData = data;
        
            [Parameters pushFromView:parent toView:chatMessage withTransition:UIViewAnimationTransitionNone];
        }
    }
}

-(void)handleNotification:(NSDictionary *)userInfo
{
    
}
@end

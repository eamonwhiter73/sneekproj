//
//  AppDelegate.m
//  sneek
//
//  Created by Eamon White on 11/25/15.
//  Copyright © 2015 Eamon White. All rights reserved.
//

#import "AppDelegate.h"
#import "SignUpController.h"
#import "ViewController.h"
@import GoogleMaps;
#import <Parse/Parse.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    
    NSLog(@"Userinfo %@",notification.request.content.userInfo);
    
    completionHandler(UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler{
    
    NSLog(@"Userinfo %@",response.notification.request.content.userInfo);
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"MDgESuvjvz1K7l302i90N40A0EZDbwSKzb8k3QzL"
                  clientKey:@"pC3lhDsBTukDfJO8uR2hS9ZFZGpgQIIOjj05dP4A"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate = self;
    
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        NSLog(@"%@", [settings description]);
        NSLog(@"************");
        NSLog(@"%ld", (long)[settings authorizationStatus]);
        
        if([settings authorizationStatus] == UNAuthorizationStatusNotDetermined) {
            [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
                if( !error ){
                    NSLog(@"in unuser***************");
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                }
                else {
                    NSLog(@"%@", [error description]);
                }
            }];
        }
        else {
            //
        }
    }];

    
    
    // ...
    
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyA9gyzAzIjHmwfoLc_V2FCXaeS-SMjclCA"];
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"app launching");
    
    _locationMgr = [[CLLocationManager alloc] init];
    [_locationMgr setDelegate:self];
    
    if([_locationMgr respondsToSelector:@selector(setAllowsBackgroundLocationUpdates:)])
        [_locationMgr setAllowsBackgroundLocationUpdates:YES];
    
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    NSLog(@"launching with no authorization to always use location - requesting authorization");
    if([_locationMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_locationMgr requestAlwaysAuthorization];
    }

    if([launchOptions valueForKey:UIApplicationLaunchOptionsLocationKey] != nil) {
        NSLog(@"relaunching because of significant location change - restarting SLC");
        [_locationMgr startMonitoringSignificantLocationChanges];
    }
    else if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"launching with authorization to always use location - starting SLC");
        [_locationMgr startMonitoringSignificantLocationChanges];
    }
    else {
        //
    }
    
    if([userdefaults objectForKey:@"pfuser"] == nil) {
        NSLog(@"in delegate signup");
        SignUpController *signup = [[SignUpController alloc] init];
        [self.window setRootViewController:signup];
    }
    else {
        ViewController *map = [[ViewController alloc] init];
        [self.window setRootViewController:map];
    }
    [self.window makeKeyAndVisible];

    return YES;
}

- (void)startSignificantChangeUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (nil == _locationMgr) {
        _locationMgr = [[CLLocationManager alloc] init];
        _locationMgr.delegate = self;
    }
    
    [CLLocationManager significantLocationChangeMonitoringAvailable];
    
    [_locationMgr startMonitoringSignificantLocationChanges];
    
    NSLog(@"startsignificantchangeup*********");
}

-(void)locationManger:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
      didUpdateLocations:(NSArray *)locations {
    
    NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
    
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        
        // User's location
        PFGeoPoint *userGeoPoint = [PFGeoPoint geoPointWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
        // Create a query for places
        PFQuery *querygeo = [PFQuery queryWithClassName:@"MapPoints"];
        // Interested in locations near user.
        [querygeo whereKey:@"location" nearGeoPoint:userGeoPoint withinMiles:0.155343];
        // Limit what could be a lot of points.
        querygeo.limit = 10;
        // Final list of objects
        
        [querygeo findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            
            if (!objects || !objects.count){
                //
            }
            else {
                PFQuery *sosQuery = [PFUser query];
                [sosQuery whereKey:@"username" equalTo:[userdefaults objectForKey:@"pfuser"]];
                sosQuery.limit = 1;
                
                [sosQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
                    [PFCloud callFunctionInBackground:@"sendpushnear"
                                       withParameters:@{@"user":(PFUser *)object.objectId, @"username":[userdefaults objectForKey:@"pfuser"]}];
                }];
            }
        }];
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    NSLog(@"didregisterfor***********");
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveEventually];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.eamon.sneek" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"sneek" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"sneek.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

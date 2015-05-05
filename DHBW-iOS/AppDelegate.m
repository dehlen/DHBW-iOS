//
//  AppDelegate.m
//  DHBW-iOS
//
//  Created by David Ehlen on 17.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "AppDelegate.h"
#import "RTWalkthroughViewController.h"
#import "RTWalkthroughPageViewController.h"
#import "RTLoginPageViewController.h"
#import "RTRaplaPageViewController.h"
@interface AppDelegate ()<RTWalkthroughViewControllerDelegate>

@end

@implementation AppDelegate


#define API_ENDPOINT_HOST @"https://hadleyjack.de"

NSString *const kAPIEndpointHost = API_ENDPOINT_HOST;
NSString *const kAPIEndpointAllContacts = (API_ENDPOINT_HOST @"/dhbw-api/contact");
NSString *const kAPIEndpointCafeteriaToday = (API_ENDPOINT_HOST @"/dhbw-api/cafeteria/next");
NSString *const kAPIEndpointNextTrains = (API_ENDPOINT_HOST @"/dhbw-api/transportation/next");
NSString *const kAPIEndpointDHBWNews = (API_ENDPOINT_HOST @"/dhbw-api/dhbw-news");
NSString *const kAPIEndpointStuvNews = (API_ENDPOINT_HOST @"/dhbw-api/stuv-news");
NSString *const kAPIEndpointCafeteriaDay = (API_ENDPOINT_HOST @"/dhbw-api/cafeteria/day/");


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for custo^mization after application launch
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults registerDefaults:@{@"firstStart": @YES}];
    [standardDefaults synchronize];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Walkthrough" bundle:[NSBundle mainBundle]];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults boolForKey:@"firstStart"]) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        RTWalkthroughViewController *walkthrough = [storyboard instantiateViewControllerWithIdentifier:@"walk"];
        
        RTWalkthroughPageViewController *pageOne = [storyboard instantiateViewControllerWithIdentifier:@"walk1"];
        RTLoginPageViewController *pageTwo = [storyboard instantiateViewControllerWithIdentifier:@"walk2"];
        RTRaplaPageViewController *pageThree = [storyboard instantiateViewControllerWithIdentifier:@"walk3"];
        
         RTWalkthroughPageViewController *pageFour = [storyboard instantiateViewControllerWithIdentifier:@"walk4"];
        
        RTWalkthroughPageViewController *pageFive = [storyboard instantiateViewControllerWithIdentifier:@"walk5"];
        
        walkthrough.delegate = self;
        [walkthrough addViewController:pageOne];
        [walkthrough addViewController:pageTwo];
        [walkthrough addViewController:pageThree];
        [walkthrough addViewController:pageFour];
        [walkthrough addViewController:pageFive];

        
        self.window.rootViewController = walkthrough;
        [userDefaults setBool:NO forKey:@"firstStart"];
        [userDefaults synchronize];
        [self.window makeKeyAndVisible];

    }

    
    return YES;
}

- (void)walkthroughControllerDidClose:(RTWalkthroughViewController *)controller {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationControllerObj = [storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    
    self.window.rootViewController = navigationControllerObj;
    [self.window makeKeyAndVisible];

    

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
}

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSInteger NumberOfCallsToSetVisible = 0;
    if (setVisible)
        NumberOfCallsToSetVisible++;
    else
        NumberOfCallsToSetVisible--;
    
    // The assertion helps to find programmer errors in activity indicator management.
    // Since a negative NumberOfCallsToSetVisible is not a fatal error,
    // it should probably be removed from production code.
    NSAssert(NumberOfCallsToSetVisible >= 0, @"Network Activity Indicator was asked to hide more often than shown");
    
    // Display the indicator as long as our static counter is > 0.
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(NumberOfCallsToSetVisible > 0)];
}

@end

//
//  AppDelegate.h
//  DHBW-iOS
//
//  Created by David Ehlen on 17.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

extern NSString *const kAPIEndpointHost;
extern NSString *const kAPIEndpointCafeteriaToday;
extern NSString *const kAPIEndpointNextTrains;
extern NSString *const kAPIEndpointDHBWNews;
extern NSString *const kAPIEndpointStuvNews;
extern NSString *const kAPIEndpointAllContacts;
extern NSString *const kAPIEndpointCafeteriaDay;

- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible;

@end


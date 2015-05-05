//
//  DEJSONParser.m
//  DHBW-iOS
//
//  Created by David Ehlen on 19.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "DEJSONParser.h"
#import "TrainModel.h"
#import "FoodModel.h"
#import "StuvNewsModel.h"
#import "DHBWNewsModel.h"
#import "DEContactModel.h"
#import "UIColor+Expanded.h"
#import "AppDelegate.h"
#import <SIAlertView/SIAlertView.h>

@implementation DEJSONParser

- (void)modelsFromURL:(NSURL*)url forClass:(Class)modelClass withCompletion:(void (^)(NSMutableArray *)) callbackBlock {
     NSMutableArray *models = [[NSMutableArray alloc]init];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];

    NSURLRequest *request=[NSURLRequest requestWithURL:url
                        cachePolicy:NSURLRequestUseProtocolCachePolicy
                    timeoutInterval:30.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     
     {
         if(error) {
            	NSLog(@"%@",error);
             if(modelClass == [DHBWNewsModel class]) { //letzer aufruf für heute ansicht
                 [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ErrorLoading"
             object:self];
             }
             callbackBlock(models);
               [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
         }
         
         else {
             NSError *parserError = nil;
             NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parserError];
             
             if(parserError) {
                 NSLog(@"%@",parserError);
                 SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Konsistenzfehler" andMessage:@"Die zurückgelieferten Daten waren inkorrekt."];
                 [alertView addButtonWithTitle:@"OK"
                                          type:SIAlertViewButtonTypeDefault
                                       handler:^(SIAlertView *alert) {
                                       }];
                 alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
                 
                 [alertView show];
                 callbackBlock(models);
                 if(modelClass == [DHBWNewsModel class]) { //letzer aufruf für heute ansicht
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"ErrorLoading"
                      object:self];
                 }
                   [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];

             }
             for(NSDictionary *dict in jsonDict) {
                 id jsonModelClass = [[modelClass alloc] initWithJSONDict:dict];
                 [models addObject:jsonModelClass];
                 
             }
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];

             if(modelClass == [DHBWNewsModel class]) { //letzer aufruf für heute ansicht
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"SuccessLoading"
                  object:self];
             }
             callbackBlock(models);
         }

     }];
    
}

@end

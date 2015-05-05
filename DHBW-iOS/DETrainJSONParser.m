//
//  DETrainJSONParser.m
//  DHBW-iOS
//
//  Created by David Ehlen on 13.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DETrainJSONParser.h"
#import "AppDelegate.h"
#import <SIAlertView/SIAlertView.h>
#import "DETrainDetailModel.h"
#import "DESectionModel.h"
#import "DEStationModel.h"

@implementation DETrainJSONParser



- (void)possibleStationsForText:(NSString*)station withCompletion:(void (^)(NSMutableArray *))callbackBlock{
    NSMutableArray *models = [NSMutableArray new];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
    NSString *url = [NSString stringWithFormat:@"http://s533994975.online.de/kvvapi/possibleStations.php?station=%@",station];
      NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:30.0];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     
     {
         if(error) {
            	NSLog(@"%@",error);
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
                 [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
                 
             }
             for(NSDictionary *dict in jsonDict) {
                 [models addObject:[dict objectForKey:@"name"]];
                 
             }
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
             
             callbackBlock(models);
         }
         
     }];
}

- (void)modelsFrom:(NSString *)from to:(NSString *)to time:(NSString *)time withCompletion:(void (^)(NSMutableArray *))callbackBlock {
    NSMutableArray *models = [NSMutableArray new];
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
    NSString *url = [NSString stringWithFormat:@"http://s533994975.online.de/kvvapi/routeInformation.php?fromStation=%@&toStation=%@&time=%@",from,to,time];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:30.0];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     
     {
         if(error) {
            	NSLog(@"%@",error);
             callbackBlock(models);
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
         }
         
         else {
             NSError *parserError = nil;
             NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parserError];
             
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
                 [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
                 
             }
             for(NSDictionary *dict in jsonArray) {
                 DETrainDetailModel *trainModel = [DETrainDetailModel new];
                 trainModel.tripName = [dict objectForKey:@"tripName"];
                 trainModel.from = from;
                 trainModel.to = to;
                 trainModel.interval = [dict objectForKey:@"interval"];
                 trainModel.with = [dict objectForKey:@"with"];
                 trainModel.duration = [dict objectForKey:@"duration"];
                 trainModel.changes = [dict objectForKey:@"changes"];
                 for(NSDictionary *sections in [dict objectForKey:@"sections"]) {
                     DESectionModel *section = [DESectionModel new];
                     section.info = [sections objectForKey:@"info"];
                     section.from = [sections objectForKey:@"from"];
                     section.to = [sections objectForKey:@"to"];
                     section.interval = [sections objectForKey:@"interval"];
                     [trainModel.sectionArray addObject:section];
                     for(NSDictionary *stations in [sections objectForKey:@"stations"]) {
                         DEStationModel *station = [DEStationModel new];
                         station.name = [stations objectForKey:@"name"];
                         station.time = [stations objectForKey:@"time"];
                         [section.stationsArray addObject:station];
                     }

                 }
                 [models addObject:trainModel];
             }
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
             
             callbackBlock(models);
         }
         
     }];

}

@end

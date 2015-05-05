//
//  DEICSParser.m
//  DHBW-iOS
//
//  Created by David Ehlen on 10.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEICSParser.h"
#import "DECalendarModel.h"
#import "AppDelegate.h"
#import <SIAlertView/SIAlertView.h>
#import "GTMNSString+HTML.h"

@implementation DEICSParser

-(id)init {
    self = [super init];
    if(self) {
        keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"DHBWIOS" accessGroup:nil];

    }
    return self;
}

- (void)modelsWithCompletion:(void (^)(NSMutableArray *))callbackBlock
{
    NSMutableArray *models = [NSMutableArray new];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
    NSString *icsURL = [keychainWrapper objectForKey:(__bridge id)(kSecAttrLabel)];
    NSString *encodedIcsURL =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)icsURL, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    NSString *urlString = [NSString stringWithFormat:@"http://s533994975.online.de/raplaParser/parser.php?url=%@",encodedIcsURL];
    NSLog(@"%@",urlString);
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
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
                 DECalendarModel *model = [DECalendarModel new];
                 if([dict objectForKey:@"summary"] == nil) {
                     model.subject = @"";
                     model.tutor = @"";
                 }
                 else {
                 NSArray *summaryArray = [[dict objectForKey:@"summary"]componentsSeparatedByString:@" ["];
                 model.subject = summaryArray[0];
                     if(summaryArray.count < 2) {
                         model.tutor = @"";
                     }
                     else {
                 model.tutor = [[[summaryArray[1] substringWithRange: NSMakeRange(0, [summaryArray[1] rangeOfString: @"]"].location)]stringByReplacingOccurrencesOfString:@"//" withString:@""]stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                     }
                 }
                 
                 if([dict objectForKey:@"category"] == nil) {
                     model.isExam = NO;
                 }
                 else {
                     if([[dict objectForKey:@"category"] isEqualToString:@"Prüfung"] || [[dict objectForKey:@"category"] isEqualToString:@"Sonstiger Termin"]) {
                         model.isExam = YES;
                     }
                     else {
                         model.isExam = NO;
                     }
                 }
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                 [dateFormatter setDateFormat:@"YYYYMMdd'T'HHmmss"];
                 model.startDateTime = [dateFormatter dateFromString:[dict objectForKey:@"dtstart"]];
                 model.endDateTime = [dateFormatter dateFromString:[dict objectForKey:@"dtend"]];
                
                 if(model.startDateTime == nil || model.endDateTime == nil) {
                     [dateFormatter setDateFormat:@"YYYYMMdd'T'HHmmss'Z'"];
                     NSDate *timezoneDateStart = [dateFormatter dateFromString:[dict objectForKey:@"dtstart"]];
                     NSDate *timezoneDateEnd = [dateFormatter dateFromString:[dict objectForKey:@"dtend"]];
                     NSTimeInterval secondsInOneHour = 1 * 60 * 60;
                     model.startDateTime = [timezoneDateStart dateByAddingTimeInterval:secondsInOneHour];
                     model.endDateTime = [timezoneDateEnd dateByAddingTimeInterval:secondsInOneHour];

                 }
                 if([dict objectForKey:@"location"] == nil) {
                     model.room = @"";
                 }
                 else {
                 model.room = [dict objectForKey:@"location"];
                 }
                 [models addObject:model];

                 
             }
             [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];

             callbackBlock(models);
         }
         
     }];
}



@end

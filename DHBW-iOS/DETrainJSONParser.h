//
//  DETrainJSONParser.h
//  DHBW-iOS
//
//  Created by David Ehlen on 13.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DETrainJSONParser : NSObject

- (void)modelsFrom:(NSString *)from to:(NSString *)to time:(NSString *)time withCompletion:(void (^)(NSMutableArray *))callbackBlock;
- (void)possibleStationsForText:(NSString*)station withCompletion:(void (^)(NSMutableArray *))callbackBlock;
@end

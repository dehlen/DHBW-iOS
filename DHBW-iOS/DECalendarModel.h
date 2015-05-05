//
//  DECalendarModel.h
//  DHBW-iOS
//
//  Created by David Ehlen on 10.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DECalendarModel : NSObject

@property (nonatomic,copy) NSString *subject;
@property (nonatomic,copy) NSString *tutor;
@property (nonatomic,copy) NSString *room;
@property (nonatomic,copy) NSDate *startDateTime;
@property (nonatomic,copy) NSDate *endDateTime;
@property (nonatomic,assign) BOOL isExam;
@end

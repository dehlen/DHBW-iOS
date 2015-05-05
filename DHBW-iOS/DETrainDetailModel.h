//
//  DETrainDetailModel.h
//  DHBW-iOS
//
//  Created by David Ehlen on 13.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DESectionModel.h"

@interface DETrainDetailModel : NSObject

@property (nonatomic,copy) NSString *tripName;
@property (nonatomic,copy) NSString *from;
@property (nonatomic,copy) NSString *to;
@property (nonatomic,copy) NSString *interval;
@property (nonatomic,copy) NSNumber *duration;
@property (nonatomic,copy) NSString *with;
@property (nonatomic,copy) NSString *changes;
@property (nonatomic,strong) NSMutableArray *sectionArray;;


@end

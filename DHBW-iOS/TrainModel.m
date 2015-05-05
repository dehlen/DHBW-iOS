//
//  TrainModel.m
//  DHBW-iOS
//
//  Created by David Ehlen on 19.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "TrainModel.h"

@implementation TrainModel

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithJSONDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
       [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

@end

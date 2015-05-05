//
//  DEContactModel.m
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "DEContactModel.h"

@implementation DEContactModel

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

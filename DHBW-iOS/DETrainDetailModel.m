//
//  DETrainDetailModel.m
//  DHBW-iOS
//
//  Created by David Ehlen on 13.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DETrainDetailModel.h"

@implementation DETrainDetailModel

-(id)init {
    self = [super init];
    if(self) {
        self.sectionArray = [NSMutableArray new];
    }
    return self;
}

@end

//
//  DESectionModel.m
//  DHBW-iOS
//
//  Created by David Ehlen on 13.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DESectionModel.h"

@implementation DESectionModel

-(id)init {
    self = [super init];
    if(self) {
        self.stationsArray = [NSMutableArray new];
    }
    return self;
}

@end

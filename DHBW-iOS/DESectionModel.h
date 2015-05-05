//
//  DESectionModel.h
//  DHBW-iOS
//
//  Created by David Ehlen on 13.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESectionModel : NSObject

@property (nonatomic,copy) NSString *interval;
@property (nonatomic,copy) NSString *info;
@property (nonatomic,copy) NSString *to;
@property (nonatomic,copy) NSString *from;
@property (nonatomic,strong) NSMutableArray *stationsArray;

@end

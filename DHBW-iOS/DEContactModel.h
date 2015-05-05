//
//  DEContactModel.h
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DEContactModel : NSObject

@property (nonatomic, strong) NSString *telephone;
@property (nonatomic, strong) NSString *function;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *room;

-(instancetype)initWithJSONDict:(NSDictionary *)dict;


@end

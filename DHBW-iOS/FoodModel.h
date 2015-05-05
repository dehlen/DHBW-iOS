//
//  FoodModel.h
//  DHBW-iOS
//
//  Created by David Ehlen on 19.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodModel : NSObject
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSNumber *student_price;
@property (nonatomic,strong) NSString *condiments;

-(instancetype)initWithJSONDict:(NSDictionary *)dict;


@end

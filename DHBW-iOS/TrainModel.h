//
//  TrainModel.h
//  DHBW-iOS
//
//  Created by David Ehlen on 19.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrainModel : NSObject

@property (nonatomic,strong) NSString *line;
@property (nonatomic,strong) NSString *destination;
@property (nonatomic,strong) NSString *lineColor;
@property (nonatomic,strong) NSString *time;

-(instancetype)initWithJSONDict:(NSDictionary *)dict;


@end

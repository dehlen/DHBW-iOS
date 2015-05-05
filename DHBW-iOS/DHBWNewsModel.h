//
//  DHBWNewsModel.h
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHBWNewsModel : NSObject

@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *published;
@property (nonatomic,strong) NSString *link;
@property (nonatomic,strong) NSString *descr;
@property (nonatomic,strong) NSString *title;

-(instancetype)initWithJSONDict:(NSDictionary *)dict;

@end

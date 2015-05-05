//
//  StuvNewsModel.m
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "StuvNewsModel.h"
#import "NSString+HTML.h"

@implementation StuvNewsModel

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
        if(self.title.length > 0) {
             self.title = [[self.title stringByReplacingOccurrencesOfString:@"+" withString:@""]stringByDecodingHTMLEntities];
        }
        [self.content stringByDecodingHTMLEntities];

    }
    return self;
}



@end

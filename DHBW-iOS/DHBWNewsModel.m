//
//  DHBWNewsModel.m
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "DHBWNewsModel.h"
#import "NSString+HTML.h"

@implementation DHBWNewsModel

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
        [self.content stringByDecodingHTMLEntities];
        [self.descr stringByDecodingHTMLEntities];
        [self.title stringByDecodingHTMLEntities];

	}
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   if([key isEqualToString:@"description"]) {
		[self setValue:value forKey:@"descr"];
	}
}

@end

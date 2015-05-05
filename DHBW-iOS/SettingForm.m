//
//  SettingForm.m
//  DHBW-iOS
//
//  Created by David Ehlen on 06.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "SettingForm.h"

@implementation SettingForm

-(id)init {
    self = [super init];
    if(self) {
        keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"DHBWIOS" accessGroup:nil];
    }
    
    return self;
}

- (NSDictionary *)usernameField
{
    return @{@"textField.autocapitalizationType": @(UITextAutocapitalizationTypeNone),
             @"textLabel.color": [UIColor colorWithWhite:0.400 alpha:1.000],
             @"textField.textColor": [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000],
             @"textLabel.font": [UIFont systemFontOfSize:16],
             FXFormFieldAction:@"usernameChanged:",
             @"textField.placeholder": @"nachname.vorname",
             @"textField.text" : [keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)]

             };
}

- (NSDictionary *)passwordField
{
    return @{@"textField.autocapitalizationType": @(UITextAutocapitalizationTypeNone),
             @"textLabel.color": [UIColor colorWithWhite:0.400 alpha:1.000],
             @"textField.textColor": [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000],
             @"textLabel.font": [UIFont systemFontOfSize:16],
             FXFormFieldAction:@"passwordChanged:",
             @"textField.text" : [keychainWrapper objectForKey:(__bridge id)(kSecValueData)]
             };

}
- (NSDictionary *)raplaField
{
    return @{@"textField.autocapitalizationType": @(UITextAutocapitalizationTypeNone),
             FXFormFieldTitle: @"Rapla URL (.ics)",
             @"textLabel.color": [UIColor colorWithWhite:0.400 alpha:1.000],
             @"textField.textColor": [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000],
             @"textLabel.font": [UIFont systemFontOfSize:16],
             FXFormFieldAction:@"raplaChanged:",
             @"textField.text" : [keychainWrapper objectForKey:(__bridge id)(kSecAttrLabel)]
             };

}

- (NSArray *)fields
{
    return @[
             @{FXFormFieldKey: @"username", FXFormFieldHeader: @"Login"},
             @"password",
             @{FXFormFieldKey: @"rapla", FXFormFieldHeader: @"Kalender"}
             ];
}


@end

//
//  SettingForm.h
//  DHBW-iOS
//
//  Created by David Ehlen on 06.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FXForms/FXForms.h>
#import "KeychainItemWrapper.h"

@interface SettingForm : NSObject <FXForm> {
    KeychainItemWrapper *keychainWrapper;
}
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *rapla;

@end

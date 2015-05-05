//
//  DESettingsViewController.h
//  DHBW-iOS
//
//  Created by David Ehlen on 06.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FXForms/FXForms.h>
#import "KeychainItemWrapper.h"

@interface DESettingsViewController : UIViewController <FXFormControllerDelegate> {
    UIStoryboard *storyboard;
    KeychainItemWrapper *keychainWrapper;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FXFormController *formController;

@end

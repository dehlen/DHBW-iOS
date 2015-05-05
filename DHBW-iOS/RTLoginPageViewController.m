//
//  RTCustomPageViewController.m
//  Walkthrough
//
//  Created by Aleksandar Vacić on 4.11.14..
//  Copyright (c) 2014. Radiant Tap. All rights reserved.
//

#import "RTLoginPageViewController.h"
#import "RTWalkthroughViewController.h"

@interface RTLoginPageViewController () < RTWalkthroughPage, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *textLabel;
@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;


@end

@implementation RTLoginPageViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    self.usernameField.tag = 1;
    self.passwordField.tag = 2;
    keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"DHBWIOS" accessGroup:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.usernameField.layer setCornerRadius:2];
    [self.passwordField.layer setCornerRadius:2];
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.usernameField endEditing:YES];
    [self.passwordField endEditing:YES];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.length > 0) {

    if(textField.tag == 1) {
        [keychainWrapper setObject:textField.text forKey:(__bridge id)(kSecAttrAccount)];

    }
    else {
        [keychainWrapper setObject:textField.text forKey:(__bridge id)(kSecValueData)];

      }
    }
}

- (void)walkthroughDidScrollToPosition:(CGFloat)position offset:(CGFloat)offset {

	CATransform3D tr = CATransform3DIdentity;
	tr.m34 = (CGFloat) (-1/500.0);
	
	self.titleLabel.layer.transform = CATransform3DRotate(tr, (CGFloat) ((CGFloat)M_PI * (1.0 - offset)), 1, 1, 1);
	self.textLabel.layer.transform = CATransform3DRotate(tr, (CGFloat) ((CGFloat)M_PI * (1.0 - offset)), 1, 1, 1);

}

@end

//
//  RTRaplaPageViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 09.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "RTRaplaPageViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface RTRaplaPageViewController () <UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *textLabel;
@property (nonatomic,strong) IBOutlet UITextField *raplaField;
@end

@implementation RTRaplaPageViewController


-(void)viewWillAppear:(BOOL)animated {
    [self.raplaField.layer setCornerRadius:2.0];
    self.raplaField.leftViewMode = UITextFieldViewModeAlways;
    self.raplaField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 5)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.raplaField.delegate = self;
    keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"DHBWIOS" accessGroup:nil];

    
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField.text.length > 0) {
    [keychainWrapper setObject:textField.text forKey:(__bridge id)(kSecAttrLabel)];
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.raplaField endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  DESettingsViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 06.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DESettingsViewController.h"
#import "SettingForm.h"
#import "UIViewController+ENPopUp.h"
#import <SIAlertView/SIAlertView.h>

@interface DESettingsViewController ()

@end

@implementation DESettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Einstellungen";
   
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.formController = [[FXFormController alloc] init];
    self.formController.tableView = self.tableView;
    self.formController.delegate = self;
    self.formController.form = [[SettingForm alloc] init];
    
    
    UIBarButtonItem *helpItem = [[UIBarButtonItem alloc]initWithTitle:@"Hilfe" style:UIBarButtonItemStylePlain target:self action:@selector(showHelp)];
    self.navigationItem.rightBarButtonItem = helpItem;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        storyboard =
        [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"DHBWIOS" accessGroup:nil];
}

-(void)showHelp {
    UIViewController *popUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingsPopup"];
    popUpViewController.view.frame = CGRectMake(0, 0, 300.0f, 285.0f);
    [self presentPopUpViewController:popUpViewController];
}

-(void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}


-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx = @"http(s)?://([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&amp;=]*)?";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

-(void)raplaChanged:(UITableViewCell<FXFormFieldCell> *)cell {
    SettingForm *form = cell.field.form;
	if([form.rapla rangeOfString:@"page=iCal"].location == NSNotFound || ![self validateUrl:form.rapla]) {
		SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"URL fehlerhaft" andMessage:@"Die angegeben URL ist fehlerhaft. Enthält die URL page=calendar anstatt page=iCal ?"];

		[alertView addButtonWithTitle:@"OK"
                         type:SIAlertViewButtonTypeDefault
                      handler:^(SIAlertView *alert) {

                      }];

		alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
		[alertView show];
	}
    else {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"changedCalendarURL"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [keychainWrapper setObject:form.rapla forKey:(__bridge id)(kSecAttrLabel)];
    }
    
}

-(void)usernameChanged:(UITableViewCell<FXFormFieldCell> *)cell {
    SettingForm *form = cell.field.form;
    [keychainWrapper setObject:form.username forKey:(__bridge id)(kSecAttrAccount)];
}

-(void)passwordChanged:(UITableViewCell<FXFormFieldCell> *)cell {
    SettingForm *form = cell.field.form;
    [keychainWrapper setObject:form.password forKey:(__bridge id)(kSecValueData)];
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

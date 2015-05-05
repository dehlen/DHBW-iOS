//
//  InAPPWebViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 04.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "InAPPWebViewController.h"
#import "AppDelegate.h"
#import <SIAlertView/SIAlertView.h>

@implementation InAPPWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [webview loadRequest:[NSURLRequest requestWithURL:self.url]];
    webview.delegate = self;
    [progressIndicator setHidesWhenStopped:YES];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.title = @"DHBW-Browser";
    
    keychainWrapper = [[KeychainItemWrapper alloc] initWithIdentifier:@"DHBWIOS" accessGroup:nil];

}


-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)checkURLForLogin:(NSURL *)requestedURL {
    NSString *toCheckString = [requestedURL.host stringByReplacingOccurrencesOfString:@"www." withString:@""];

    if([toCheckString isEqualToString:@"dualis.dhbw.de"]) {
        self.isDualis = YES;
        fillLoginButton.enabled = YES;
    }
    else {
        self.isDualis = NO;
        fillLoginButton.enabled = [toCheckString isEqualToString:@"else.dhbw-karlsruhe.de"];
    }
}

-(IBAction)tryLogin:(id)sender {
    NSString *username = [keychainWrapper objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [keychainWrapper objectForKey:(__bridge id)(kSecValueData)];
    
    if(username.length != 0 && password.length != 0) {
        NSString *modifiedUsername = username;
        if(self.isDualis) {
            modifiedUsername = [username stringByAppendingString:@"@dh-karlsruhe.de"];
        }
    NSString *loadUsernameJS = [NSString stringWithFormat:@"var inputFields = document.querySelectorAll(\"input[type='text']\"); \
                                for (var i = inputFields.length >>> 0; i--;) { inputFields[i].value = '%@';}", modifiedUsername];
    NSString *loadPasswordJS = [NSString stringWithFormat:@"var inputFields = document.querySelectorAll(\"input[type='password']\"); \
                                for (var i = inputFields.length >>> 0; i--;) { inputFields[i].value = '%@';}", password];
    
    //autofill the form
    [webview stringByEvaluatingJavaScriptFromString: loadPasswordJS];
    [webview stringByEvaluatingJavaScriptFromString: loadUsernameJS];
        
    NSString *performSubmitJS = @"var passFields = document.querySelectorAll(\"input[type='submit']\"); \
        passFields[0].click()";
    [webview stringByEvaluatingJavaScriptFromString:performSubmitJS];
    }

    
    [fillLoginButton setImage:[UIImage imageNamed:@"unlock"]];
    [self performSelector:@selector(resetLockImage) withObject:nil afterDelay:1.0];
}
-(void)resetLockImage {
    [fillLoginButton setImage:[UIImage imageNamed:@"lock"]];
    fillLoginButton.enabled = NO;
}

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [progressIndicator startAnimating];
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self checkURLForLogin:webView.request.URL];

    [backButton setEnabled:[webView canGoBack]];
        [forwardButton setEnabled:[webView canGoForward]];
    
    [progressIndicator stopAnimating];
     [(AppDelegate *)[[UIApplication sharedApplication] delegate] setNetworkActivityIndicatorVisible:NO];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"%@",error);
    [progressIndicator stopAnimating];
    
    SIAlertView *alert = [[SIAlertView alloc]initWithTitle:@"Fehler beim Laden" andMessage:@"Seite konnte nicht geladen werden. Stellen Sie sicher das sie eine Netzwerkverbindung haben."];
    
    [alert addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alertView) {
                          }];
    alert.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alert show];

}


@end

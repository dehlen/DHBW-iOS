//
//  InAPPWebViewController.h
//  DHBW-iOS
//
//  Created by David Ehlen on 04.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeychainItemWrapper.h"

@interface InAPPWebViewController : UIViewController<UIWebViewDelegate> {
    IBOutlet UIWebView *webview;
    IBOutlet UIActivityIndicatorView *progressIndicator;
    
    IBOutlet UIBarButtonItem *fillLoginButton;
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *forwardButton;

    KeychainItemWrapper *keychainWrapper;
}

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,assign) BOOL isDualis;

-(IBAction)tryLogin:(id)sender;
@end

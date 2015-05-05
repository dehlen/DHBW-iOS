#import "DEStuvNewsDetailViewController.h"
#import "InAPPWebViewController.h"
@interface DEStuvNewsDetailViewController()
@end

@implementation DEStuvNewsDetailViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    upButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"UIButtonBarArrowUp"] style:UIBarButtonItemStylePlain target:self action:@selector(up)];
    upButtonItem.tintColor = [UIColor redColor];
    
    downButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"UIButtonBarArrowDown"]style:UIBarButtonItemStylePlain target:self action:@selector(down)];
    downButtonItem.tintColor = [UIColor redColor];
    
    webButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(openInSafari)];
    webButtonItem.tintColor = [UIColor redColor];

    [self.navigationItem setRightBarButtonItems:@[downButtonItem, upButtonItem, webButtonItem] animated:YES];
    
    [self updateView];
    if(self.startIndex == 0) {
        upButtonItem.enabled = NO;
    }
    else if (self.startIndex == self.articles.count-1) {
        downButtonItem.enabled = NO;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        storyboard =
        [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.title = [self.articles[self.startIndex] title];

}


-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)openInSafari {
    InAPPWebViewController *inAppWebViewController = [storyboard instantiateViewControllerWithIdentifier:@"InAPPWebViewController"];
    inAppWebViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    inAppWebViewController.url = [NSURL URLWithString:[self.articles[self.startIndex] link]];
    [self.navigationController pushViewController:inAppWebViewController animated:YES];
}

-(void)up {
    self.startIndex--;
    upButtonItem.enabled = YES;
    downButtonItem.enabled = YES;
    if(self.startIndex == 0) {
        upButtonItem.enabled = NO;
    }
    [self updateView];
}

-(void)down {
    self.startIndex++;
    downButtonItem.enabled = YES;
    upButtonItem.enabled = YES;
    if(self.startIndex == self.articles.count -1) {
        downButtonItem.enabled = NO;
    }
    [self updateView];
}

-(void)updateView {
    [contentView setContentOffset:CGPointZero animated:YES];

    StuvNewsModel *model = self.articles[self.startIndex];
    
    titleLabel.text = model.title;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[model.content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Khmer Sangam MN" size:17] range:NSMakeRange(0, attributedString.length)];
    
    contentView.attributedText = attributedString;
}

/* Klappt nicht wirklich
-(NSString *)removeTitleFromContent:(NSString *)con andTitle:(NSString*)title {
    NSError *error = nil;


    NSString *pattern = [NSString stringWithFormat:@"[+]+%@[+]+",[[title componentsSeparatedByString:@"\n"] objectAtIndex:0]];
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:con options:0 range:NSMakeRange(0, [con length]) withTemplate:@""];
    
    return modifiedString;
}
*/



-(void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
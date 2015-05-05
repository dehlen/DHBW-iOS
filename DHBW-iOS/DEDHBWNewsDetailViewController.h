#import <UIKit/UIKit.h>
#import "DHBWNewsModel.h"

@interface DEDHBWNewsDetailViewController : UIViewController {
    UIBarButtonItem *upButtonItem;
    UIBarButtonItem *downButtonItem;
    UIBarButtonItem *webButtonItem;
    
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextView *contentView;
    
    UIStoryboard *storyboard;
}

@property (nonatomic, strong) NSMutableArray *articles;
@property (nonatomic,assign) NSUInteger startIndex;
@end
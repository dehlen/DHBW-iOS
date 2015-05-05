#import <UIKit/UIKit.h>
#import "INSSearchBar.h"
#import "SQLiteManager.h"
#import "IGLDropDownItem.h"
#import "IGLDropDownMenu.h"

@interface DERoomViewController : UIViewController <INSSearchBarDelegate,IGLDropDownMenuDelegate> {
    INSSearchBar *roomSearchBar;
    NSInteger selectedIndex;
    SQLiteManager *sqliteManager;
    IBOutlet UITextView *textView;
    IBOutlet UIImageView *imageView;
    NSMutableArray *dropDownTitles;
    
}
@property (nonatomic, strong) IGLDropDownMenu *dropDownMenu;

@end
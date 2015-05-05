#import <UIKit/UIKit.h>

@interface DEDHBWNewsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
		IBOutlet UITableView *tableView;
		UIStoryboard *storyboard;
        UIRefreshControl *refreshControl;
}
@property (nonatomic, strong) NSMutableArray *dhbwNews;
@end
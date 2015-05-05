#import <UIKit/UIKit.h>

@interface DEStuvNewsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
		IBOutlet UITableView *tableView;
		UIStoryboard *storyboard;
        UIRefreshControl *refreshControl;
}	
@property (nonatomic, strong) NSMutableArray *stuvNews;
@end
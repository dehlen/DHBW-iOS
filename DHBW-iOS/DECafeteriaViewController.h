#import <UIKit/UIKit.h>
#import "DEJSONParser.h"

@interface DECafeteriaViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    DEJSONParser *parser;
    UIStoryboard *storyboard;
    UIRefreshControl *refreshControl;
    NSDate *selectedDate;
}

@property (nonatomic,strong) NSMutableArray *mensaArray;
@property (nonatomic,strong) IBOutlet UITableView *tableView;

@end
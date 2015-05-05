#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>
#import "DEICSParser.h"
#import "ODRefreshControl.h"

@interface DECalendarViewController : UIViewController <JTCalendarDataSource, UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    IBOutlet UIButton *prevButton;
    IBOutlet UIButton *forwardButton;
    IBOutlet UITableView *myTableView;
    DEICSParser *icsParser;
    NSIndexPath *clickedIndexPath;
    ODRefreshControl *refreshControl;
    NSDate *selectedDate;
}

@property (weak, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (weak, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (strong, nonatomic) JTCalendar *calendar;
@property (strong, nonatomic) NSMutableArray *calArray;
@property (strong, nonatomic) NSMutableArray *entriesForDate;

-(IBAction)monthBack:(id)sender;
-(IBAction)monthForward:(id)sender;

@end
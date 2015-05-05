#import <UIKit/UIKit.h>
#import "DETrainJSONParser.h"

@interface DETrainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    IBOutlet UITextField *fromField;
    IBOutlet UITextField *toField;
    DETrainJSONParser *trainJSONParser;
    NSMutableArray *possibleStations;
    UIStoryboard *storyboard;
    IBOutlet UITextField *timeField;
    IBOutlet UIToolbar *toolbarCancelDone;
    IBOutlet UIPickerView *customPicker;
    NSInteger selectedIndex;
}
@property (nonatomic,strong) NSMutableArray *trainArray;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSString *to;

- (IBAction)actionCancel:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)actionDone:(id)sender;
@end
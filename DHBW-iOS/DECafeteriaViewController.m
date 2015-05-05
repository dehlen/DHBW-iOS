#import "DECafeteriaViewController.h"
#import "DIDatepicker.h"
#import "FoodModel.h"
#import "DEMensaCell.h"
#import "AppDelegate.h"
#import "UITableView+NXEmptyView.h"
#import "UIViewController+ENPopUp.h" 
#import "DEPopupViewController.h"
#import <SIAlertView/SIAlertView.h>

@interface DECafeteriaViewController()
@property (weak, nonatomic) IBOutlet DIDatepicker *datepicker;

@end

@implementation DECafeteriaViewController

-(void)viewDidLoad {
	[super viewDidLoad];
    [self.datepicker addTarget:self action:@selector(updateSelectedDate) forControlEvents:UIControlEventValueChanged];
    
    [self.datepicker fillDatesFromCurrentDate:14];
    //    [self.datepicker fillCurrentWeek];
    //    [self.datepicker fillCurrentMonth];
    [self.datepicker selectDateAtIndex:0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    parser = [[DEJSONParser alloc]init];
    
    self.tableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    [self setEmptyView];
    

    [self loadInformationForDay:[NSDate date] stopRefresh:NO];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];

    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    UIBarButtonItem *helpItem = [[UIBarButtonItem alloc]initWithTitle:@"Hilfe" style:UIBarButtonItemStylePlain target:self action:@selector(showHelp)];
    self.navigationItem.rightBarButtonItem = helpItem;

    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        storyboard =
        [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    self.navigationItem.title = @"Mensa";
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
}

-(void)refreshTable {
    [refreshControl beginRefreshing];

    [self loadInformationForDay:selectedDate stopRefresh:YES];
}


-(void)setEmptyView {
    // Display a message when the table is empty
    UIView *emptyView = [[UIView alloc]init];
    emptyView.frame = self.tableView.frame;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyView.frame.size.height/2, emptyView.frame.size.width, 40)];
    
    messageLabel.text = @"Keine Informationen vefügbar.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    // [messageLabel sizeToFit];
    [emptyView addSubview:messageLabel];
    
    self.tableView.nxEV_emptyView = emptyView;
}


-(void)showHelp {
    DEPopupViewController *popUpViewController = [storyboard instantiateViewControllerWithIdentifier:@"DEPopupViewController"];
    popUpViewController.view.frame = CGRectMake(0, 0, 270.0f, 230.0f);
     [self presentPopUpViewController:popUpViewController];
}

-(void)loadInformationForDay:(NSDate *)date stopRefresh:(BOOL)stopRefresh{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",kAPIEndpointCafeteriaDay,[dateFormatter stringFromDate:date]];
    DEJSONParser * __weak weakParser=parser;
    [weakParser modelsFromURL:[NSURL URLWithString:urlString] forClass:[FoodModel class] withCompletion:^(NSMutableArray *mm){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(stopRefresh) {
                [refreshControl endRefreshing];
            }
            [self setModelWithArray:mm];
            
        });
    }];
}

-(void)setModelWithArray:(NSMutableArray *)array {
    self.mensaArray = array;
    [self.tableView reloadData];
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSelectedDate
{
    selectedDate = self.datepicker.selectedDate;
    [self loadInformationForDay:self.datepicker.selectedDate stopRefresh:NO];
}

#pragma mark -
#pragma mark UITableView
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mensaArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DEMensaCell";
    DEMensaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DEMensaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DEMensaCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DEMensaCell"];
    }
    
    cell.foodLabel.text = [self.mensaArray[(NSUInteger) indexPath.row] name];
    if([self.mensaArray[(NSUInteger) indexPath.row] student_price] == nil) {
        cell.priceLabel.text = [NSString stringWithFormat:@"--€"];
    }
    else {
        NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
        [fmt setPositiveFormat:@"##0.00"];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@ €",[fmt stringFromNumber:[self.mensaArray[(NSUInteger) indexPath.row] student_price]]];
    }
    cell.condimentsLabel.text = [self.mensaArray[(NSUInteger) indexPath.row] condiments];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Speise" andMessage:[self.mensaArray[(NSUInteger) indexPath.row] name]];
    
    [alertView addButtonWithTitle:@"OK"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                          }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    
    [alertView show];
}


-(void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
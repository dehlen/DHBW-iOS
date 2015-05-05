#import "DECalendarViewController.h"
#import "DECalendarModel.h"
#import "DECalendarCell.h"
#import "UITableView+NXEmptyView.h"
#import "DEAlarmViewController.h"

@interface DECalendarViewController() {
    NSMutableDictionary *eventsByDate;
}

@end

@implementation DECalendarViewController

-(void)viewDidLoad {
	[super viewDidLoad];
    
    icsParser = [[DEICSParser alloc]init];
    self.entriesForDate = [NSMutableArray new];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    self.navigationItem.title = @"Kalender";
    
    UIImage *backImage = [[UIImage imageNamed:@"goBack"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage *fwdImage = [[UIImage imageNamed:@"goForward"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    [prevButton setImage:backImage forState:UIControlStateNormal];
    [forwardButton setImage:fwdImage forState:UIControlStateNormal];
    
    prevButton.tintColor = [UIColor colorWithWhite:0.250 alpha:1.000];
    forwardButton.tintColor = [UIColor colorWithWhite:0.250 alpha:1.000];
    
    self.calendar = [JTCalendar new];
    
    {
        self.calendar.calendarAppearance.calendar.firstWeekday = 2; // Sunday == 1, Saturday == 7
        self.calendar.calendarAppearance.dayCircleRatio = 9. / 10.;
        self.calendar.calendarAppearance.weekDayTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
        self.calendar.calendarAppearance.weekDayTextColor = [UIColor colorWithWhite:0.250 alpha:1.000];
        self.calendar.calendarAppearance.ratioContentMenu = 1;
        self.calendar.calendarAppearance.focusSelectedDayChangeMode = YES;
        self.calendar.calendarAppearance.autoChangeMonth = YES;
        self.calendar.calendarAppearance.dayDotColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        self.calendar.calendarAppearance.dayCircleColorToday = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        self.calendar.calendarAppearance.dayCircleColorSelected = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        self.calendar.calendarAppearance.dayCircleColorSelectedOtherMonth = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        self.calendar.calendarAppearance.dayCircleColorTodayOtherMonth = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        self.calendar.calendarAppearance.menuMonthTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
        
        self.calendar.calendarAppearance.dayDotColorSelected = [UIColor whiteColor];
        self.calendar.calendarAppearance.dayDotColorOtherMonth = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        self.calendar.calendarAppearance.dayDotColorSelectedOtherMonth = [UIColor whiteColor];
        self.calendar.calendarAppearance.dayDotColorToday = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        self.calendar.calendarAppearance.dayDotColorTodayOtherMonth = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    

        self.calendar.calendarAppearance.dayTextColor = [UIColor colorWithWhite:0.250 alpha:1.000];
        self.calendar.calendarAppearance.dayTextColorSelected = [UIColor whiteColor];
        self.calendar.calendarAppearance.dayTextColorOtherMonth = [UIColor colorWithRed:0.805 green:0.805 blue:0.805 alpha:1.000];
        self.calendar.calendarAppearance.dayTextColorSelectedOtherMonth = [UIColor whiteColor];
        self.calendar.calendarAppearance.dayTextColorToday = [UIColor colorWithWhite:0.250 alpha:1.000];
        self.calendar.calendarAppearance.dayTextColorTodayOtherMonth = [UIColor colorWithRed:0.805 green:0.805 blue:0.805 alpha:1.000];
        self.calendar.calendarAppearance.dayTextFont = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];


        // Customize the text for each month
        self.calendar.calendarAppearance.monthBlock = ^NSString *(NSDate *date, JTCalendar *jt_calendar){
            NSCalendar *calendar = jt_calendar.calendarAppearance.calendar;
            NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:date];
            NSInteger currentMonthIndex = comps.month;
            
            static NSDateFormatter *dateFormatter;
            if(!dateFormatter){
                dateFormatter = [NSDateFormatter new];
                dateFormatter.timeZone = jt_calendar.calendarAppearance.calendar.timeZone;
            }
            
            while(currentMonthIndex <= 0){
                currentMonthIndex += 12;
            }
            
            NSString *monthText = [[dateFormatter standaloneMonthSymbols][currentMonthIndex - 1] capitalizedString];
            
            return [NSString stringWithFormat:@"%ld\n%@", (long)comps.year, monthText];
        };
    }
    
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    UIBarButtonItem *todayItem = [[UIBarButtonItem alloc]initWithTitle:@"Heute" style:UIBarButtonItemStylePlain target:self action:@selector(showToday)];
    self.navigationItem.rightBarButtonItem = todayItem;
    
    myTableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    [self setEmptyView];
    
    if(self.calArray.count == 0) {
        DEICSParser * __weak weakICSParser=icsParser;
        [weakICSParser modelsWithCompletion:^(NSMutableArray *mm){
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setModelArray:mm];
                [self setAllEntriesForDate:[NSDate date]];
            });
        }];
    }
    else {
        BOOL reload = [[NSUserDefaults standardUserDefaults]boolForKey:@"changedCalendarURL"];
        if(reload) {
            DEICSParser * __weak weakICSParser=icsParser;
            [weakICSParser modelsWithCompletion:^(NSMutableArray *mm){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self setModelArray:mm];
                    [self setAllEntriesForDate:[NSDate date]];
                });
            }];
        }
        else {
        [self setAllEntriesForDate:[NSDate date]];
        [myTableView reloadData];
        }
    }
    
    refreshControl = [[ODRefreshControl alloc]initInScrollView:myTableView];
    [myTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
    

}
-(void)refresh {
    [refreshControl beginRefreshing];

    DEICSParser * __weak weakICSParser=icsParser;

    [weakICSParser modelsWithCompletion:^(NSMutableArray *mm){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setModelArray:mm];
        });
    }];
}

-(void)setModelArray:(NSMutableArray *)array {
    self.calArray = array;
    [myTableView reloadData];
    [self.calendar reloadData];
    [refreshControl endRefreshing];

}
-(void)setEmptyView {
    // Display a message when the table is empty
    UIView *emptyView = [[UIView alloc]init];
    emptyView.frame = myTableView.frame;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyView.frame.size.height/2, emptyView.frame.size.width, 40)];
    
    messageLabel.text = @"Keine Informationen vefügbar.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    // [messageLabel sizeToFit];
    [emptyView addSubview:messageLabel];
    
    myTableView.nxEV_emptyView = emptyView;
   
}



-(void)showToday {
     NSDate *today = [NSDate date];
    [self.calendar setCurrentDate:today];
    selectedDate = today;
    [self setAllEntriesForDate:today];
    [myTableView reloadData];
}

-(IBAction)monthBack:(id)sender {
    [self.calendar loadPreviousMonth];
}
-(IBAction)monthForward:(id)sender {
    [self.calendar loadNextMonth];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    /* Fixed via https://github.com/jonathantribouharet/JTCalendar/issues/31
    [self.calendarContentView setHidden:NO];
    [self.calendarMenuView setHidden:NO];
     */
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.calendar reloadData];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    /* Fixed via https://github.com/jonathantribouharet/JTCalendar/issues/31
    [self.calendarContentView setHidden:YES];
    [self.calendarMenuView setHidden:YES];
     */
}


#pragma mark - JTCalendarDataSource

-(void)setAllEntriesForDate:(NSDate *)date {
    [self.entriesForDate removeAllObjects];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    for(DECalendarModel *model in self.calArray) {
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:model.startDateTime];
    
        if([comp1 day]   == [comp2 day] &&
           [comp1 month] == [comp2 month] &&
           [comp1 year]  == [comp2 year]) {
            [self.entriesForDate addObject:model];
        }
    }
    
       [self.entriesForDate sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"startDateTime" ascending:YES]]];

}

-(BOOL)hasEntriesForDate:(NSDate *)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    for(DECalendarModel *model in self.calArray) {
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date];
        NSDateComponents* comp2 = [calendar components:unitFlags fromDate:model.startDateTime];
        
        if([comp1 day]   == [comp2 day] &&
           [comp1 month] == [comp2 month] &&
           [comp1 year]  == [comp2 year]) {
            return YES;
        }
    }
    return NO;

}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return [self hasEntriesForDate:date];
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    selectedDate = date;
    [self setAllEntriesForDate:date];
    [myTableView reloadData];
}


#pragma mark - Fake data

- (NSDateFormatter *)dateFormatter
{
    static NSDateFormatter *dateFormatter;
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"dd-MM-yyyy";
    }
    
    return dateFormatter;
}

-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark UITableView
- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.entriesForDate count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DECalendarCell";
    DECalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DECalendarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DECalendarCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DECalendarCell"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    // iOS 7 and later
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    
    cell.subjectLabel.text = [[self.entriesForDate objectAtIndex:indexPath.row]subject];
    cell.tutorLabel.text = [[self.entriesForDate objectAtIndex:indexPath.row]tutor];
    cell.roomLabel.text = [[self.entriesForDate objectAtIndex:indexPath.row]room];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    
    cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[dateFormatter stringFromDate:[[self.entriesForDate objectAtIndex:indexPath.row]startDateTime]],[dateFormatter stringFromDate:[[self.entriesForDate objectAtIndex:indexPath.row]endDateTime]]];
    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[[self.entriesForDate objectAtIndex:indexPath.row]startDateTime]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    [cell setClockViewWithHour:0 andMinute:0 andSecond:0 withAnimation:NO];

    [cell setClockViewWithHour:hour andMinute:minute andSecond:second withAnimation:YES];
    
    if([[self.entriesForDate objectAtIndex:indexPath.row]isExam]) {
        cell.timeView.borderColor = [UIColor whiteColor];
        cell.timeView.hourHandColor = [UIColor whiteColor];
        cell.timeView.minuteHandColor = [UIColor whiteColor];
        cell.subjectLabel.textColor = [UIColor whiteColor];
        cell.roomLabel.textColor = [UIColor whiteColor];
        cell.tutorLabel.textColor = [UIColor whiteColor];
        cell.timeLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor =  [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        
        
    }
    else {
        cell.timeView.borderColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        cell.timeView.hourHandColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        cell.timeView.minuteHandColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        
        cell.subjectLabel.textColor = [UIColor blackColor];
        cell.roomLabel.textColor = [UIColor colorWithWhite:0.692 alpha:1.000];
        cell.tutorLabel.textColor = [UIColor colorWithWhite:0.692 alpha:1.000];
        cell.timeLabel.textColor = [UIColor colorWithWhite:0.692 alpha:1.000];
        cell.backgroundColor =  [UIColor whiteColor];
        
        
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"Aktionen" delegate:self cancelButtonTitle:@"Abbrechen" destructiveButtonTitle:nil otherButtonTitles:@"Zum Kalender hinzufügen",nil];
  
    clickedIndexPath = indexPath;
    [actionSheet showInView:self.view];

}

- (void)willPresentActionSheet:(UIActionSheet *)actionSheet
{
    SEL selector = NSSelectorFromString(@"_alertController");
    if ([actionSheet respondsToSelector:selector])
    {
        UIAlertController *alertController = [actionSheet valueForKey:@"_alertController"];
        if ([alertController isKindOfClass:[UIAlertController class]])
        {
            alertController.view.tintColor =[UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
        }
    }
    else
    {
        // use other methods for iOS 7 or older.
    
    for (UIView *subview in actionSheet.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subview;
            [button setTitleColor:[UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000] forState:UIControlStateNormal];
        }
    }
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self addToCalendar:clickedIndexPath];
            break;
        default:
            break;
    }
}

-(void)addToCalendar:(NSIndexPath *)indexPath
{
    if (indexPath != nil)
    {
        DECalendarModel *entry = [self.entriesForDate objectAtIndex:indexPath.row];
        
        DEAlarmViewController *alarmVc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"DEAlarmViewController"];
        alarmVc.calEntry = entry;
        [self.navigationController pushViewController:alarmVc animated:YES];
        
        
    }
}


-(void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
#import "DETrainViewController.h"
#import "UITableView+NXEmptyView.h"
#import "DETrainDetailViewController.h"
#import <SIAlertView/SIAlertView.h>

#define currentMonth [currentMonthString integerValue]


@interface DETrainViewController()
@end

//TODO: whitespace aus textfeld bug 

@implementation DETrainViewController {
    NSMutableArray *yearArray;
    NSArray *monthArray;
    NSMutableArray *DaysArray;
    NSArray *hoursArray;
    NSMutableArray *minutesArray;
    
    NSString *currentMonthString;
    
    int selectedYearRow;
    int selectedMonthRow;
    int selectedDayRow;
    
    BOOL firstTimeLoad;
}

-(void)viewDidLoad {
	[super viewDidLoad];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.title = @"S-Bahn";
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:@[@"Von DH", @"Zur DH"]];
    segment.selectedSegmentIndex = 0;
    segment.frame = CGRectMake(customView.frame.size.width/2-120-20, 0, 240, 30);
    [segment addTarget:self action:@selector(onSegmentChanged:) forControlEvents:UIControlEventValueChanged];
   
    [customView addSubview:segment];
    self.navigationItem.titleView = customView;

    fromField.text = @"Karlsruhe, Duale Hochschule";
    toField.text = self.to;
    
    fromField.enabled = NO;
    toField.enabled = YES;
    
    trainJSONParser = [[DETrainJSONParser alloc]init];
    possibleStations = [NSMutableArray new];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        storyboard =
        [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
     self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.tableView.bounds.size.width, 0.01f)];
    self.tableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    [self setEmptyView];
    
    [self setupTimePicker];
    
    fromField.delegate = self;
    fromField.tag = 1;
    toField.tag = 2;
    toField.delegate = self;
}
-(void)setupTimePicker {
    firstTimeLoad = YES;
    customPicker.hidden = YES;
    toolbarCancelDone.hidden = YES;
    
    NSDate *date = [NSDate date];
    
    // Get Current Year
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *currentyearString = [NSString stringWithFormat:@"%@",
                                   [formatter stringFromDate:date]];
    
    
    // Get Current  Month
    
    [formatter setDateFormat:@"MM"];
    long month = (long)[[formatter stringFromDate:date]integerValue];
    if(month < 10) {
        currentMonthString = [NSString stringWithFormat:@"0%ld",month];
    }
    else {
        currentMonthString = [NSString stringWithFormat:@"%ld",month];
    }
    
    
    // Get Current  Date
    
    [formatter setDateFormat:@"dd"];
    NSString *currentDateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    // Get Current  Hour
    [formatter setDateFormat:@"HH"];
    NSString *currentHourString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    // Get Current  Minutes
    [formatter setDateFormat:@"mm"];
    NSString *currentMinutesString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    
    
    // PickerView -  Years data
    
    yearArray = [[NSMutableArray alloc]init];
    
    
    for (int i = 2015; i <= 2020 ; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    
    // PickerView -  Months data
    
    
    monthArray = @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"];
    
    
    // PickerView -  Hours data
    
    
    hoursArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",
                   @"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23"];
    
    
    // PickerView -  Hours data
    
    minutesArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < 60; i++)
    {
        
        [minutesArray addObject:[NSString stringWithFormat:@"%02d",i]];
        
    }
    
    
    // PickerView -  days data
    
    DaysArray = [[NSMutableArray alloc]init];
    
    for (int i = 1; i <= 31; i++)
    {
        if(i < 10) {
            [DaysArray addObject:[NSString stringWithFormat:@"0%d",i]];
        }
        else {
            [DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
            
        }
        
    }
    
    
    // PickerView - Default Selection as per current Date
    
    [customPicker selectRow:[yearArray indexOfObject:currentyearString] inComponent:0 animated:YES];
    [customPicker selectRow:[monthArray indexOfObject:currentMonthString] inComponent:1 animated:YES];
    
    [customPicker selectRow:[DaysArray indexOfObject:currentDateString] inComponent:2 animated:YES];
    [customPicker selectRow:[hoursArray indexOfObject:currentHourString] inComponent:3 animated:YES];
    
    [customPicker selectRow:[minutesArray indexOfObject:currentMinutesString] inComponent:4 animated:YES];
    
    timeField.text = [NSString stringWithFormat:@"%@.%@.%@, %@:%@",[DaysArray objectAtIndex:[customPicker selectedRowInComponent:2]],[monthArray objectAtIndex:[customPicker selectedRowInComponent:1]],[yearArray objectAtIndex:[customPicker selectedRowInComponent:0]],[hoursArray objectAtIndex:[customPicker selectedRowInComponent:3]],[minutesArray objectAtIndex:[customPicker selectedRowInComponent:4]]];
    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)getPossibleStationsForText:(NSString *)text {
    DETrainJSONParser * __weak weakParser=trainJSONParser;
    [weakParser possibleStationsForText:[text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] withCompletion:^(NSMutableArray *mm){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setPossibleStations:mm];
        });
    }];
}

-(void)getDetailInformationFrom:(NSString *)from to:(NSString *)to time:(NSString *)time {
    DETrainJSONParser * __weak weakParser=trainJSONParser;
    [weakParser modelsFrom:[from stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  to:[to stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  time:[time stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]  withCompletion:^(NSMutableArray *mm) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushToDetailWithArray:mm];
        });
    }];
}

-(void)pushToDetailWithArray:(NSMutableArray *)array {
    DETrainDetailViewController *detailTrainVC = [storyboard instantiateViewControllerWithIdentifier:@"DETrainDetailViewController"];
    
    NSArray *dateComp = [timeField.text componentsSeparatedByString:@" "];
    detailTrainVC.informationArray = array;
    detailTrainVC.dateWithoutTime = dateComp[0];
    [self.navigationController pushViewController:detailTrainVC animated:YES];
}

-(void)setPossibleStations:(NSMutableArray *)array {
    possibleStations = array;
    [self.tableView reloadData];
}




-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if(textField.tag == 3) return NO;
    else return YES;
}


- (BOOL) textFieldShouldClear:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 3) {
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         customPicker.hidden = NO;
                         toolbarCancelDone.hidden = NO;
                         timeField.text = @"";
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    customPicker.hidden = NO;
    toolbarCancelDone.hidden = NO;
    timeField.text = @"";
    
    }
    
    return YES;
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    if(textField.tag <=2) {
        [self clearTableView];
    }
}

-(void)clearTableView {
    possibleStations = [NSMutableArray new];
    [self.tableView reloadData];
}
-(void)setEmptyView {
    UIView *emptyView = [[UIView alloc]init];
    emptyView.frame = self.tableView.frame;
    
    self.tableView.nxEV_emptyView = emptyView;
}


- (void)onSegmentChanged:(id)sender
{
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    selectedIndex = segment.selectedSegmentIndex;
    
    if(selectedIndex == 0) {
        fromField.text = @"Karlsruhe, Duale Hochschule";
        toField.text = @"";
 
        fromField.enabled = NO;
        toField.enabled = YES;
    }
    else {
       toField.text = @"Karlsruhe, Duale Hochschule";
       fromField.text = @"";

        fromField.enabled = YES;
        toField.enabled = NO;
    }
    
}

-(IBAction)search:(id)sender {
    if(fromField.text.length == 0 || toField.text.length == 0 || timeField.text.length == 0) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Suche fehlgeschlagen" andMessage:@"Bitte fülle alle Felder aus, um die Route zu suchen."];
        
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                              }];
        
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        
        [alertView show];
    }
    else {
        if(selectedIndex == 0) {
          [self getPossibleStationsForText:toField.text];
        }
        else {
            [self getPossibleStationsForText:fromField.text];

        }
    }
}


-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return possibleStations.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [possibleStations objectAtIndex:indexPath.row];
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    // iOS 7 and later
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //TODO: Andere API aufrufen und zu DetailView pushen
    if(selectedIndex == 0) {
        [self getDetailInformationFrom:fromField.text to:[possibleStations objectAtIndex:indexPath.row] time:timeField.text];
    }
    else {
        [self getDetailInformationFrom:[possibleStations objectAtIndex:indexPath.row] to:toField.text time:timeField.text];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if (component == 0)
    {
        selectedYearRow = (int)row;
        [customPicker reloadAllComponents];
    }
    else if (component == 1)
    {
        selectedMonthRow = (int)row;
        [customPicker reloadAllComponents];
    }
    else if (component == 2)
    {
        selectedDayRow = (int)row;
        
        [customPicker reloadAllComponents];
        
    }
    
}


#pragma mark - UIPickerViewDatasource

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
    
    // Custom View created for each component
    
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
        pickerLabel.textColor = [UIColor whiteColor];
        
    }
    
    
    
    if (component == 0)
    {
        pickerLabel.text =  [yearArray objectAtIndex:row]; // Year
    }
    else if (component == 1)
    {
        pickerLabel.text =  [monthArray objectAtIndex:row];  // Month
    }
    else if (component == 2)
    {
        pickerLabel.text =  [DaysArray objectAtIndex:row]; // Date
        
    }
    else if (component == 3)
    {
        pickerLabel.text =  [hoursArray objectAtIndex:row]; // Hours
    }
    else
    {
        pickerLabel.text =  [minutesArray objectAtIndex:row]; // Mins
    }
    
    return pickerLabel;
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 5;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        return [yearArray count];
        
    }
    else if (component == 1)
    {
        return [monthArray count];
    }
    else if (component == 2)
    { // day
        
        if (firstTimeLoad)
        {
            if (currentMonth == 1 || currentMonth == 3 || currentMonth == 5 || currentMonth == 7 || currentMonth == 8 || currentMonth == 10 || currentMonth == 12)
            {
                return 31;
            }
            else if (currentMonth == 2)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
            }
            else
            {
                return 30;
            }
            
        }
        else
        {
            
            if (selectedMonthRow == 0 || selectedMonthRow == 2 || selectedMonthRow == 4 || selectedMonthRow == 6 || selectedMonthRow == 7 || selectedMonthRow == 9 || selectedMonthRow == 11)
            {
                return 31;
            }
            else if (selectedMonthRow == 1)
            {
                int yearint = [[yearArray objectAtIndex:selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }
                else
                {
                    return 28; // or return 29
                }
                
                
                
            }
            else
            {
                return 30;
            }
            
        }
        
        
    }
    else if (component == 3)
    { // hour
        
        return 24;
        
    }
    else
    { // min
        return 60;
    }
    
}






- (IBAction)actionCancel:(id)sender
{
    if(timeField.text.length > 0) {
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         customPicker.hidden = YES;
                         toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];
    }
    else {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Datum setzen" andMessage:@"Du musst ein Datum auswählen, um nach einer Route zu suchen."];
        
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                              }];
        
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        
        [alertView show];
    }
    
    
}

- (IBAction)actionDone:(id)sender
{
    
    
    timeField.text = [NSString stringWithFormat:@"%@.%@.%@, %@:%@",[DaysArray objectAtIndex:[customPicker selectedRowInComponent:2]],[monthArray objectAtIndex:[customPicker selectedRowInComponent:1]],[yearArray objectAtIndex:[customPicker selectedRowInComponent:0]],[hoursArray objectAtIndex:[customPicker selectedRowInComponent:3]],[minutesArray objectAtIndex:[customPicker selectedRowInComponent:4]]];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         customPicker.hidden = YES;
                         toolbarCancelDone.hidden = YES;
                         
                         
                     }
                     completion:nil];
     
     
}



-(void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
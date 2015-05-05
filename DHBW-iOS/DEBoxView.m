//
//  DEBoxView.m
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "DEBoxView.h"
#import "DETrainCell.h"
#import "DEMensaCell.h"
#import "DECalendarCell.h"
#import "DEBoxNewsCell.h"
#import "TrainModel.h"
#import "FoodModel.h"
#import "StuvNewsModel.h"
#import "DHBWNewsModel.h"
#import "UIColor+Expanded.h"
#import "DECalendarModel.h"

#import "DEDHBWNewsDetailViewController.h"
#import "DEStuvNewsDetailViewController.h"
#import "DECalendarViewController.h"

#import "DETrainViewController.h"
#import "UITableView+NXEmptyView.h"
#import <SIAlertView/SIAlertView.h>

@implementation DEBoxView

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
       
        self = [[[NSBundle mainBundle] loadNibNamed:@"DEBoxView"
                                              owner:self
                                            options:nil] lastObject];
        [self setFrame:CGRectMake(frame.origin.x,
                                  frame.origin.y,
                                  frame.size.width,
                                  frame.size.height)];
        
        self.backgroundColor=[UIColor whiteColor];
        self.layer.masksToBounds = NO;
        //self.layer.borderColor = [UIColor whiteColor].CGColor;
        //self.layer.borderWidth = 1.0f;
        self.layer.contentsScale = [UIScreen mainScreen].scale;
        //self.layer.shadowOpacity = 0.75f;
        //self.layer.shadowRadius = 5.0f;
        //self.layer.shadowOffset = CGSizeZero;
        //self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        
        /*CALayer *bottomBorder = [CALayer layer];
        
        bottomBorder.frame = CGRectMake(0.0f, 199.0f, self.frame.size.width, 1.0f);
        
        bottomBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
        
        [self.layer addSublayer:bottomBorder];
        */
        self.dataArray = [[NSMutableArray alloc]init];
        self.entriesForToday = [NSMutableArray new];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
            storyboard =
            [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
        } else {
            storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        }
        headerStrings = @[@"S-Bahn (von DH)", @"Mensa", @"Kalender", @"DHBW News", @"Stuv News"];
		self.tableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
		[self setEmptyView];
	}
    
    return self;
}

-(void)indexWasSet {
    if(self.index>=3) {
        [self setupDataSource];
    }
}

-(void)setHeaderLabelText {
    [self.headerLabel setText:headerStrings[(NSUInteger) self.index]];
}

-(void)setEmptyView {
    // Display a message when the table is empty
    UIView *emptyView = [[UIView alloc]init];
    emptyView.frame = self.frame;
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.bounds.size.height/2-20, self.bounds.size.width, 40)];    
    messageLabel.text = @"Keine Informationen vefügbar.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    // [messageLabel sizeToFit];
    [emptyView addSubview:messageLabel];
    
    self.tableView.nxEV_emptyView = emptyView;
}

-(void)refresh {
    if(self.index>=3) {
        [self setupDataSource];
    }
    else if (self.index == 2) {
        [self getAllEntriesForDate:[NSDate date]];
    }
    
    [self.tableView reloadData];
}

- (void) setupDataSource
{
    NSMutableArray *sortedDateArray;
    NSMutableArray *unsortedDateArray = [[NSMutableArray alloc]init];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    for(int i = 0;i<self.dataArray.count;i++) {
        [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
        [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"us_US"]];
        NSDate *date = [dateFormatter dateFromString:[self.dataArray[(NSUInteger) i] published]];
        [unsortedDateArray addObject:date];
    }
    sortedDateArray =[[NSMutableArray alloc]initWithArray:[unsortedDateArray sortedArrayUsingComparator:^(id obj1, id obj2){
        return [obj2 compare:obj1];
    }]];
    self.tableViewSections = [NSMutableArray arrayWithCapacity:0];
    self.tableViewDates = [NSMutableDictionary dictionaryWithCapacity:0];
    self.tableViewCells = [NSMutableDictionary dictionaryWithCapacity:0];

    NSCalendar* calendar = [NSCalendar currentCalendar];
    dateFormatter.locale = [NSLocale currentLocale];
    dateFormatter.timeZone = calendar.timeZone;
    [dateFormatter setDateFormat:@"MMMM YYYY"];
    
    NSUInteger dateComponents = NSCalendarUnitYear | NSCalendarUnitMonth;
    NSInteger previousYear = -1;
    NSInteger previousMonth = -1;
    NSMutableArray* tableViewDatesForSection = nil;
    NSMutableArray* tableViewCellsForSection = nil;

    for (int i = 0;i<sortedDateArray.count;i++)
    {
        NSDate* date = sortedDateArray[(NSUInteger) i];
        NSDateComponents* components = [calendar components:(NSCalendarUnit) dateComponents fromDate:date];
        NSInteger year = [components year];
        NSInteger month = [components month];
        if (year != previousYear || month != previousMonth)
        {
            NSString* sectionHeading = [dateFormatter stringFromDate:date];
            [self.tableViewSections addObject:sectionHeading];
            tableViewDatesForSection = [NSMutableArray arrayWithCapacity:0];
            tableViewCellsForSection = [NSMutableArray arrayWithCapacity:0];

            self.tableViewDates[sectionHeading] = tableViewDatesForSection;
            self.tableViewCells[sectionHeading] = tableViewCellsForSection;

            previousYear = year;
            previousMonth = month;
        }
        [tableViewDatesForSection addObject:date];
        [tableViewCellsForSection addObject:self.dataArray[(NSUInteger) i]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
        [UIView animateWithDuration:0.3
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self setBackgroundColor:[UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000]];
                         }
                         completion:nil];
}
    

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

        [UIView animateWithDuration:0.4
                              delay:0
                            options:(UIViewAnimationOptionAllowUserInteraction)
                         animations:^{
                             [self setBackgroundColor:[UIColor whiteColor]];
                         }
                         completion:nil ];

}

-(void)animateClockRefresh {
    if(self.index == 2) { //calendar
        [self.tableView reloadData];
    }
}

-(NSMutableArray *)getAllEntriesForDate:(NSDate *)date {
    [self.entriesForToday removeAllObjects];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    for(DECalendarModel *model in self.dataArray) {
        NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date];
        NSDateComponents* comp2 = [calendar components:unitFlags fromDate:model.startDateTime];
        
        if([comp1 day]   == [comp2 day] &&
           [comp1 month] == [comp2 month] &&
           [comp1 year]  == [comp2 year]) {
            [self.entriesForToday addObject:model];
        }
    }
    return self.entriesForToday;
}


#pragma mark -
#pragma mark UITableView Delegate&Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.index >= 3) { //NewsCell
        return self.tableViewSections.count;
    }
    else return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.index>=3) {
    id key = self.tableViewSections[(NSUInteger) section];
    NSArray* tableViewCellsForSection = self.tableViewDates[key];
    return tableViewCellsForSection.count;
    }
    else if (self.index == 2) { return self.entriesForToday.count; }
    else return self.dataArray.count;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.tableViewSections[(NSUInteger) section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(self.index == 0) {
            static NSString *identifier = @"DETrainCell";
            DETrainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"DETrainCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DETrainCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DETrainCell"];
            }

            
            cell.destinationLabel.text = [self.dataArray[(NSUInteger) indexPath.row] destination];
            cell.colorView.backgroundColor = [UIColor colorWithHexString:[self.dataArray[(NSUInteger) indexPath.row] lineColor]];
            cell.timeLabel.text = [self.dataArray[(NSUInteger) indexPath.row] time];
            cell.lineLabel.text = [NSString stringWithFormat:@"Linie %@",[self.dataArray[(NSUInteger) indexPath.row] line]];
            return cell;
        }
else if (self.index == 1) {
            static NSString *identifier = @"DEMensaCell";
            DEMensaCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"DEMensaCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DEMensaCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DEMensaCell"];
            }

            cell.foodLabel.text = [self.dataArray[(NSUInteger) indexPath.row] name];
            if([self.dataArray[(NSUInteger) indexPath.row] student_price] == nil) {
            cell.priceLabel.text = [NSString stringWithFormat:@"--€"];
            }
            else {
                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
                [fmt setPositiveFormat:@"##0.00"];
                cell.priceLabel.text = [NSString stringWithFormat:@"%@ €",[fmt stringFromNumber:[self.dataArray[(NSUInteger) indexPath.row] student_price]]];
            }
            cell.condimentsLabel.text = [self.dataArray[(NSUInteger) indexPath.row] condiments];
            return cell;

            
}else if (self.index == 2) {
            static NSString *identifier = @"DECalendarCell";
            DECalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"DECalendarCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DECalendarCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DECalendarCell"];
            }
    
    cell.subjectLabel.text = [[self.entriesForToday objectAtIndex:indexPath.row]subject];
    cell.tutorLabel.text = [[self.entriesForToday objectAtIndex:indexPath.row]tutor];
    cell.roomLabel.text = [[self.entriesForToday objectAtIndex:indexPath.row]room];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    
 cell.timeLabel.text = [NSString stringWithFormat:@"%@-%@",[dateFormatter stringFromDate:[[self.entriesForToday objectAtIndex:indexPath.row]startDateTime]],[dateFormatter stringFromDate:[[self.entriesForToday objectAtIndex:indexPath.row]endDateTime]]];    [dateFormatter setDateFormat:@"hh:mm"];
    NSString *dateString = [dateFormatter stringFromDate:[[self.entriesForToday objectAtIndex:indexPath.row]startDateTime]];
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSInteger second = [components second];
    [cell setClockViewWithHour:0 andMinute:0 andSecond:0 withAnimation:NO];
    [cell setClockViewWithHour:hour andMinute:minute andSecond:second withAnimation:YES];
    
    if([[self.entriesForToday objectAtIndex:indexPath.row]isExam]) {
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
else if (self.index == 3) {

    
            static NSString *identifier = @"DEBoxNewsCell";
            DEBoxNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"DEBoxNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DEBoxNewsCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DEBoxNewsCell"];
            }

    id key = self.tableViewSections[(NSUInteger) indexPath.section];
    NSArray* tableViewCellsForSection = self.tableViewCells[key];
    
            cell.newsTitleLabel.text = [tableViewCellsForSection[(NSUInteger) indexPath.row] title];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
            NSDate *date = [dateFormatter dateFromString:[tableViewCellsForSection[(NSUInteger) indexPath.row] published]];
            
            [dateFormatter setDateFormat:@"dd"];
            cell.monthdayLabel.text = [dateFormatter stringFromDate:date];
            [dateFormatter setDateFormat:@"HH:mm a"];
            cell.timeLabel.text = [dateFormatter stringFromDate:date];
            [dateFormatter setDateFormat:@"EEEE"];
            cell.weekdayLabel.text = [dateFormatter stringFromDate:date];
            return cell;

        }
else {
            static NSString *identifier = @"DEBoxNewsCell";
            DEBoxNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                [tableView registerNib:[UINib nibWithNibName:@"DEBoxNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DEBoxNewsCell"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"DEBoxNewsCell"];
            }
    
    id key = self.tableViewSections[(NSUInteger) indexPath.section];
    NSArray* tableViewCellsForSection = self.tableViewCells[key];
    

            
            
            cell.newsTitleLabel.text = [tableViewCellsForSection[(NSUInteger) indexPath.row] title];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];
            NSDate *date = [dateFormatter dateFromString:[tableViewCellsForSection[(NSUInteger) indexPath.row] published]];
            
            [dateFormatter setDateFormat:@"dd"];
            cell.monthdayLabel.text = [dateFormatter stringFromDate:date];
            [dateFormatter setDateFormat:@"HH:mm a"];
            cell.timeLabel.text = [dateFormatter stringFromDate:date];
            [dateFormatter setDateFormat:@"EEEE"];
            cell.weekdayLabel.text = [dateFormatter stringFromDate:date];
            return cell;

            
        }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(self.index == 0) {
        DETrainViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"DETrainViewController"];
        detailVC.trainArray = self.dataArray;
        detailVC.to = [[self.dataArray objectAtIndex:indexPath.row]destination];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if(self.index == 1) {
        SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Speise" andMessage:[self.dataArray[(NSUInteger) indexPath.row] name]];
        
        [alertView addButtonWithTitle:@"OK"
                                 type:SIAlertViewButtonTypeDefault
                              handler:^(SIAlertView *alert) {
                              }];
        
        alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
        
        [alertView show];
    }
    else if (self.index == 2) {
        DECalendarViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"DECalendarViewController"];
        detailVC.calArray = self.dataArray;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if(self.index == 3) {
        DEDHBWNewsDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"DEDHBWNewsDetailViewController"];
        detailVC.startIndex = (NSUInteger) indexPath.row;
        detailVC.articles = self.dataArray;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else if(self.index == 4) {
        DEStuvNewsDetailViewController *detailVC = [storyboard instantiateViewControllerWithIdentifier:@"DEStuvNewsDetailViewController"];
        detailVC.startIndex = (NSUInteger) indexPath.row;
        detailVC.articles = self.dataArray;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}



- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}



@end

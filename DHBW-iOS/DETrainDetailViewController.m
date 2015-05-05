//
//  DETrainDetailViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 13.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DETrainDetailViewController.h"
#import "DETrainDetailModel.h"
#import "DETrainTimelineViewController.h"

@interface DETrainDetailViewController ()

@end

@implementation DETrainDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        storyboard =
        [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.informationArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"DetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [[self.informationArray objectAtIndex:indexPath.row]interval];
    
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
    DETrainTimelineViewController *stationVC = [storyboard instantiateViewControllerWithIdentifier:@"DETrainTimelineViewController"];
    stationVC.sectionArray = [[self.informationArray objectAtIndex:indexPath.row]sectionArray];
    stationVC.from = [[self.informationArray objectAtIndex:indexPath.row]from];
    stationVC.to = [[self.informationArray objectAtIndex:indexPath.row]to];
    
    NSString *interval = [[self.informationArray objectAtIndex:indexPath.row]interval];
    
     NSString *startDateString = [NSString stringWithFormat:@"%@ %@",self.dateWithoutTime,[interval componentsSeparatedByString:@" - "][0]];
    
    NSString *endDateString = [NSString stringWithFormat:@"%@ %@",self.dateWithoutTime,[interval componentsSeparatedByString:@" - "][1]];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    NSDate *startDate = [dateFormatter dateFromString:startDateString];
    NSDate *endDate = [dateFormatter dateFromString:endDateString];
    
    stationVC.startDate = startDate;
    stationVC.endDate = endDate;
    
    [self.navigationController pushViewController:stationVC animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

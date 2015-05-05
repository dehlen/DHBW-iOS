//
//  DEAlarmViewController.h
//  DHBW-iOS
//
//  Created by David Ehlen on 11.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DECalendarModel.h"
#import "DKCircularSlider.h"

@interface DEAlarmViewController : UIViewController {
    NSUInteger selectedIndex;
}

@property (nonatomic,strong) DECalendarModel *calEntry;
@property (nonatomic,retain) DKCircularSlider *guidedCSlider;
@property (nonatomic,strong) NSMutableArray *alarmTimeMinutes;
@property (nonatomic,strong) NSArray *sliderTextValues;

@end

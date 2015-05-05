//
//  DECalendarCell.h
//  DHBW-iOS
//
//  Created by David Ehlen on 06.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMAnalogClockView.h"

@interface DECalendarCell : UITableViewCell <BEMAnalogClockDelegate>

@property (nonatomic,strong) IBOutlet UILabel *subjectLabel;
@property (nonatomic,strong) IBOutlet UILabel *tutorLabel;
@property (nonatomic,strong) IBOutlet UILabel *roomLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;
@property (nonatomic,strong) IBOutlet BEMAnalogClockView *timeView;


-(void)setClockViewWithHour:(NSInteger)hour andMinute:(NSInteger)minute andSecond:(NSInteger)second withAnimation:(BOOL)animate;
@end

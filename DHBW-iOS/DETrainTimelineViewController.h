//
//  DETrainTimelineViewController.h
//  DHBW-iOS
//
//  Created by David Ehlen on 14.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDHTimerControl.h"

@interface DETrainTimelineViewController : UIViewController
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *fromLabel;
    IBOutlet UILabel *toLabel;
    IBOutlet UILabel *timeLabel;
    BOOL showEnd;
}

@property (nonatomic,strong) NSMutableArray *sectionArray;
@property (nonatomic,copy) NSString *from;
@property (nonatomic,copy) NSString *to;
@property (nonatomic, strong) IBOutlet DDHTimerControl *timerControl;
@property (nonatomic,strong) NSDate *endDate;
@property (nonatomic,strong) NSDate *startDate;


@end

//
//  DETrainTimelineViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 14.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DETrainTimelineViewController.h"
#import "DESectionModel.h"
#import "TimeLineViewControl.h"
#import "DEStationModel.h"

@interface DETrainTimelineViewController ()

@end

@implementation DETrainTimelineViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTimeControl];
    NSMutableArray *stationNames = [NSMutableArray new];
    NSMutableArray *timeArray = [NSMutableArray new];
    showEnd = true;
    fromLabel.text = [self.from stringByReplacingOccurrencesOfString:@"%20"
                                                          withString:@" "];
    toLabel.text = [self.to stringByReplacingOccurrencesOfString:@"%20"
                                                        withString:@" "];
    
    for(int i = 0;i<self.sectionArray.count;i++) {
        DESectionModel *section = self.sectionArray[i];
        [stationNames addObject:section.info];
            [timeArray addObject:@""];
            
                [stationNames addObject:section.from];
                NSArray *footPathTimes = [section.interval componentsSeparatedByString:@" - "];
                [timeArray addObject:footPathTimes[0]];
            
          
               
            for(DEStationModel *station in section.stationsArray) {
                [stationNames addObject:station.name];
                [timeArray addObject:station.time];
            }
            [stationNames addObject:section.to];
            [timeArray addObject:footPathTimes[1]];

        
    }
    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:timeArray andTimeDescriptionArray:stationNames andCurrentStatus:(int)stationNames.count andFrame:CGRectMake((self.view.frame.size.width/2)-150.0, 10.0, 300.0, self.view.bounds.size.height)];
    [scrollView addSubview:timeline];
    scrollView.contentSize = CGSizeMake(timeline.frame.size.width,timeline.viewheight+50.0);
}

-(void)setupTimeControl {
    _timerControl = [DDHTimerControl timerControlWithType:DDHTimerTypeEqualElements];
    _timerControl.translatesAutoresizingMaskIntoConstraints = YES;
    _timerControl.color = [UIColor orangeColor];
    _timerControl.highlightColor = [UIColor redColor];
    _timerControl.minutesOrSeconds = 0;
    _timerControl.titleLabel.text = @"min";
    _timerControl.userInteractionEnabled = YES;
    _timerControl.frame = CGRectMake(self.view.frame.size.width-116, 63, 100, 100);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [_timerControl addGestureRecognizer:tapGestureRecognizer];
    [self.view addSubview:_timerControl];
    
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTimer:) userInfo:nil repeats:YES];

}

- (void) handleTap: (UITapGestureRecognizer *)recognizer
{
    showEnd = !showEnd;
    if(showEnd) {
        timeLabel.text = @"Ende";
    }
    else timeLabel.text = @"Start";
}

- (void)changeTimer:(NSTimer*)timer {
    NSTimeInterval timeInterval;
    NSDate *currentDateWithOffset = [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone localTimeZone] secondsFromGMT]];
    if(showEnd) {
        timeInterval = [self.endDate timeIntervalSinceDate:currentDateWithOffset];
    }
    else {
        timeInterval = [self.startDate timeIntervalSinceDate:currentDateWithOffset];
    }
    
    if(timeInterval > 0) {
    self.timerControl.minutesOrSeconds = (NSInteger)(timeInterval/60.0f);
    }
    else {
        self.timerControl.minutesOrSeconds = 0;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

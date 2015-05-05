//
//  DECalendarCell.m
//  DHBW-iOS
//
//  Created by David Ehlen on 06.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DECalendarCell.h"

@implementation DECalendarCell

- (void)awakeFromNib {
    self.timeView.setTimeViaTouch = NO;
    self.timeView.enableGraduations = NO;
    self.timeView.realTime = NO;
    self.timeView.currentTime = NO;
    self.timeView.faceBackgroundAlpha = 0;
    self.timeView.enableShadows = NO;
    self.timeView.borderColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    self.timeView.hourHandColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    self.timeView.minuteHandColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    self.timeView.borderWidth = 1;
    self.timeView.hourHandWidth = 1.0;
    self.timeView.hourHandLength = 10;
    self.timeView.minuteHandWidth = 1.0;
    self.timeView.minuteHandLength = 15;
    self.timeView.minuteHandOffsideLength = 0;
    self.timeView.hourHandOffsideLength = 0;
    self.timeView.secondHandAlpha = 0;
    self.timeView.delegate = self;
    self.timeView.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setClockViewWithHour:(NSInteger)hour andMinute:(NSInteger)minute andSecond:(NSInteger)second withAnimation:(BOOL)animate {
    self.timeView.hours = hour;
    self.timeView.minutes = minute;
    self.timeView.seconds = second;
    [self.timeView updateTimeAnimated:animate];
}

@end

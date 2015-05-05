//
//  DEBoxNewsCell.h
//  DHBW-iOS
//
//  Created by David Ehlen on 06.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEBoxNewsCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *newsTitleLabel;
@property (nonatomic,strong) IBOutlet UILabel *weekdayLabel;
@property (nonatomic,strong) IBOutlet UILabel *monthdayLabel;
@property (nonatomic,strong) IBOutlet UILabel *timeLabel;

@end

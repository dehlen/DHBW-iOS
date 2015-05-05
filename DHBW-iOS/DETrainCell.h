//
//  DETableViewCell.h
//  DHBW-iOS
//
//  Created by David Ehlen on 18.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DETrainCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *destinationLabel;
@property (nonatomic,strong) IBOutlet UIView *colorView;
@property (nonatomic, strong) IBOutlet UILabel *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel *lineLabel;



@end

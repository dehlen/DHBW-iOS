//
//  DETrainDetailViewController.h
//  DHBW-iOS
//
//  Created by David Ehlen on 13.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeLineViewControl.h"

@interface DETrainDetailViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    UIStoryboard *storyboard;
}

@property (nonatomic,strong) NSMutableArray *informationArray;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSString *dateWithoutTime;
@end

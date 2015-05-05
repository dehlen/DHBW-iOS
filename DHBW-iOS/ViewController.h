//
//  ViewController.h
//  DHBW-iOS
//
//  Created by David Ehlen on 17.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEJSONParser.h"
#import "DEBoxView.h"
#import "DEICSParser.h"

@interface ViewController : UIViewController<UIScrollViewDelegate,UITableViewDataSource, UITableViewDelegate> {
    NSArray *menuLabels;
    NSArray *menuTableImages;
    UIStoryboard *storyboard;
	DEJSONParser *parser;
    DEICSParser *icsParser;
    UIPageControl *pageControl;
    UITapGestureRecognizer *tapGesture;
    
}

@property (nonatomic, strong) UITableView *menuTable;
@property (nonatomic, strong) NSMutableArray *boxCollection;
@property (nonatomic, strong) UIScrollView *boxScrollView;

extern NSString *const kAPIEndpointHost;
extern NSString *const kAPIEndpointTrain;
extern NSString *const kAPIEndpointCafeteriaToday;
extern NSString *const kAPIEndpointCalendarToday;
extern NSString *const kAPIEndpointDHBWNews;
extern NSString *const kAPIEndpointStuvNews;

@end


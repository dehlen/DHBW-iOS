//
//  DEBoxView.h
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface DEBoxView : UIView <UITableViewDataSource,UITableViewDelegate> {
    UIStoryboard *storyboard;
    NSArray *headerStrings;
    NSIndexPath *clickedIndexPath;
    
}
@property (nonatomic,strong) IBOutlet UIView *separatorView;
@property (nonatomic,strong) IBOutlet UILabel *headerLabel;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *entriesForToday;

@property(retain) NSMutableArray* tableViewSections;
@property(retain) NSMutableDictionary* tableViewDates;
@property(retain) NSMutableDictionary* tableViewCells;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UINavigationController *navigationController;

-(void)animateClockRefresh;
-(void)indexWasSet;
-(void)setHeaderLabelText;
-(void)refresh;
@end


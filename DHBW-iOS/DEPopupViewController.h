//
//  DEPopupViewController.h
//  DHBW-iOS
//
//  Created by David Ehlen on 08.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEPopupViewController : UIViewController<UITableViewDataSource,UITabBarDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *condimentsArray;
@property (nonatomic,strong) NSMutableArray *sensitizerArray;

@end

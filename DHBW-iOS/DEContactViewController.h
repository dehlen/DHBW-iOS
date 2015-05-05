//
//  DEContactViewController.h
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DEJSONParser.h"

@interface DEContactViewController : UIViewController <UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource> {
    IBOutlet UISearchBar *tableSearchBar;
	DEJSONParser *parser;
    UIRefreshControl *refreshControl;
}
@property(nonatomic,strong) NSMutableArray *contactArray;
@property(nonatomic,strong) NSMutableArray *originalData;

@property(nonatomic,strong) IBOutlet UITableView *tableView;


@end

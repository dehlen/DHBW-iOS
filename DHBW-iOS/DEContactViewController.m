//
//  DEContactViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "DEContactViewController.h"
#import "DEContactModel.h"
#import "DEContactCell.h"
#import "AppDelegate.h"
#import "UITableView+NXEmptyView.h"

@interface DEContactViewController ()
@end

@implementation DEContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.contactArray = [[NSMutableArray alloc]init];
    self.originalData = [[NSMutableArray alloc]init];
	parser = [[DEJSONParser alloc]init];
    [self loadContacts];
    self.tableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    [self setEmptyView];
    
    
     refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(loadContacts) forControlEvents:UIControlEventValueChanged];
    
    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.title = @"Kontakte";
}


-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setEmptyView {
    // Display a message when the table is empty
    UIView *emptyView = [[UIView alloc]init];
    emptyView.frame = self.tableView.frame;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyView.frame.size.height/2, emptyView.frame.size.width, 40)];
    
    messageLabel.text = @"Keine Informationen vefügbar.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    // [messageLabel sizeToFit];
    [emptyView addSubview:messageLabel];
    
    self.tableView.nxEV_emptyView = emptyView;
}


-(void)loadContacts {
    [refreshControl beginRefreshing];
    DEJSONParser * __weak weakParser=parser;
    [weakParser modelsFromURL:[NSURL URLWithString:kAPIEndpointAllContacts] forClass:[DEContactModel class] withCompletion:^(NSMutableArray *mm){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setLoadedContacts:mm];
        });
    }];

}

-(void)setLoadedContacts:(NSMutableArray *)array {
    self.contactArray = array;
    [self.originalData addObjectsFromArray:self.contactArray];
    [self.tableView reloadData];
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *results = [self doSearch:searchText];
    [tableSearchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
    [self.contactArray removeAllObjects];
    [self.contactArray addObjectsFromArray:results];
    [self.tableView reloadData];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [tableSearchBar setShowsCancelButton:YES animated:YES];
    self.tableView.allowsSelection = NO;
    self.tableView.scrollEnabled = NO;
    if ([searchBar.text isEqualToString:@""]) {
        [self.contactArray removeAllObjects];
        [self.contactArray addObjectsFromArray:self.originalData];
        [self.tableView reloadData];
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    tableSearchBar.text=@"";
    
    [tableSearchBar setShowsCancelButton:NO animated:YES];
    [tableSearchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    [self.contactArray removeAllObjects];
    [self.contactArray addObjectsFromArray:self.originalData];
    [self.tableView reloadData];

}


-(NSMutableArray *)doSearch:(NSString *)searchString {
    NSMutableArray *searchResults = [[NSMutableArray alloc]init];
    
    if(searchString == nil || [searchString isEqualToString:@""]) {
        return self.originalData;
    }
    else {
        for(DEContactModel *model in self.originalData) {
            NSArray *bothNames = [model.name componentsSeparatedByString:@", "];
            for(NSString *string in bothNames) {
                
                if ([string.lowercaseString containsString:searchString.lowercaseString]) {
                    [searchResults addObject:model];
                }
            }
        }
    }
    
    return searchResults;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    NSMutableArray *results = [self doSearch:tableSearchBar.text];
    
    [tableSearchBar setShowsCancelButton:NO animated:YES];
    [tableSearchBar resignFirstResponder];
    self.tableView.allowsSelection = YES;
    self.tableView.scrollEnabled = YES;
    
    [self.contactArray removeAllObjects];
    [self.contactArray addObjectsFromArray:results];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.contactArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DEContactCell";
    DEContactCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DEContactCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DEContactCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DEContactCell"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    // iOS 7 and later
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];

    
    cell.nameLabel.text = [self.contactArray[(NSUInteger) indexPath.row] name];
    cell.functionLabel.text = [self.contactArray[(NSUInteger) indexPath.row] function];
    cell.roomLabel.text = [self.contactArray[(NSUInteger) indexPath.row] room];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",[self.contactArray[(NSUInteger) indexPath.row] telephone]]]];
}


@end

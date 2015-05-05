#import "DEDHBWNewsViewController.h"
#import "DHBWNewsModel.h"
#import "DEDHBWNewsDetailViewController.h"
#import "DENewsCell.h"
#import "UITableView+NXEmptyView.h"
#import "DEJSONParser.h"
#import "AppDelegate.h"
#import "NSString+HTML.h"


@interface DEDHBWNewsViewController() 
@end

@implementation DEDHBWNewsViewController

-(void)viewDidLoad {
	[super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        storyboard =
        [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    tableView.nxEV_hideSeparatorLinesWhenShowingEmptyView = YES;
    [self setEmptyView];

     refreshControl = [[UIRefreshControl alloc]init];
    [tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];

    UIImage *buttonImage = [UIImage imageNamed:@"back"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    buttonImage = [buttonImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    button.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    
    [button setImage:buttonImage forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
    
    self.navigationItem.title = @"DHBW-News";

}


-(void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshTable {
    [refreshControl beginRefreshing];

    DEJSONParser *parser = [[DEJSONParser alloc]init];
    DEJSONParser * __weak weakParser=parser;
    
    [weakParser modelsFromURL:[NSURL URLWithString:kAPIEndpointDHBWNews] forClass:[DHBWNewsModel class] withCompletion:^(NSMutableArray *mm){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNewData:mm];
                    
                });
            }];

}

-(void)setNewData:(NSMutableArray *)array {
    self.dhbwNews = array;
    [tableView reloadData];
    [refreshControl endRefreshing];
}

-(void)setEmptyView {
    // Display a message when the table is empty
    UIView *emptyView = [[UIView alloc]init];
    emptyView.frame = tableView.frame;
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyView.frame.size.height/2, emptyView.frame.size.width, 40)];
    
    messageLabel.text = @"Keine Informationen vefügbar.";
    messageLabel.textColor = [UIColor blackColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:20];
    // [messageLabel sizeToFit];
    [emptyView addSubview:messageLabel];
    
    tableView.nxEV_emptyView = emptyView;
}



#pragma mark -
#pragma mark UITableView 

- (CGFloat)tableView:(UITableView *)uiTableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (CGFloat)tableView:(UITableView *)uiTableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableV numberOfRowsInSection:(NSInteger)section {
    return [self.dhbwNews count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableVie cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DENewsCell";
    DENewsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DENewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DENewsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DENewsCell"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    // iOS 7 and later
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];

    cell.titleLabel.text = [self.dhbwNews[(NSUInteger) indexPath.row] title];
    cell.publishedLabel.text = [self.dhbwNews[(NSUInteger) indexPath.row] published];
    cell.sneakLabel.text = [[self.dhbwNews[(NSUInteger) indexPath.row] descr]stringByConvertingHTMLToPlainText];

    return cell;
}

-(void)tableView:(UITableView *)tableV didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DEDHBWNewsDetailViewController *detailNewsVC = [storyboard instantiateViewControllerWithIdentifier:@"DEDHBWNewsDetailViewController"];
    detailNewsVC.articles = self.dhbwNews;
    detailNewsVC.startIndex = (NSUInteger) indexPath.row;
	[self.navigationController pushViewController:detailNewsVC animated:YES];
    [tableV deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
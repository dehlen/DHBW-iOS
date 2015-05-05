//
//  ViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 17.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import "ViewController.h"

#import <KVNProgress/KVNProgress.h>

#import "DEContactViewController.h"
#import "DERoomViewController.h"
#import "DECafeteriaViewController.h"
#import "DEDHBWNewsViewController.h"
#import "DEStuvNewsViewController.h"
#import "DETrainViewController.h"
#import "DECalendarViewController.h"

#import "TrainModel.h"
#import "FoodModel.h"
#import "StuvNewsModel.h"
#import "DHBWNewsModel.h"

#import "AppDelegate.h"
#import "DEMenuTableCell.h"

#import "InAPPWebViewController.h"
#import "DESettingsViewController.h"


@interface ViewController () 

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==UIUserInterfaceIdiomPad) {
        storyboard =
        [UIStoryboard storyboardWithName:@"Main-iPad" bundle:nil];
    } else {
        storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    self.title = @"Heute";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000]};
    
    menuTableImages = @[[UIImage imageNamed:@"canteen"], [UIImage imageNamed:@"calendar"], [UIImage imageNamed:@"train"], [UIImage imageNamed:@"newspaper"], [UIImage imageNamed:@"contact"], [UIImage imageNamed:@"newspaper"], [UIImage imageNamed:@"dualis"], [UIImage imageNamed:@"room"], [UIImage imageNamed:@"moodle"], [UIImage imageNamed:@"settings"]];
    parser = [[DEJSONParser alloc]init];
    icsParser = [[DEICSParser alloc]init];
    
    [self setupUI];
    menuLabels = @[@"Mensa", @"Kalender", @"S-Bahn", @"Stuv News", @"Kontakte", @"DHBW News", @"Dualis", @"Raumsuche", @"Else", @"Einstellungen"];
    
    self.navigationController.navigationBar.translucent = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissWithError:)
                                                 name:@"ErrorLoading"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dismissWithSuccess:)
                                                 name:@"SuccessLoading"
                                               object:nil];

    
    [KVNProgress show];
    
    [KVNProgress showWithStatus:@"Laden"];
    

}


-(void)setupUI {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.bounds.size.width, 300)];

    self.boxScrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,64,self.view.bounds.size.width,200)];
    self.boxScrollView.contentSize = CGSizeMake(5*self.view.bounds.size.width, self.boxScrollView.frame.size.height);
    [self.boxScrollView setBackgroundColor:[UIColor lightGrayColor]];
    self.boxScrollView.pagingEnabled = YES;
    self.boxScrollView.showsVerticalScrollIndicator = NO;
    self.boxScrollView.showsHorizontalScrollIndicator = NO;
    self.boxScrollView.delegate = self;
    self.boxCollection = [[NSMutableArray alloc]init];
    for(int i = 0;i<5;i++) {
        DEBoxView *box = [[DEBoxView alloc]initWithFrame:CGRectMake(i*self.view.bounds.size.width, 0, self.view.bounds.size.width,200)];
        box.index = i;
        [box indexWasSet];
        [box setHeaderLabelText];
        [self.boxScrollView addSubview:box];
        [self.boxCollection addObject:box];
        box.navigationController = self.navigationController;
        [self setModelsForBox:box];
        [box refresh];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;

    pageControl = [[UIPageControl alloc] init];
    pageControl.frame = CGRectMake(0,264,self.view.bounds.size.width,36);
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(clickedPageControl:) forControlEvents:UIControlEventValueChanged];
    [self.boxScrollView addSubview:pageControl];
    pageControl.backgroundColor = [UIColor clearColor];
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0.763 green:0.059 blue:0.059 alpha:1.000];
    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    [headerView addSubview:self.boxScrollView];
    [headerView addSubview:pageControl];
    [self.view addSubview:headerView];
    
    self.menuTable = [[UITableView alloc] initWithFrame:CGRectMake(0,300,[self.view bounds].size.width,self.view.bounds.size.height-300) style:UITableViewStyleGrouped];
    [self.menuTable setRowHeight:60];
    [self.menuTable setDelegate:self];
    [self.menuTable setDataSource:self];
    self.menuTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.menuTable.bounds.size.width, 0.01f)];
    //[self.menuTable setBackgroundColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]];
    //self.menuTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.menuTable];
    
    UIImageView *refreshImageView = [[UIImageView alloc] initWithImage:
                                 [UIImage imageNamed:@"refresh-thin"]];
    
    tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(refresh:)];
    [refreshImageView addGestureRecognizer:tapGesture];
    refreshImageView.image = [refreshImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    refreshImageView.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];
    UIBarButtonItem *refreshButtonItem = [[UIBarButtonItem alloc]initWithCustomView:refreshImageView];
    
    [self.navigationItem setRightBarButtonItem:refreshButtonItem];
    
}

- (IBAction)clickedPageControl:(id)sender {
    UIPageControl *pager=sender;
    NSInteger page = pager.currentPage;
    CGRect frame = self.boxScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.boxScrollView scrollRectToVisible:frame animated:YES];
}

-(void)setModelsForBox:(DEBoxView *)box {
 
    NSInteger i = box.index;
    DEJSONParser * __weak weakParser=parser;
    DEICSParser * __weak weakICSParser=icsParser;

    switch(i) {
        case 0: {
            [weakParser modelsFromURL:[NSURL URLWithString:kAPIEndpointNextTrains] forClass:[TrainModel class] withCompletion:^(NSMutableArray *mm){
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setBoxModelWithArray:mm andIndex:i];
                    
                });
            }];
        }
            break;
        case 1:{
            [weakParser modelsFromURL:[NSURL URLWithString:kAPIEndpointCafeteriaToday] forClass:[FoodModel class] withCompletion:^(NSMutableArray *mm){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self setBoxModelWithArray:mm andIndex:i];
                });
            }];
        }
            break;
        case 2: {
            [weakICSParser modelsWithCompletion:^(NSMutableArray *mm){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self setBoxModelWithArray:mm andIndex:i];
                });
            }];
        }
            break;
        case 3: {
            [weakParser modelsFromURL:[NSURL URLWithString:kAPIEndpointDHBWNews] forClass:[DHBWNewsModel class] withCompletion:^(NSMutableArray *mm){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self setBoxModelWithArray:mm andIndex:i];
                });
            }];
        }
            break;
        case 4: {
            [weakParser modelsFromURL:[NSURL URLWithString:kAPIEndpointStuvNews] forClass:[StuvNewsModel class] withCompletion:^(NSMutableArray *mm){
                dispatch_async(dispatch_get_main_queue(), ^{
                        [self setBoxModelWithArray:mm andIndex:i];
                });
            }];
        }
            break;
        default: {NSLog(@"For Schleife läuft nicht zwischen 0 und 4. Hier läuft was schief !");}
    }
        
}

-(void)dismissWithError:(NSNotification *)not {
    [KVNProgress showErrorWithStatus:@"Fehler"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

-(void)dismissWithSuccess:(NSNotification *)not {
        [KVNProgress showSuccessWithStatus:@"Erfolgreich"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)setBoxModelWithArray:(NSMutableArray *)array andIndex:(NSInteger)index{
    [(DEBoxView*) self.boxCollection[(NSUInteger) index] setDataArray:array];
    [(DEBoxView*) self.boxCollection[(NSUInteger) index] refresh];
    if(index == 4) {
        [tapGesture.view.layer removeAnimationForKey:@"rotationAnimation"];
    }
}


-(void)refresh:(UITapGestureRecognizer *)sender {

    
    float duration = 1.0;
    int rotations = 1;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @((float) (M_PI * 2.0 /* full rotation*/ * rotations * duration));
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    
    [sender.view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    for(int i = 0;i<self.boxCollection.count;i++) {
        [self setModelsForBox:(DEBoxView *) self.boxCollection[(NSUInteger) i]];
        [(DEBoxView*) self.boxCollection[(NSUInteger) i] refresh];
    }
}


#pragma mark -
#pragma mark UITableView(Menu)

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuLabels.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DEMenuTableCell";
    DEMenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DEMenuTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DEMenuTableCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DEMenuTableCell"];
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8) {
        cell.preservesSuperviewLayoutMargins = NO;
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    // iOS 7 and later
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
        [cell setSeparatorInset:UIEdgeInsetsZero];
    
    cell.textLabel.text = menuLabels[(NSUInteger) indexPath.row];
    //cell.textLabel.textColor = [UIColor whiteColor];
    
    //cell.backgroundColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0];
    /*
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 0.5, self.view.frame.size.width, 1)];
    UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, self.view.frame.size.width, 1)];
    separator.backgroundColor = [UIColor darkGrayColor];
    separator2.backgroundColor = [UIColor blackColor];
    [cell.contentView addSubview:separator];
    [cell.contentView addSubview:separator2];
    */
    
    UIImage *imageForRendering = [menuTableImages[(NSUInteger) indexPath.row] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    cell.imageView.image = imageForRendering;
    cell.imageView.tintColor = [UIColor colorWithRed:0.941 green:0.241 blue:0.241 alpha:1.000];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //menu einträge: @"Mensa",@"Kalender",@"S-Bahn",@"Stuv News",@"Kontakte",@"DHBW News",@"Dualis",@"Raumsuche", nil];
    //TODO: index mit bereits geladenen daten: 0 = trains, 1 = food, 2= calendar, 3=dhbwNews , 4 = stuvNews
    switch(indexPath.row) {
        case 0:  {
            DECafeteriaViewController *cafeteriaController = [storyboard instantiateViewControllerWithIdentifier:@"DECafeteriaViewController"];
            [self.navigationController pushViewController:cafeteriaController animated:YES];
        }
            break;
            
        case 1:  {
            DECalendarViewController *calendarController = [storyboard instantiateViewControllerWithIdentifier:@"DECalendarViewController"];
            calendarController.calArray =[self.boxCollection[2] dataArray];
            [self.navigationController pushViewController:calendarController animated:YES];
        }
            break;
            
        case 2:  {
            DETrainViewController *trainViewController = [storyboard instantiateViewControllerWithIdentifier:@"DETrainViewController"];            
            [self.navigationController pushViewController:trainViewController animated:YES];
        }
            break;
            
        case 3:  {
            DEStuvNewsViewController *stuvNewsController = [storyboard instantiateViewControllerWithIdentifier:@"DEStuvNewsViewController"];
            stuvNewsController.stuvNews = [self.boxCollection[4] dataArray];
            [self.navigationController pushViewController:stuvNewsController animated:YES];
        }
            break;
            
        case 4:  {
            DEContactViewController *contactViewController = [storyboard instantiateViewControllerWithIdentifier:@"contactViewController"];
            [self.navigationController pushViewController:contactViewController animated:YES];
        }
            break;
            
        case 5:  {
            DEDHBWNewsViewController *dhbwController = [storyboard instantiateViewControllerWithIdentifier:@"DEDHBWNewsViewController"];
            dhbwController.dhbwNews = [self.boxCollection[3] dataArray];
            [self.navigationController pushViewController:dhbwController animated:YES];
        }
            break;
            
        case 6:  {
            InAPPWebViewController *dualisController = [storyboard instantiateViewControllerWithIdentifier:@"InAPPWebViewController"];
            dualisController.url = [NSURL URLWithString:@"http://dualis.dhbw.de"];
            [self.navigationController pushViewController:dualisController animated:YES];
        }
            break;
            
        case 7:  {
            DERoomViewController *roomController = [storyboard instantiateViewControllerWithIdentifier:@"DERoomViewController"];
            [self.navigationController pushViewController:roomController animated:YES];
        }
            break;
            
        case 8:  {
            InAPPWebViewController *elseController = [storyboard instantiateViewControllerWithIdentifier:@"InAPPWebViewController"];
            elseController.url = [NSURL URLWithString:@"http://else.dhbw-karlsruhe.de"];
            [self.navigationController pushViewController:elseController animated:YES];
        }
            break;
            
        case 9:  {
            DESettingsViewController *settingsController = [storyboard instantiateViewControllerWithIdentifier:@"DESettingsViewController"];
            [self.navigationController pushViewController:settingsController animated:YES];
        }
            break;
            
        default: {NSLog(@"ERROR: IndexPath nicht zwischen 0 und 9");}
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark -
#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.boxScrollView.frame.size.width;
    float fractionalPage = self.boxScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    pageControl.currentPage = page;
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView {
    CGFloat pageWidth = self.boxScrollView.frame.size.width;
    float fractionalPage = self.boxScrollView.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if(page == 2) {
        [self.boxCollection[2] animateClockRefresh];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  DEPopupViewController.m
//  DHBW-iOS
//
//  Created by David Ehlen on 08.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import "DEPopupViewController.h"
#import "CondimentsModel.h"
#import "DECondimentsCell.h"
@interface DEPopupViewController ()

@end

@implementation DEPopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.condimentsArray = [[NSMutableArray alloc]init];
    self.sensitizerArray = [[NSMutableArray alloc]init];
    [self setupDatasource];
}

-(void)setupDatasource {
    NSString* filePath = @"condiments";
    NSString* fileRoot = [[NSBundle mainBundle]
                          pathForResource:filePath ofType:@"txt"];
    NSString* fileContents =
    [NSString stringWithContentsOfFile:fileRoot
                              encoding:NSUTF8StringEncoding error:nil];
    
    NSArray* allLinedStrings =
    [fileContents componentsSeparatedByCharactersInSet:
     [NSCharacterSet newlineCharacterSet]];
    
    BOOL secondSection = NO;
    
    for(NSString *line in allLinedStrings) {
        if([line isEqualToString:@"Allergene"]) {
            secondSection = YES;
        }
        else if ([line isEqualToString:@"Zusatzstoffe"]) {
            
        }
        else {
        NSArray* singleStrs =
        [line componentsSeparatedByCharactersInSet:
         [NSCharacterSet characterSetWithCharactersInString:@":"]];
        CondimentsModel *model = [CondimentsModel new];
        model.abbreviation = singleStrs[0];
        model.name = singleStrs[1];

        if(secondSection) {
            [self.sensitizerArray addObject:model];
        }
        else {
            [self.condimentsArray addObject:model];
            }
        }
    }



    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return self.condimentsArray.count;
    }
    else return self.sensitizerArray.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0) {
        return @"Zusatzstoffe";
    }
    else return @"Allergene";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"DECondimentsCell";
    DECondimentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"DECondimentsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"DECondimentsCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"DECondimentsCell"];
    }
    
    if(indexPath.section == 0) {
        cell.nameLabel.text = [self.condimentsArray[(NSUInteger) indexPath.row] name];
        cell.abbreviationLabel.text = [self.condimentsArray[(NSUInteger) indexPath.row] abbreviation];
    }
    else {
        cell.nameLabel.text = [self.sensitizerArray[(NSUInteger) indexPath.row] name];
        cell.abbreviationLabel.text = [self.sensitizerArray[(NSUInteger) indexPath.row] abbreviation];

    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView
estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

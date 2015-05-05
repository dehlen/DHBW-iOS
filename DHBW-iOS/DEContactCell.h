//
//  DEContactCellTableViewCell.h
//  DHBW-iOS
//
//  Created by David Ehlen on 20.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEContactCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *functionLabel;
@property (nonatomic,strong) IBOutlet UILabel *roomLabel;


@end

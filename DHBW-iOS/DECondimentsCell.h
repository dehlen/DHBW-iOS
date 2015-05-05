//
//  DECondimentsCellTableViewCell.h
//  DHBW-iOS
//
//  Created by David Ehlen on 08.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DECondimentsCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *abbreviationLabel;

@end

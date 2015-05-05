//
//  DENewsCell.h
//  DHBW-iOS
//
//  Created by David Ehlen on 31.12.14.
//  Copyright (c) 2014 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DENewsCell : UITableViewCell {

}
@property (nonatomic,strong) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UILabel *publishedLabel;
@property (nonatomic,strong) IBOutlet UILabel *sneakLabel;

@end

//
//  DEMensaCell.h
//  DHBW-iOS
//
//  Created by David Ehlen on 06.01.15.
//  Copyright (c) 2015 David Ehlen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DEMensaCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *priceLabel;
@property (nonatomic, strong) IBOutlet UILabel *condimentsLabel;
@property (nonatomic, strong) IBOutlet UILabel *foodLabel;

@end

//
//  AnotherTableViewCell.h
//  LoveFood
//
//  Created by SCJY on 16/3/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsModel.h"
@interface AnotherTableViewCell : UITableViewCell
@property(nonatomic, retain) DetailsModel *model;
@property(nonatomic, strong) UILabel *contentLabel;

@end

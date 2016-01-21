//
//  ListTableViewCell.h
//  LoveFood
//
//  Created by SCJY on 16/1/20.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListModel.h"
@interface ListTableViewCell : UITableViewCell
@property(nonatomic, strong) ListModel *model;
@end

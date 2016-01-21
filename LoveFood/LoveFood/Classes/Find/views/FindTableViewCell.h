//
//  FindTableViewCell.h
//  LoveFood
//
//  Created by SCJY on 16/1/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindModel.h"
@interface FindTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (nonatomic, strong) FindModel *model;

@end

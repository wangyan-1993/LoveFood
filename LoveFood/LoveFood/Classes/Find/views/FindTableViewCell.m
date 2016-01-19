//
//  FindTableViewCell.m
//  LoveFood
//
//  Created by SCJY on 16/1/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FindTableViewCell.h"
@interface FindTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *upDownImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;



@end


@implementation FindTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(FindModel *)model{
    self.nameLabel.text = model.keyword;
    if ([model.delta integerValue] > 0) {
        self.upDownImage.image = [UIImage imageNamed:@"up"];
    }else if ([model.delta integerValue] == 0){
        self.upDownImage.image = [UIImage imageNamed:@"equal"];
    }else{
        self.upDownImage.image = [UIImage imageNamed:@"down"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

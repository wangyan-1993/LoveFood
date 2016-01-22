//
//  ListTableViewCell.m
//  LoveFood
//
//  Created by SCJY on 16/1/20.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ListTableViewCell.h"
@interface ListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *peiliaoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *blackImage;


@end
@implementation ListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(ListModel *)model{
    self.nameLabel.text =[NSString stringWithFormat:@"  %@", model.name];
    self.peiliaoLabel.text = [NSString stringWithFormat:@"  %@", model.peiliao];
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image  ]placeholderImage:nil];
    self.blackImage.image = [UIImage imageNamed:@"009"];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

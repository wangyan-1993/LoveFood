//
//  DetailsTableViewCell.m
//  LoveFood
//
//  Created by SCJY on 16/1/26.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DetailsTableViewCell.h"
@interface DetailsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@property (weak, nonatomic) IBOutlet UIImageView *image;

@end
@implementation DetailsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(DetailsModel *)model{
    self.numLabel.text = [NSString stringWithFormat:@"%lu", model.num + 1];
    self.contentLabel.text = model.name;
    self.contentLabel.numberOfLines = 0;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
 }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

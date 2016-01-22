//
//  FavoriteTableViewCell.m
//  LoveFood
//
//  Created by SCJY on 16/1/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FavoriteTableViewCell.h"
@interface FavoriteTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *peiliao;
@property (weak, nonatomic) IBOutlet UILabel *done;

@end


@implementation FavoriteTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(ListModel *)model{
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.name.text = model.name;
    self.peiliao.text = model.peiliao;
    self.done.text = [NSString stringWithFormat:@"%@ 做过", model.cooked];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

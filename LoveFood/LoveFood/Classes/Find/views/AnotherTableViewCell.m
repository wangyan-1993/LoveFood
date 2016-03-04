//
//  AnotherTableViewCell.m
//  LoveFood
//
//  Created by SCJY on 16/3/4.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "AnotherTableViewCell.h"
@interface AnotherTableViewCell()
@property(nonatomic, strong) UILabel *numLabel;
@end
@implementation AnotherTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //insert code...自定义方法添加视图
        [self configView];
    }
    return self;
}
- (void)configView{
    self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, 28, 28)];
    self.numLabel.backgroundColor = [UIColor darkGrayColor];
    self.numLabel.textColor = [UIColor whiteColor];
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 2, kWidth - 50 - 20, 103)];
    self.contentLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.numLabel];
        [self addSubview:self.contentLabel];

}

- (void)setModel:(DetailsModel *)model{
    self.numLabel.text = [NSString stringWithFormat:@"%ld", model.num + 1];

    self.contentLabel.text = model.name;
    
    self.contentLabel.numberOfLines = 0;
    CGRect frame = self.contentLabel.frame;
    frame.size.height = [HWTools getTextHeightWithText:self.contentLabel.text bigestSize:CGSizeMake(kWidth-70, 1000) font:15];
    self.contentLabel.frame = frame;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

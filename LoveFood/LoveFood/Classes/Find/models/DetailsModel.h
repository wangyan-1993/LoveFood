//
//  DetailsModel.h
//  LoveFood
//
//  Created by SCJY on 16/1/26.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailsModel : NSObject
@property(nonatomic, copy) NSString *name;
@property(nonatomic, assign) NSInteger num;
@property(nonatomic, copy) NSString *image;
- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end

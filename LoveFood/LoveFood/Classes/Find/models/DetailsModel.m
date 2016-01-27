//
//  DetailsModel.m
//  LoveFood
//
//  Created by SCJY on 16/1/26.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DetailsModel.h"

@implementation DetailsModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.name = dict[@"text"];
        self.image = dict[@"url"];
        self.num = dict[@"step"];
        
    }
    return self;
}

@end

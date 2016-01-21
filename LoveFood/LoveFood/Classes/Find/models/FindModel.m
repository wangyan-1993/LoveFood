//
//  FindModel.m
//  LoveFood
//
//  Created by SCJY on 16/1/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FindModel.h"

@implementation FindModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.delta = dict[@"delta"];
        self.keyword = dict[@"keyword"];
    }
    return self;
}

@end

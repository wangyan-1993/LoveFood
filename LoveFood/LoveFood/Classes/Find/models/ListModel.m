//
//  ListModel.m
//  LoveFood
//
//  Created by SCJY on 16/1/20.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.image = dict[@"photo"];
        self.idList = dict[@"id"];
        NSArray *array = dict[@"ingredient"];
        self.peiliao = [NSString new];
        for (NSDictionary *dic in array) {
            self.peiliao = [self.peiliao stringByAppendingFormat:@"%@  ", dic[@"name"]];
        }
        
        
    }
    return self;
}

@end

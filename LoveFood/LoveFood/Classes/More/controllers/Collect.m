//
//  Collect.m
//  LoveFood
//
//  Created by SCJY on 16/3/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "Collect.h"

@implementation Collect
- (instancetype)initWithNum:(NSInteger)number dict:(NSDictionary *)dict;{
    self = [super init];
    if (self) {
        self.number = number;
        self.dict = dict;
    }
    return self;
}
@end

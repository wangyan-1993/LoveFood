//
//  Collect.h
//  LoveFood
//
//  Created by SCJY on 16/3/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Collect : NSObject
@property(nonatomic, assign) NSInteger number;
@property(nonatomic, strong) NSDictionary *dict;
- (instancetype)initWithNum:(NSInteger)number dict:(NSDictionary *)dict;
@end

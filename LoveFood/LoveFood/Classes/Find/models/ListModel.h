//
//  ListModel.h
//  LoveFood
//
//  Created by SCJY on 16/1/20.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *peiliao;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *idList;
@property(nonatomic, copy) NSString *cooked;
@end

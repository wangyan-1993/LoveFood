//
//  FindModel.h
//  LoveFood
//
//  Created by SCJY on 16/1/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic, retain) NSString *delta;
@property(nonatomic, retain) NSString *keyword;
@end

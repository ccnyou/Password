//
//  NSDictionary+NSDictionary_Yoyo.h
//  GameApp
//
//  Created by ervinchen on 15/8/3.
//  Copyright (c) 2015年 ccnyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface NSDictionary (Yoyo)

// 返回一个不为NSNull的对象
- (id)yoyo_objectForKey:(id)key;

// 返回一个字符串对象，出错返回 nil
- (NSString *)yoyo_stringForKey:(id)key;

// 返回一个字符串对象，出错返回 defaultValue
- (NSString *)yoyo_stringForKey:(id)key defaultValue:(NSString *)defaultValue;

// 返回一个整数，出错返回 0
- (NSInteger)yoyo_integerForKey:(id)key;
- (NSInteger)yoyo_integerForKey:(id)key defaultValue:(NSInteger)defaultValue;

// 返回一个长整数，出错返回 0
- (long long)yoyo_longLongForKey:(id)key;

// 返回一个布尔值，出错返回 NO
- (BOOL)yoyo_boolForKey:(id)key;

// 返回一个数组，出错返回 nil
- (NSArray *)yoyo_arrayForKey:(id)key;

// 返回一个字典，出错返回 nil
- (NSDictionary *)yoyo_dictionaryForKey:(id)key;

- (double)yoyo_doubleForKey:(id)key;
- (double)yoyo_doubleForKey:(id)key defaultValue:(double)value;

// 解析 json 格式字符串
+ (NSDictionary *)yoyo_dictionaryWithJsonString:(NSString *)jsonString;
+ (NSDictionary *)yoyo_dictionaryWithJsonData:(NSData *)jsonData;

@end


@interface FMResultSet (Yoyo)

- (id)yoyo_objectForKeyedSubscript:(id)key;

@end
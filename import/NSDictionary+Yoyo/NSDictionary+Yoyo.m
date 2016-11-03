//
//  NSDictionary+NSDictionary_Yoyo.m
//  GameApp
//
//  Created by ervinchen on 15/8/3.
//  Copyright (c) 2015年 ccnyou. All rights reserved.
//

#import "NSDictionary+Yoyo.h"

@implementation NSDictionary (Yoyo)

- (id)yoyo_objectForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    
    return object;
}

- (NSString *)yoyo_stringForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    
    if ([object respondsToSelector:@selector(stringValue)]) {
        NSString* result = [object stringValue];
        return result;
    }
    
    return nil;
}

- (NSString *)yoyo_stringForKey:(id)key defaultValue:(NSString *)defaultValue {
    NSString* string = [self yoyo_stringForKey:key];
    if (string.length <= 0) {
        string = defaultValue;
    }
    
    return string;
}

- (NSArray *)yoyo_arrayForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSArray class]]) {
        return object;
    }
    
    return nil;
}

- (NSDictionary *)yoyo_dictionaryForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object isKindOfClass:[NSDictionary class]]) {
        return object;
    }
    
    return nil;
}

- (NSInteger)yoyo_integerForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(integerValue)]) {
        NSInteger result = [object integerValue];
        return result;
    }
    
    return 0;
}

- (NSInteger)yoyo_integerForKey:(id)key defaultValue:(NSInteger)defaultValue {
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(integerValue)]) {
        NSInteger result = [object integerValue];
        return result;
    }
    
    return defaultValue;
}

- (long long)yoyo_longLongForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(longLongValue)]) {
        long long result = [object longLongValue];
        return result;
    }
    
    return 0;
}

- (BOOL)yoyo_boolForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(boolValue)]) {
        BOOL result = [object boolValue];
        return result;
    }
    
    return NO;
}

- (double)yoyo_doubleForKey:(id)key {
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(doubleValue)]) {
        double result = [object doubleValue];
        return result;
    }
    
    return 0;
}

- (double)yoyo_doubleForKey:(id)key defaultValue:(double)value {
    id object = [self objectForKey:key];
    if ([object respondsToSelector:@selector(doubleValue)]) {
        double result = [object doubleValue];
        return result;
    }
    
    return value;
}

+ (NSDictionary *)yoyo_dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString.length <= 0) {
        return nil;
    }
    
    NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData.length <= 0) {
        return nil;
    }
    
    NSDictionary* dictionary = [self yoyo_dictionaryWithJsonData:jsonData];
    
    return dictionary;
}

+ (NSDictionary *)yoyo_dictionaryWithJsonData:(NSData *)jsonData {
    if (jsonData.length <= 0) {
        return nil;
    }
    
    NSError* error = nil;
    NSDictionary* dictionary = [NSJSONSerialization
                                JSONObjectWithData:jsonData
                                options:NSJSONReadingMutableContainers
                                error:&error];
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return dictionary;
}

- (NSString *)yoyo_jsonString {
    NSData* data = [self yoyo_jsonData];
    NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

- (NSData *)yoyo_jsonData {
    NSError* error = nil;
    NSData* data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    return data;
}

@end


@implementation FMResultSet (Yoyo)

- (id)yoyo_objectForKeyedSubscript:(id)key {
    id object = [self objectForKeyedSubscript:key];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    
    return object;
}

@end

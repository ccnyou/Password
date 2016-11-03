//
//  NSArray+Yoyo.m
//  GameApp
//
//  Created by ervinchen on 15/11/24.
//  Copyright © 2015年 ccnyou. All rights reserved.
//

#import "NSArray+Yoyo.h"

@implementation NSArray (Yoyo)

- (BOOL)yoyo_isIndexValid:(NSInteger)index {
    if (index < 0) {
        return NO;
    }
    
    if (index >= self.count) {
        return NO;
    }
    
    return YES;
}

- (id)yoyo_objectAtIndex:(NSInteger)index {
    if ([self yoyo_isIndexValid:index]) {
        return [self objectAtIndex:index];
    }
    
    return nil;
}

- (NSArray *)yoyo_arrayAtIndex:(NSInteger)index {
    NSArray* result = nil;
    id object = [self yoyo_objectAtIndex:index];
    if ([object isKindOfClass:[NSArray class]]) {
        result = object;
    }
    
    return result;
}

- (NSString *)yoyo_stringAtIndex:(NSInteger)index {
    NSString* result = nil;
    id object = [self yoyo_objectAtIndex:index];
    if ([object isKindOfClass:[NSString class]]) {
        result = object;
    } else if ([object respondsToSelector:@selector(stringValue)]) {
        result = [object stringValue];
    }
    
    return result;
}

- (NSInteger)yoyo_integerAtIndex:(NSInteger)index {
    NSInteger result = 0;
    id object = [self yoyo_objectAtIndex:index];
    if ([object respondsToSelector:@selector(integerValue)]) {
        result = [object integerValue];
    }
    
    return result;
}

- (BOOL)yoyo_boolAtIndex:(NSInteger)index {
    BOOL result = NO;
    id object = [self yoyo_objectAtIndex:index];
    if ([object respondsToSelector:@selector(boolValue)]) {
        result = [object boolValue];
    }
    
    return result;
}

- (NSArray *)yoyo_copyIf:(BOOL (^)(id element))ifBlock {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (id element in self) {
        BOOL shouldCopy = ifBlock(element);
        if (shouldCopy) {
            [result addObject:element];
        }
    }
    
    return result;
}

- (id)yoyo_elementIf:(BOOL (^)(id element))ifBlock {
    id result = nil;
    for (id element in self) {
        if(ifBlock(element)) {
            result = element;
            break;
        }
    }
    
    return result;
}

- (NSArray *)yoyo_copyElements:(id (^)(id element))elementBlock {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (id element in self) {
        id newElement = elementBlock(element);
        if (newElement) {
            [result addObject:newElement];
        }
    }
    
    return result;
}

- (NSArray *)yoyo_arrayByRemoveElements:(NSArray *)elements {
    NSArray* result = [self yoyo_copyIf:^BOOL(id element) {
        if ([elements containsObject:element]) {
            return NO;
        }
        
        return YES;
    }];
    
    return result;
}

- (NSDictionary *)yoyo_dictionaryGroupByKey:(id (^)(id element))keyBlock {
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    for (id element in self) {
        id key = keyBlock(element);
        if (!key) {
            continue;
        }
        
        NSMutableArray* objects = [result objectForKey:key];
        if (!objects) {
            objects = [[NSMutableArray alloc] init];
            [result setObject:objects forKey:key];
        }
        
        [objects addObject:element];
    }
    
    return result;
}

@end

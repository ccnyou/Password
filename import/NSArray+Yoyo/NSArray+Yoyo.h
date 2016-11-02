//
//  NSArray+Yoyo.h
//  GameApp
//
//  Created by ervinchen on 15/11/24.
//  Copyright © 2015年 ccnyou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Yoyo)

- (BOOL)yoyo_isIndexValid:(NSInteger)index;
- (id)yoyo_objectAtIndex:(NSInteger)index;
- (NSString *)yoyo_stringAtIndex:(NSInteger)index;
- (NSInteger)yoyo_integerAtIndex:(NSInteger)index;
- (BOOL)yoyo_boolAtIndex:(NSInteger)index;
- (NSArray *)yoyo_arrayAtIndex:(NSInteger)index;

// 用 ifBlock 拷贝元素，当 ifBlock 返回 YES，这个元素会被拷贝，NO则跳过
- (NSArray *)yoyo_copyIf:(BOOL (^)(id element))ifBlock;

// 用 elementBlock 拷贝元素，拷贝之前都会经过 elementBlock 处理，返回处理之后的元素
- (NSArray *)yoyo_copyElements:(id (^)(id element))elementBlock;

- (NSArray *)yoyo_arrayByRemoveElements:(NSArray *)elements;

// 用 ifBlock 查找第一个满足条件的元素
- (id)yoyo_elementIf:(BOOL (^)(id element))ifBlock;

@end

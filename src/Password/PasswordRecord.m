//
//  PasswordDomain.m
//  Password
//
//  Created by ervinchen on 16/11/2.
//  Copyright © 2016年 ccnyou. All rights reserved.
//

#import "PasswordRecord.h"

@implementation PasswordRecord

+ (NSString *)dbName {
    return @"password";
}

+ (NSString *)tableName {
    return @"f_records";
}

+ (NSArray *)persistentProperties {
    static NSArray* properties = nil;
    if (!properties) {
        properties = @[ @"domain", @"key", @"lastUsed" ];
    }
    
    return properties;
}

+ (NSString *)primaryKey {
    return @"domain";
}

@end

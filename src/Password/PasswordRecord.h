//
//  PasswordDomain.h
//  Password
//
//  Created by ervinchen on 16/11/2.
//  Copyright © 2016年 ccnyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYDataCenter.h"

@interface PasswordRecord : GYModelObject
@property (nonatomic, strong) NSString* domain;
@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSDate* lastUsed;
@end

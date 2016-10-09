//
//  luatab2dict.h
//  luatab2dict
//
//  Created by Glider on 2016/10/9.
//  Copyright © 2016年 Glider. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
#import "lua.hpp"
#else
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
#endif

@interface GLDLuaHelper : NSObject

+ (void)convertToLuaTable:(id)param lua:(lua_State*)L;
+ (id)convertFromLuaTable:(lua_State *)luaStat;

@end

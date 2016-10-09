//
//  luatab2dict.m
//  luatab2dict
//
//  Created by Glider on 2016/10/9.
//  Copyright © 2016年 Glider. All rights reserved.
//

#import "GLDLuaHelper.h"

@implementation GLDLuaHelper
+ (lua_State*)luaContextFromFile:(NSString *)path
{
    lua_State *state = luaL_newstate();
    luaL_openlibs(state);
    
    luaL_loadfile(state, path.UTF8String);
    int err = lua_pcall(state, 0, 0, 0);
    if (err != 0) {
        return NULL;
    }
    return state;
}

+ (void)convertToLuaTable:(id)param lua:(lua_State*)L
{
    if ([param isKindOfClass:[NSDictionary class]]) {
        [self convertDictionaryToLuaTable:param lua:L];
    }
    else if ([param isKindOfClass:[NSArray class]]) {
        [self convertArrayToLuaTable:param lua:L];
    }
}

+ (void)convertDictionaryToLuaTable:(NSDictionary *)dict lua:(lua_State*)L;
{
    lua_newtable(L);
    
    for (NSString *key in dict) {
        id value = dict[key];
        
        lua_pushstring(L, key.UTF8String);
        if ([value isKindOfClass:[NSArray class]]) {
            [self convertArrayToLuaTable:value lua:L];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            [self convertDictionaryToLuaTable:value lua:L];
        }
        else if ([value isKindOfClass:[NSString class]]) {
            NSString *str = (NSString*)value;
            if (str.length > 0)
                lua_pushstring(L, str.UTF8String);
            else
                lua_pushstring(L, "");
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *n = (NSNumber *)value;
            lua_pushnumber(L, n.doubleValue);
        }
        else if ([value isKindOfClass:[NSNull class]]) {
            lua_pushnil(L);
        }
        lua_settable(L, -3);
    }
}

+ (void)convertArrayToLuaTable:(NSArray *)array lua:(lua_State*)L
{
    lua_newtable(L);
    
    for (int i=0; i<array.count; i++) {
        id value = array[i];
        
        lua_pushnumber(L, i+1);
        if ([value isKindOfClass:[NSString class]]) {
            NSString *str = (NSString*)value;
            if (str.length > 0)
                lua_pushstring(L, str.UTF8String);
            else
                lua_pushstring(L, "");
        }
        else if ([value isKindOfClass:[NSNumber class]]) {
            lua_pushnumber(L, [(NSNumber*)value doubleValue]);
        }
        else if ([value isKindOfClass:[NSNull class]]) {
            lua_pushnil(L);
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            [self convertDictionaryToLuaTable:value lua:L];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            [self convertArrayToLuaTable:value lua:L];
        }
        lua_settable(L, -3);
    }
}

+ (id)convertFromLuaTable:(lua_State *)L
{
    id value = nil;
    int idx = lua_gettop(L);
    lua_pushnil(L);
    
    while( lua_next(L, idx)) {
        NSString *key = nil;
        int type = lua_type(L, -2);
        
        if (type == LUA_TNUMBER && value == nil) {
            value = [NSMutableArray array];
        }
        else if (type == LUA_TSTRING) {
            const char *k = lua_tostring(L, -2);
            if (k && strlen(k) > 0) {
                key = [NSString stringWithUTF8String:k];
            }
            if (key == nil)
                return nil;
            if (value == nil) {
                value = [NSMutableDictionary dictionary];
            }
        }
        
        type = lua_type(L, -1);
        if (type == LUA_TSTRING) {
            NSString *str = [NSString stringWithUTF8String:lua_tostring(L, -1)];
            if (str == nil)
                return nil;
            if ([value isKindOfClass:[NSArray class]]) {
                [value addObject:str];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                [(NSMutableDictionary*)value setObject:str forKey:key];
            }
        }
        else if (type == LUA_TNUMBER) {
            NSNumber *n = [NSNumber numberWithDouble:lua_tonumber(L, -1)];
            if ([value isKindOfClass:[NSArray class]]) {
                [value addObject:n];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                [(NSMutableDictionary*)value setObject:n forKey:key];
            }
        }
        else if (type == LUA_TNIL) {
            if ([value isKindOfClass:[NSArray class]]) {
                [value addObject:[NSNull null]];
            }
            else if ([value isKindOfClass:[NSDictionary class]]) {
                [(NSMutableDictionary*)value setObject:[NSNull null] forKey:key];
            }
        }
        else if (type == LUA_TTABLE) {
            id d = [self convertFromLuaTable:L];
            if (d) {
                if ([value isKindOfClass:[NSArray class]]) {
                    [value addObject:d];
                }
                else if ([value isKindOfClass:[NSDictionary class]]) {
                    [(NSMutableDictionary*)value setObject:d forKey:key];
                }
            }
            else {
                return nil;
            }
        }
        else if (type == LUA_TFUNCTION && key) {
            lua_setglobal(L, key.UTF8String);
            if ([value isKindOfClass:[NSDictionary class]]) {
                [(NSMutableDictionary*)value setObject:key forKey:key];
            }
        }
        if (type != LUA_TFUNCTION)
            lua_pop(L, 1);
    }
    return value;
}
@end

# luatab2dict
A Helper class convert NSDictionary/NSArray to Lua table and reverses. The examples are inside XCTest Tests.m

Convert NSArray/NSDictionary to Lua Table

    NSDictionary *dict = @{
                           @"NumberKey":@(123.45),
                           @"StringKey":@"Hello World",
                           @"ArrayKey":@[@(100),@(200),@(300),@"String"],
                           @"DictKey":@{
                                   @"SubDictNumberKey":@(300.01),
                                   @"SubDictStringKey":@"SubString",
                                   @"SubArrayKey":@[@"Sub", @"Array", @"Test"],
                                   @"SubDictKey":@{
                                           @"Loop":@(900),
                                           @"LoopString":@"Loop"
                                           }
                                   }
                           };
    
    
    NSString *path = your_lua_file_path;
    lua_State *L = [self luaContextFromFile:path];
    if (L == nil)
        return NO;
    
    lua_getglobal(L, "CaseOne");
    [GLDLuaHelper convertToLuaTable:dict lua:L];
    
    lua_call(L, 1, 0); 
	lua_close(L)


Convert Lua Table back to NSDictionary/NSArray

    NSString *path = your_lua_file_path
    lua_State *L = [self luaContextFromFile:path];
    if (L == nil)
        return NO;
    
    lua_getglobal(L, "CaseTwo");
    lua_call(L, 0, 1);
    
    if (lua_istable(L, -1)) {
        id r = [GLDLuaHelper convertFromLuaTable:L];
        NSLog(@"Result is:\n%@\n", r);
       	lua_close(L); 
        return YES;
    }
    else {
       	lua_close(L); 
        return NO;
    }


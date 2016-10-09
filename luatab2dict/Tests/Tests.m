//
//  Tests.m
//  Tests
//
//  Created by Glider on 2016/10/9.
//  Copyright © 2016年 Glider. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GLDLuaHelper.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCaseOne {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCTAssert([self caseOne], @"CaseOne");
}

- (void)testCaseTwo {
    XCTAssert([self caseTwo], @"CaseTwo");
}

- (lua_State*)luaContextFromFile:(NSString *)path
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

- (BOOL)caseOne
{
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
    
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"CaseOne" ofType:@"lua"];
    lua_State *L = [self luaContextFromFile:path];
    if (L == nil)
        return NO;
    
    lua_getglobal(L, "CaseOne");
    [GLDLuaHelper convertToLuaTable:dict lua:L];
    
    lua_call(L, 1, 0);
    lua_close(L);
    
    return YES;
}

- (BOOL)caseTwo
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"CaseTwo" ofType:@"lua"];
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
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

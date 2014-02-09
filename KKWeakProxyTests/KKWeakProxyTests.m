//
//  KKWeakProxyTests.m
//  KKWeakProxyTests
//
//  Created by Karol Kozub on 08/02/14.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KKWeakProxy.h"

@interface KKWeakProxyTests : XCTestCase
@property (nonatomic, strong) id string;
@property (nonatomic, strong) id stringProxy;
@property (nonatomic, strong) id array;
@property (nonatomic, strong) id arrayProxy;
@end

@implementation KKWeakProxyTests

- (void)setUp {
  @autoreleasepool {
    self.string = [@"test" mutableCopy];
    self.stringProxy = [KKWeakProxy proxyForTarget:self.string];
    self.array = [@[@""] mutableCopy];
    self.arrayProxy = [KKWeakProxy proxyForTarget:self.array];
  }
}

- (void)testCreatingProxiesWithProxyForTarget {
  XCTAssertTrue([self.stringProxy isProxy]);
  XCTAssertTrue([self.arrayProxy isProxy]);
}

- (void)testRespondingToCorrectMethods {
  XCTAssertTrue([self.stringProxy respondsToSelector:@selector(substringFromIndex:)]);
  XCTAssertTrue([self.arrayProxy respondsToSelector:@selector(count)]);
  XCTAssertNoThrow([self.stringProxy substringFromIndex:0]);
  XCTAssertNoThrow([self.arrayProxy count]);
}

- (void)testNotRespondingToOtherMethods {
  XCTAssertFalse([self.stringProxy respondsToSelector:@selector(count)]);
  XCTAssertFalse([self.arrayProxy respondsToSelector:@selector(substringFromIndex:)]);
  XCTAssertThrows([self.stringProxy count]);
  XCTAssertThrows([self.arrayProxy substringFromIndex:0]);
}

- (void)testWeaklyStoringTarget {
  __weak id string = self.string;
  __weak id array = self.array;
  
  self.string = nil;
  self.array = nil;
  
  XCTAssertNil(string);
  XCTAssertNil(array);
}

- (void)testForwardingMethodsToTarget {
  XCTAssertEqual([self.stringProxy length], (NSUInteger)4);
  XCTAssertEqual([self.arrayProxy count], (NSUInteger)1);
}

- (void)testRespondingToCorrectMethodsAfterReleasingTarget {
  self.string = nil;
  self.array = nil;
  
  XCTAssertTrue([self.stringProxy respondsToSelector:@selector(substringFromIndex:)]);
  XCTAssertTrue([self.arrayProxy respondsToSelector:@selector(count)]);
  XCTAssertNoThrow([self.stringProxy substringFromIndex:0]);
  XCTAssertNoThrow([self.arrayProxy count]);
}

- (void)testNotRespondingToOtherMethodsAfterReleasingTarget {
  self.string = nil;
  self.array = nil;
 
  XCTAssertFalse([self.stringProxy respondsToSelector:@selector(count)]);
  XCTAssertFalse([self.arrayProxy respondsToSelector:@selector(substringFromIndex:)]);
  XCTAssertThrows([self.stringProxy count]);
  XCTAssertThrows([self.arrayProxy substringFromIndex:0]);
}

- (void)testReturningEquivalentOfZeroAfterReleasingTarget {
  self.string = nil;
  self.array = nil;
  
  XCTAssertEqual([self.stringProxy length], (NSUInteger)0);
  XCTAssertEqual([self.arrayProxy count], (NSUInteger)0);
  XCTAssertNil([self.stringProxy stringByAppendingString:@""]);
  XCTAssertNil([self.arrayProxy arrayByAddingObject:@""]);
}

- (void)testCopying {
  id stringCopy = [self.string copy];
  id stringMutableCopy = [self.string mutableCopy];
  id stringProxyCopy = [self.stringProxy copy];
  id stringProxyMutableCopy = [self.stringProxy mutableCopy];
  
  XCTAssertNotEqual(stringProxyCopy, self.string);
  XCTAssertNotEqual(stringProxyCopy, self.stringProxy);
  XCTAssertNotEqual(stringProxyMutableCopy, self.string);
  XCTAssertNotEqual(stringProxyMutableCopy, self.stringProxy);
  XCTAssertFalse([stringProxyCopy isProxy]);
  XCTAssertFalse([stringProxyMutableCopy isProxy]);
  XCTAssertEqual([stringProxyCopy class], [stringCopy class]);
  XCTAssertEqual([stringProxyMutableCopy class], [stringMutableCopy class]);
}

- (void)testNotReleasingBeforeTarget {
  __weak id stringProxy = self.stringProxy;
  
  self.stringProxy = nil;
  
  XCTAssertNotNil(stringProxy);
  
  self.string = nil;
    
  XCTAssertNil(stringProxy);
}

- (void)testHavingOnlyOneInstancePerTarget {
  id anotherStringProxy = [KKWeakProxy proxyForTarget:self.string];
  id anotherArrayProxy = [KKWeakProxy proxyForTarget:self.array];
  
  XCTAssertEqual(anotherStringProxy, self.stringProxy);
  XCTAssertEqual(anotherArrayProxy, self.arrayProxy);
}
@end

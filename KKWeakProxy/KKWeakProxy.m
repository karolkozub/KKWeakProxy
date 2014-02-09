//
//  KKWeakProxy.m
//  KKWeakProxy
//
//  Created by Karol Kozub on 08/02/14.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import "KKWeakProxy.h"
#import "KKNil.h"
#import <objc/runtime.h>

static const char *KKWeakProxyAssociatedObjectKey = "KKWeakProxy";

@implementation KKWeakProxy {
  __weak id _target;
  __strong id _nil;
}

+ (instancetype)proxyForTarget:(id)target {
  id proxy = objc_getAssociatedObject(target, KKWeakProxyAssociatedObjectKey);
  
  if (nil == proxy) {
    proxy = [[self alloc] initWithTarget:target];
    
    objc_setAssociatedObject(target, KKWeakProxyAssociatedObjectKey, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
  return proxy;
}

- (instancetype)initWithTarget:(id)target {
  if (self) {
    _target = target;
    _nil = [KKNil nilForClass:[target class]];
  }
  
  return self;
}

- (BOOL)respondsToSelector:(SEL)aSelector {
  return [_target ?: _nil respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
  return _target ?: _nil;
}

@end

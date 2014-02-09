//
//  KKWeakProxy.h
//  KKWeakProxy
//
//  Created by Karol Kozub on 08/02/14.
//  Copyright (c) 2014 Karol Kozub. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKWeakProxy : NSProxy

+ (instancetype)proxyForTarget:(id)target;

@end

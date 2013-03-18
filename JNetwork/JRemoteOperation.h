//
//  JRemoteOperation.h
//  JNetwork
//
//  Created by Jeremy Tregunna on 2013-02-18.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRemoteOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, readonly, getter = isExecuting) BOOL executing;
@property (nonatomic, readonly, getter = isFinished) BOOL finished;

- (instancetype)initWithRequest:(NSURLRequest*)request handler:(void (^)(BOOL success, NSData* data, NSError* error))handler;

@end

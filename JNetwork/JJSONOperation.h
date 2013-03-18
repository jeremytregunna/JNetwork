//
//  JJSONOperation.h
//  JNetwork
//
//  Created by Jeremy Tregunna on 2013-03-17.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JRemoteOperation.h"

@interface JJSONOperation : JRemoteOperation

- (instancetype)initWithRequest:(NSURLRequest*)request handler:(void (^)(BOOL success, id json, NSError* error))handler;

@end

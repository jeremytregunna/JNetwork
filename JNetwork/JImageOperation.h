//
//  JImageOperation.h
//  JNetwork
//
//  Created by Jeremy Tregunna on 2013-04-15.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JRemoteOperation.h"

@class UIImage;

@interface JImageOperation : JRemoteOperation

- (instancetype)initWithRequest:(NSURLRequest*)request handler:(void (^)(BOOL success, UIImage* image, NSError* error))handler;

@end

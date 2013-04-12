//
//  JJSONOperation.m
//  JNetwork
//
//  Created by Jeremy Tregunna on 2013-03-17.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JJSONOperation.h"

@interface JRemoteOperation (JPrivateMethods)
@property (nonatomic, readwrite, getter = isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter = isFinished) BOOL finished;
@property (nonatomic, readwrite, strong) NSURLRequest* request;
@property (nonatomic, readwrite, strong) NSMutableData* receivedData;
@end

@implementation JJSONOperation
{
    void (^_handler)(BOOL, id, NSError*);
}

- (instancetype)initWithRequest:(NSURLRequest*)request handler:(void (^)(BOOL, id, NSError*))handler
{
    if((self = [super init]))
    {
        self.request = request;
        _handler = [handler copy];
    }
    return self;
}

#pragma mark - Connection delegate

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    self.finished = YES;
    self.executing = NO;

    if(_handler != nil)
    {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:&error];
        if(error != nil)
            _handler(NO, json, error);
        else
            _handler(YES, json, nil);
    }
}

#pragma mark - Observers

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    return YES;
}

@end

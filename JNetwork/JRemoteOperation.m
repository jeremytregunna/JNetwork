//
//  JRemoteOperation.m
//  JNetwork
//
//  Created by Jeremy Tregunna on 2013-02-18.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import "JRemoteOperation.h"

@interface JRemoteOperation ()
@property (nonatomic, readwrite, getter = isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter = isFinished) BOOL finished;
@end

@implementation JRemoteOperation
{
    NSURLRequest* _request;
    NSURLConnection* _connection;
    NSMutableData* _receivedData;
    void (^_handler)(BOOL, NSData*, NSError*);
}

- (instancetype)initWithRequest:(NSURLRequest*)request handler:(void (^)(BOOL, NSData*, NSError*))handler
{
    if((self = [super init]))
    {
        _request = request;
        _handler = [handler copy];
    }
    return self;
}

#pragma mark Operation overrides

- (void)start
{
    NSParameterAssert(_request);

    if([self isCancelled] == YES)
    {
        self.finished = YES;
        self.executing = NO;
        return;
    }

    self.executing = YES;
    self.finished = NO;
    _receivedData = [[NSMutableData alloc] init];

    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self];
    [_connection start];

    while(!self.isFinished)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}

#pragma mark - Connection delegate

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    if([self isCancelled] == NO)
    {
        [_receivedData appendData:data];
        return;
    }

    self.finished = YES;
    self.executing = NO;
    [_connection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    self.finished = YES;
    self.executing = NO;

    _handler(YES, [_receivedData copy], nil);
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    self.finished = YES;
    self.executing = NO;

    _handler(NO, nil, error);
}

#pragma mark - Observers

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    return YES;
}

@end

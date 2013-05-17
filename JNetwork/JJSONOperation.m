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
    BOOL _uhoh;
}

- (instancetype)initWithRequest:(NSURLRequest*)request handler:(void (^)(BOOL, id, NSError*))handler
{
    if((self = [super initWithRequest:request handler:handler]))
    {
        self.request = request;
        _handler = [handler copy];
        _uhoh = NO;
    }
    return self;
}

#pragma mark - Connection delegate

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    if([self isCancelled] == NO)
    {
        if(_uhoh)
        {
            NSError* error = nil;
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            _handler(NO, json, error);
        }
        else
        {
            [self.receivedData appendData:data];
            return;
        }
    }
    
    self.finished = YES;
    self.executing = NO;
    [connection cancel];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    self.finished = YES;
    self.executing = NO;

    if(_handler != nil && _uhoh == NO)
    {
        NSError* error = nil;
        id json = [NSJSONSerialization JSONObjectWithData:self.receivedData options:0 error:&error];
        if(error != nil)
            _handler(NO, json, error);
        else
            _handler(YES, json, nil);
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSString* code = [NSString stringWithFormat:@"%i", httpResponse.statusCode];
    NSString* majorCase = [code substringToIndex:1];
    if([majorCase isEqualToString:@"2"])
        return;
    else if([majorCase isEqualToString:@"3"])
        return;
    else if([majorCase isEqualToString:@"4"] || [majorCase isEqualToString:@"5"])
    {
        if(_handler)
            _uhoh = YES;
    }
}

#pragma mark - Observers

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    return YES;
}

@end

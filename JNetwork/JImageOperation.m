//
//  JImageOperation.m
//  JNetwork
//
//  Created by Jeremy Tregunna on 2013-04-15.
//  Copyright (c) 2013 Jeremy Tregunna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JImageOperation.h"

NSString* const JNetworkErrorDomain = @"JNetworkErrorDomain";

@interface JImageOperation ()
@property (nonatomic, readwrite, getter = isExecuting) BOOL executing;
@property (nonatomic, readwrite, getter = isFinished) BOOL finished;
@property (nonatomic, readwrite, strong) NSURLRequest* request;
@property (nonatomic, readwrite, strong) NSMutableData* receivedData;
@end

@implementation JImageOperation
{
    void (^_handler)(BOOL, UIImage*, NSError*);
}

- (instancetype)initWithRequest:(NSURLRequest*)request handler:(void (^)(BOOL, UIImage*, NSError*))handler
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
        UIImage* image = [UIImage imageWithData:self.receivedData];
        if(image != nil)
            _handler(YES, image, nil);
        else
        {
            NSDictionary* userInfo = @{ NSLocalizedDescriptionKey: @"Image data received is not valid." };
            NSError* error = [NSError errorWithDomain:JNetworkErrorDomain code:1001 userInfo:userInfo];
            _handler(NO, nil, error);
        }
    }
}

#pragma mark - Observers

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString*)key
{
    return YES;
}

@end

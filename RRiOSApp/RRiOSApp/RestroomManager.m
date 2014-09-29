//
//  RestroomManager.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "RestroomManager.h"
#import "RestroomManagerDelegate.h"

@implementation RestroomManager

NSString *RestroomManagerSearchFailedError = @"RestroomManagerSearchFailedError";

- (void)setDelegate:(id<RestroomManagerDelegate>)newDelegate
{
    if(newDelegate && ![newDelegate conformsToProtocol:@protocol(RestroomManagerDelegate)])
    {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate object does not conform to the delegate protocol" userInfo:nil] raise];
    }
    
    _delegate = newDelegate;
}

- (void)fetchRestroomsForQuery:(NSString *)query
{
    [_communicator searchForRestroomsWithQuery:query];
}

- (void)searchingForRestroomFailedWithError:(NSError *)error
{
    // get underlying error
    NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
    
    // tell delegate about an error occuring
    [self tellDelegateAboutQuestionSearchError:errorInfo];
}

- (void)recievedRestroomsJSON:(NSString *)objectNotation
{
    NSError *error = nil;
    NSArray *restrooms = [_restroomBuilder restroomsFromJSON:objectNotation error:&error];
    NSDictionary *errorInfo = nil;
    
    if(!restrooms)
    {
        // underlying error
        if(error)
        {
            errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
        }
        
        // tell delegate about an error occcuring
        [self tellDelegateAboutQuestionSearchError:errorInfo];
    }
}

#pragma mark - Helper methods

- (void)tellDelegateAboutQuestionSearchError:(NSDictionary *)errorInfo
{
    // create reportable error
    NSError *reportableError = [NSError errorWithDomain:RestroomManagerSearchFailedError code:RestroomManagerErrorSearchCode userInfo:errorInfo];
    
    [_delegate fetchingRestroomsFailedWithError:reportableError];
}

@end
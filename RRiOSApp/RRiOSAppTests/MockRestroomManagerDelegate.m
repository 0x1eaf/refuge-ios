//
//  MockRestroomManagerDelegate.m
//  RRiOSApp
//
//  Created by Harlan Kellaway on 9/29/14.
//  Copyright (c) 2014 ___REFUGERESTROOMS___. All rights reserved.
//

#import "MockRestroomManagerDelegate.h"

@implementation MockRestroomManagerDelegate

- (void)fetchingRestroomsFailedWithError:(NSError *)error
{
    self.fetchError = error;
}

@end
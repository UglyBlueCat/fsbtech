//
//  DataFetcher.h
//  fsbtech
//
//  Created by Robin Spinks on 16/08/2015.
//  Copyright (c) 2015 Robin Spinks. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataFetcher : NSObject

+ (DataFetcher*)sharedInstance;
- (instancetype)initWithBaseURL:(NSString*)url;
- (void)fetchData;

@end

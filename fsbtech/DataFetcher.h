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
- (void)downloadContactDataFromURL:(NSString*)url;
- (void)downloadImageFromURL:(NSString*)url
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success;

@end

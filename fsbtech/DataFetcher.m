//
//  DataFetcher.m
//  fsbtech
//
//  Created by Robin Spinks on 16/08/2015.
//  Copyright (c) 2015 Robin Spinks. All rights reserved.
//

#import "DataFetcher.h"
#import "Contact.h"

@interface DataFetcher ()

@property NSString* BaseURL;

@end

@implementation DataFetcher

// Set up the data fetcher as a singleton
+ (DataFetcher*)sharedInstance {
    static DataFetcher* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DataFetcher alloc] init];
    });
    return _sharedInstance;
}

// Initialise the data fetcher with the base url, which will be used for all API requests
// This assumes that only one API will be accessed, which is the case for now
- (instancetype)initWithBaseURL:(NSString*)url {
    self = [super init];
    if (self) {
        _BaseURL = url;
    }
    return self;
}

- (void)fetchData {
    // TODO: Put this network access into a background block
    NSDictionary *parameters;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:self.BaseURL parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             // TODO: Check data is JSON
             [self saveData:responseObject];
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             // TODO possibly alert the user
             NSLog(@"%s Error fetching data: %@", __PRETTY_FUNCTION__, error.description);
         }];
}

- (void)saveData:(NSData*)data {
    __autoreleasing NSError* error;
    NSDictionary* contactData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        // TODO possibly alert the user
        NSLog(@"%s Error converting JSON data: %@", __PRETTY_FUNCTION__, error.description);
    } else {
        for (NSDictionary* contact in contactData) {
            Contact* newContact = [Contact MR_createEntity];
            newContact.first_name = contact[@"first_name"];
            newContact.surname = contact[@"surname"];
            newContact.address = contact[@"address"];
            newContact.email = contact[@"email"];
            newContact.id_code = [NSString stringWithFormat:@"%@", contact[@"id"]];
            newContact.phone_number = [NSString stringWithFormat:@"%@", contact[@"phone_number"]];
            newContact.createdAt = contact[@"createdAt"];
            newContact.updatedAt = contact[@"updatedAt"];
        }
        // TODO SAVE!!!
    }
}

@end

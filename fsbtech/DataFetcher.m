//
//  DataFetcher.m
//  fsbtech
//
//  Created by Robin Spinks on 16/08/2015.
//  Copyright (c) 2015 Robin Spinks. All rights reserved.
//

#import "DataFetcher.h"
#import "Contact.h"

@implementation DataFetcher

+ (DataFetcher*)sharedInstance {
    static DataFetcher* _sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[DataFetcher alloc] init];
    });
    return _sharedInstance;
}

- (void)downloadContactDataFromURL:(NSString*)url {
    [self fetchDataFromURL:url withParameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self saveData:responseObject];
    }];
}

- (void)downloadImageFromURL:(NSString*)url
                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success {
    [self fetchDataFromURL:url withParameters:nil success:success];
}

- (void)fetchDataFromURL:(NSString*)url withParameters:(NSDictionary*)parameters
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url
      parameters:parameters
         success:success
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"%s Error fetching data: %@", __PRETTY_FUNCTION__, error.description);
         }];
}

- (void)saveData:(NSData*)data {
    __autoreleasing NSError* error;
    __block NSDictionary* contactData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        NSLog(@"%s Error converting JSON data: %@", __PRETTY_FUNCTION__, error.description);
    } else {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            for (NSDictionary* contact in contactData) {
                if (![Contact MR_findFirstByAttribute:@"id_code" withValue:contact[@"id"] inContext:localContext]) {
                    Contact* newContact = [Contact MR_createEntityInContext:localContext];
                    newContact.first_name = contact[@"first_name"];
                    newContact.surname = contact[@"surname"];
                    newContact.address = contact[@"address"];
                    newContact.email = contact[@"email"];
                    newContact.id_code = [NSString stringWithFormat:@"%@", contact[@"id"]];
                    newContact.phone_number = [NSString stringWithFormat:@"%@", contact[@"phone_number"]];
                    newContact.createdAt = contact[@"createdAt"];
                    newContact.updatedAt = contact[@"updatedAt"];
                }
            }
        } completion:^(BOOL contextDidSave, NSError *error) {
            if (contextDidSave) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kDataDidFinishloading" object:nil];
            } else {
                NSLog(@"%s Error saving: %@", __PRETTY_FUNCTION__, error.debugDescription);
            }
        }];
    }
}

@end

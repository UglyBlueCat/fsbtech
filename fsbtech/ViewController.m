//
//  ViewController.m
//  fsbtech
//
//  Created by Robin Spinks on 16/08/2015.
//  Copyright (c) 2015 Robin Spinks. All rights reserved.
//

#import "ViewController.h"
#import "Contact.h"
#import "YayCustomTableViewCell.h"
#import "ContactViewController.h"
#import "DataFetcher.h"

#define IMAGE_URL @"http://api.adorable.io/avatars/285/"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, ContactVCDelegate>

@property UITableView* tableView;
@property NSArray* contacts;
@property ContactViewController* contactView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.view setBackgroundColor:[UIColor purpleColor]];
    self.contacts = [Contact MR_findAll];
    [self configureTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableViewData) name:@"kDataDidFinishloading" object:nil];
}

- (void)configureTableView {
    CGFloat horizontalSpacer = 40;
    CGFloat verticalSpacer = 20;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectInset(self.view.bounds, verticalSpacer, horizontalSpacer)];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    
    NSString* reuseIdentifier = NSStringFromClass([YayCustomTableViewCell class]);;
    UINib* nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.view addSubview:self.tableView];
}

- (void)reloadTableViewData {
    self.contacts = [Contact MR_findAll];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UITableViewDataSource methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Contact* contact = self.contacts[indexPath.row];
    NSString* reuseIdentifier = NSStringFromClass([YayCustomTableViewCell class]);;
    YayCustomTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    NSString* fullName = [NSString stringWithFormat:@"%@ %@", contact.first_name, contact.surname];
    [cell.titleLabel setText:fullName];
    [cell.iconImageView setImage:[self loadOrFetchImageForEmail:contact.email cellAt:indexPath]];
    return cell;
}

- (UIImage*)loadOrFetchImageForEmail:(NSString*)email cellAt:(NSIndexPath *)indexPath {
    __block NSIndexPath* localIndexPath = indexPath;
    NSString* imageName = [NSString stringWithFormat:@"%@.png", email];
    NSString* pathComponent = [NSString stringWithFormat:@"Documents/%@", imageName];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:pathComponent];
    UIImage* image = [UIImage imageWithContentsOfFile:pngPath];
    if (!image) {
        NSString* imageURL = [NSString stringWithFormat:@"%@%@", IMAGE_URL, imageName];
        [[DataFetcher sharedInstance] downloadImageFromURL:imageURL
                                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                       [self saveImageFromData:responseObject
                                                                     forCellAt:localIndexPath
                                                                      withName:imageName];
                                                   }];
    }
    return image;
}

- (void)saveImageFromData:(NSData*)data forCellAt:(NSIndexPath *)indexPath withName:(NSString*)imageName {
    UIImage* image = [UIImage imageWithData:data];
    NSString* pathComponent = [NSString stringWithFormat:@"Documents/%@", imageName];
    NSString *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:pathComponent];
    [UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.contactView = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
    self.contactView.delegate = self;
    self.contactView.contact = self.contacts[indexPath.row];
    [self presentViewController:self.contactView animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* headerView = [UIView new];
    return headerView;
}

#pragma mark ContactVCDelegate methods

- (void)contactVCWillClose {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.contactView dismissViewControllerAnimated:YES completion:nil];
}

@end

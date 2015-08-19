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

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, ContactVCDelegate>

@property UITableView* tableView;
@property NSArray* contacts;
@property ContactViewController* contactView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.contacts = [Contact MR_findAll];
    [self configureTableView];
}

- (void)configureTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    [self.tableView setDataSource:self];
    [self.tableView setDelegate:self];
    NSString* reuseIdentifier = NSStringFromClass([YayCustomTableViewCell class]);;
    UINib* nib = [UINib nibWithNibName:reuseIdentifier bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    [self.tableView setBackgroundColor:[UIColor purpleColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.tableView];
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
    return cell;
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
    CGRect headerViewFrame = CGRectMake(0, 0, self.view.bounds.size.width, 20);
    [headerView setFrame:headerViewFrame];
    return headerView;
}

#pragma mark ContactVCDelegate methods

- (void)contactVCWillClose {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.contactView dismissViewControllerAnimated:YES completion:nil];
}

@end

//
//  ContactViewController.m
//  fsbtech
//
//  Created by Robin Spinks on 16/08/2015.
//  Copyright (c) 2015 Robin Spinks. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@property (strong, nonatomic) IBOutlet UILabel* nameLabel;
@property (strong, nonatomic) IBOutlet UILabel* addressLabel;
@property (strong, nonatomic) IBOutlet UILabel* phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel* emailLabel;
@property (strong, nonatomic) IBOutlet UILabel* createdAtLabel;
@property (strong, nonatomic) IBOutlet UILabel* updatedAtLabel;
@property (strong, nonatomic) IBOutlet UIButton* backButton;
@property (strong, nonatomic) IBOutletCollection (UILabel) NSArray* labels;

@end

@implementation ContactViewController

#pragma mark View Controller methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0 blue:1 alpha:1]];
    [self configureLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark IBAction methods

- (IBAction)backButtonTapped:(id)sender {
    [self.delegate contactVCWillClose];
}

#pragma mark custom methods

- (void)configureButton {
    [self.backButton setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [[self.backButton layer] setCornerRadius:5];
    [[self.backButton layer] setBorderWidth:2];
    [[self.backButton layer] setBorderColor:[[UIColor blackColor] CGColor]];
}

- (void)configureLabels {
    for (UILabel* label in self.labels) {
        [label setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.75]];
        [[label layer] setCornerRadius:5];
        [[label layer] setBorderWidth:2];
        [[label layer] setBorderColor:[[UIColor whiteColor] CGColor]];
    }
    
    [self.nameLabel setText:[NSString stringWithFormat:@" Name: %@ %@", self.contact.first_name, self.contact.surname]];
    [self.addressLabel setText:[NSString stringWithFormat:@" Address:\n %@", self.contact.address]];
    [self.phoneLabel setText:[NSString stringWithFormat:@" Phone Number: %@", self.contact.phone_number]];
    [self.emailLabel setText:[NSString stringWithFormat:@" eMail: %@", self.contact.email]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss.SSS'Z'"];
    
    NSDate* createdDate = [dateFormatter dateFromString:self.contact.createdAt];
    NSDate* updatedDate = [dateFormatter dateFromString:self.contact.updatedAt];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [self.createdAtLabel setText:[NSString stringWithFormat:@" Created at: %@",
                                              [dateFormatter stringFromDate:createdDate]]];
    [self.updatedAtLabel setText:[NSString stringWithFormat:@" Updated at: %@",
                                              [dateFormatter stringFromDate:updatedDate]]];
}

@end

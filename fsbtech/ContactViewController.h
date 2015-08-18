//
//  ContactViewController.h
//  fsbtech
//
//  Created by Robin Spinks on 16/08/2015.
//  Copyright (c) 2015 Robin Spinks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"

@protocol ContactVCDelegate <NSObject>

- (void)contactVCWillClose;

@end

@interface ContactViewController : UIViewController

@property Contact* contact;
@property id<ContactVCDelegate> delegate;

- (void)configureLabels;

@end

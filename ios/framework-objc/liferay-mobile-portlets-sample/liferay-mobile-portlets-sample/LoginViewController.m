//
//  ViewController.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 22/05/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"


@interface LoginViewController()

@property (weak, nonatomic) IBOutlet UISegmentedControl *paneSelector;
@property (weak, nonatomic) IBOutlet LoginWidget *logInPortlet;
@property (weak, nonatomic) IBOutlet SignUpWidget *signUpPortlet;

@end

@implementation LoginViewController

- (IBAction)paneChanged:(UISegmentedControl *)sender {
	self.logInPortlet.hidden = (sender.selectedSegmentIndex == 1);
	self.signUpPortlet.hidden = (sender.selectedSegmentIndex == 0);
}

- (void)onLogin:(id)session withAttributes:(NSDictionary *)attrs {
	if (attrs[@"lastLoginDate"] == [NSNull null]) {
		[[[UIAlertView alloc] initWithTitle:@"User login"
									message:attrs[@"greeting"]
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles:nil] show];
	}

	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onServerError:(NSError*)err {
	NSLog(@"Generic error -> %@", err);
}

- (void)onSignedUp:(LRSession *)session withAttributes:(NSDictionary *)attrs {
	self.paneSelector.selectedSegmentIndex = 0;
	[self paneChanged:self.paneSelector];
}

- (void)onSignUpError:(NSError*)err {
	NSLog(@"Register error -> %@", err);
}


@end

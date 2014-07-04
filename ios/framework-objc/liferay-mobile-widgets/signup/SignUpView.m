//
//  LoginView.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 22/05/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "SignUpView.h"
#import "SignUpWidget.h"


@implementation TouchScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

@end


@implementation SignUpView

- (void)onCreate {
	self.scrollView.contentSize = self.scrollView.frame.size;
}

- (NSString *)genderValue {
	return self.gender.selectedSegmentIndex == 0 ? @"m" : @"f";
}

@end

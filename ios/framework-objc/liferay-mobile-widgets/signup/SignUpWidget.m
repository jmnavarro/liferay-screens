//
//  LoginPortlet.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 06/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "SignUpWidget.h"
#import "SignUpView.h"
#import "LRSession.h"
#import "LRUserService_v62.h"
#import "LiferayContext.h"
#import "LoginStorage.h"
#import "Global.h"
#import "BasePortlet+ProgressHUD.h"


@interface SignUpWidget()

@property (nonatomic, weak) SignUpView *signUpView;

@property (nonatomic, strong) LRSession *creatorSession;
@property (nonatomic, strong) LRSession *createdSession;

@property (nonatomic, strong) NSDictionary *createdUserAttributes;

@end

@implementation SignUpWidget

- (SignUpView *)signUpView {
	return (SignUpView*)self.portletView;
}

- (void)onCustomAction:(NSString *)actionName fromSender:(UIControl *)sender
{
	if ([actionName isEqualToString:@"signup-action"]) {
		[self signUp];
	}
}

- (void)onCreate {
	if (!self.creatorUsername) {
		self.creatorUsername = @"test@liferay.com";
	}
	if (!self.creatorPassword) {
		self.creatorPassword = @"test";
	}

	if (self.groupId == 0) {
		self.groupId = [LiferayContext sharedInstance].groupId;
	}

	self.creatorSession = [[LRSession alloc] init:[LiferayContext sharedInstance].server
										 username:self.creatorUsername
										 password:self.creatorPassword];
	self.creatorSession.callback = self;
}

- (void)onServerError:(NSError *)error {
	NSError *tranformedError = [self transformError:error];

	[self hideHUDWithMessage:@"Error signing up!"
						andDetails:tranformedError.localizedDescription];
}

- (void)onServerResult:(id)result {
	if ([self.delegate respondsToSelector:@selector(onSignedUp:withAttributes:)]) {
		id<SignUpWidgetDelegate> signUpDelegate = (id<SignUpWidgetDelegate>) self.delegate;
		[signUpDelegate onSignedUp:self.createdSession
					withAttributes:result];
	}
	[self hideHUDWithMessage:@"Sign up completed!" andDetails:nil];
}

- (void)signUp {
	[self showHUDWithMessage:@"Signing up..." andDetails:@"Wait few seconds..."];

	NSString *username = valueOrEmpty(self.signUpView.username.text);
	NSString *password = valueOrEmpty(self.signUpView.password.text);
	NSString *email = valueOrEmpty(self.signUpView.email.text);
	NSString *firstName = valueOrEmpty(self.signUpView.firstName.text);
	NSString *middleName = @"";
	NSString *lastName = valueOrEmpty(self.signUpView.lastName.text);
	NSString *gender = self.signUpView.genderValue;
	NSString *jobTitle = @"";

	if ([username length] == 0) {
		username = [email componentsSeparatedByString:@"@"][0];
	}

	self.createdSession = [[LRSession alloc] init:[LiferayContext sharedInstance].server
										 username:email
										 password:password];

	LRUserService_v62 *service = [[LRUserService_v62 alloc] initWithSession:self.creatorSession];

	NSError *error = nil;

	[service addUserWithCompanyId:[LiferayContext sharedInstance].companyId
					 autoPassword:NO
						password1:password
						password2:password
				   autoScreenName:NO
					   screenName:username
					 emailAddress:email
					   facebookId:0
						   openId:@""
						   locale:[LiferayContext sharedInstance].currentLocale
						firstName:firstName
					   middleName:middleName
						 lastName:lastName
						 prefixId:0
						 suffixId:0
							 male:[gender isEqualToString:@"m"]
					birthdayMonth:1 birthdayDay:1 birthdayYear:1970
						 jobTitle:jobTitle
						 groupIds:[NSArray arrayWithObjects:@(self.groupId), nil]
				  organizationIds:[NSArray array]
						  roleIds:[NSArray array]
					 userGroupIds:[NSArray array]
						sendEmail:YES
				   serviceContext:nil
							error:&error];

	if (error) {
		[self onFailure:error];
	}
}

- (NSError *)transformError:(NSError *)error {
	NSError* transformedError;

	NSMutableDictionary *newDict = [[NSMutableDictionary alloc] initWithDictionary:error.userInfo];
	newDict[NSLocalizedFailureReasonErrorKey] = error.userInfo[NSLocalizedDescriptionKey];

	NSDictionary *supportedExceptions =
		@{@"com.liferay.portal.DuplicateUserScreenNameException": @"Duplicated user screen name",
		  @"com.liferay.portal.DuplicateUserEmailAddressException": @"Duplicated email address",
		  @"com.liferay.portal.UserEmailAddressException" : @"Email address is not valid",
		  @"com.liferay.portal.UserScreenNameException": @"Screen name is not valid"
		};

	NSString *message = [supportedExceptions objectForKey:[error localizedDescription]];
	if (!message) {
		message = error.userInfo[NSLocalizedDescriptionKey];
	}

	if (message) {
		newDict[NSLocalizedDescriptionKey] = message;
	}

	message = newDict[NSLocalizedDescriptionKey];
	if ([message hasPrefix:@"java.lang."] || [message hasPrefix:@"com.liferay."]) {
		[newDict removeObjectForKey:NSLocalizedDescriptionKey];
	}

	transformedError = [NSError errorWithDomain:error.domain
										   code:error.code
									   userInfo:newDict];

	return transformedError;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}



@end

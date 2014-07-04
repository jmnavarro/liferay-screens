//
//  LoginPortlet.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 06/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "LoginWidget.h"
#import "LoginView.h"
#import "LRUserService_v62.h"
#import "BasePortlet+ProgressHUD.h"
#import "LiferayContext.h"
#import "LoginStorage.h"


@interface LoginWidget()

@property (nonatomic, weak) LoginView *loginView;
@property (nonatomic, strong) LRSession *currentSession;

@end


@implementation LoginWidget

- (LoginView *)loginView {
	return (LoginView*)self.portletView;
}

- (void)onCreate {
	self.loginView.username.text = [LiferayContext sharedInstance].currentSession.username;
}

- (void)onCustomAction:(NSString *)actionName fromSender:(UIControl *)sender
{
	if ([sender.restorationIdentifier isEqualToString:@"login-action"]) {
		[self sendLoginWithUsername:self.loginView.username.text
						andPassword:self.loginView.password.text];
	}
}

- (void)sendLoginWithUsername:(NSString *)username andPassword:(NSString *)password
{
	[self showHUDWithMessage:@"Sending login" andDetails:@"Wait few seconds..."];

	[LiferayContext sharedInstance].currentSession = nil;

	self.currentSession = [[LRSession alloc] init:[LiferayContext sharedInstance].server username:username password:password];
	self.currentSession.callback = self;

	LRUserService_v62 *service = [[LRUserService_v62 alloc] initWithSession:self.currentSession];

	NSError *error = nil;
	[service getUserByEmailAddressWithCompanyId:[LiferayContext sharedInstance].companyId emailAddress:username error:&error];

	if (error) {
		[self onFailure:error];
	}
}

- (void)onServerError:(NSError *)error {
	[LiferayContext sharedInstance].currentSession = nil;
	[self hideHUDWithMessage:@"Error in login!" andDetails:nil];
}

- (void)onServerResult:(id)result {
	[LiferayContext sharedInstance].currentSession  = self.currentSession;

	if (self.loginView.remember.on) {
		[LoginStorage storeSession:self.currentSession];
	}
	else {
		[LoginStorage clearStoredSession];
	}

	if ([self.delegate respondsToSelector:@selector(onLogin:withAttributes:)]) {
		id<LoginWidgetDelegate> loginDelegate = (id<LoginWidgetDelegate>) self.delegate;
		[loginDelegate onLogin:self.currentSession withAttributes:result];
	}

	[self hideHUDWithMessage:@"Login completed!" andDetails:nil];
}

@end

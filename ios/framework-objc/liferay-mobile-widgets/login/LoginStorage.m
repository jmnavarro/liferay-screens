//
//  SecureStorage.m
//  Liferay Alerts
//
//  Created by jmWork on 09/04/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "LoginStorage.h"
#import "LRSession.h"

@implementation LoginStorage

+ (void)storeSession:(LRSession *)session {
	if (!session) {
		return;
	}

	[[NSUserDefaults standardUserDefaults] setObject:session.server forKey:@"server"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	NSURLProtectionSpace *protectionSpace =
		[self protectionSpaceForServer:session.server];

	NSURLCredential *credential =
		[NSURLCredential credentialWithUser:session.username
			password:session.password
			persistence:NSURLCredentialPersistencePermanent];

	[[NSURLCredentialStorage sharedCredentialStorage]
		setCredential:credential forProtectionSpace:protectionSpace];
}

+ (LRSession *)loadStoredSession {
	NSString *server =
		[[NSUserDefaults standardUserDefaults] objectForKey:@"server"];

	LRSession* storedSession = nil;
	NSURLCredential *credential = [self credentialsForServer:server];
	if (credential) {
		storedSession = [[LRSession alloc] init:server
			username:credential.user password:credential.password];
	}

	return storedSession;
}

+ (void)clearStoredSession {
	NSString *storedServer =
		[[NSUserDefaults standardUserDefaults] objectForKey:@"server"];
	if (storedServer) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"server"];
		[[NSUserDefaults standardUserDefaults] synchronize];

		NSURLCredential *credential = [self credentialsForServer:storedServer];
		if (credential) {
			NSURLProtectionSpace *protectionSpace =
				[self protectionSpaceForServer:storedServer];

			[[NSURLCredentialStorage sharedCredentialStorage]
				removeCredential:credential forProtectionSpace:protectionSpace];
		}
	}
}

+ (NSURLCredential *)credentialsForServer:(NSString *)server {
	if (!server) {
		return nil;
	}

	NSURLProtectionSpace *protectionSpace = [self protectionSpaceForServer:server];

	NSDictionary *credentialData =
		[[NSURLCredentialStorage sharedCredentialStorage]
			credentialsForProtectionSpace:protectionSpace];

	NSString *username = credentialData.keyEnumerator.nextObject;
	return credentialData[username];
}

+ (NSURLProtectionSpace *)protectionSpaceForServer:(NSString *)server {
	NSURL *url = [NSURL URLWithString:server];

	return [[NSURLProtectionSpace alloc] initWithHost:url.host
				port:[url.port integerValue] protocol:url.scheme realm:nil
				authenticationMethod:NSURLAuthenticationMethodHTTPDigest];
}

@end

//
//  SecureStorage.h
//  Liferay Alerts
//
//  Created by jmWork on 09/04/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

@class LRSession;

@interface LoginStorage : NSObject

+ (void)storeSession:(LRSession *)session;
+ (LRSession *)loadStoredSession;
+ (void)clearStoredSession;

@end

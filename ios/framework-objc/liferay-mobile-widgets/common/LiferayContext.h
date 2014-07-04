//
//  LiferayContext.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 09/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRSession;

@interface LiferayContext : NSObject

@property (nonatomic, strong) NSString *server;
@property (nonatomic, assign) long long companyId;
@property (nonatomic, assign) long long groupId;

@property (nonatomic, strong) LRSession *currentSession;

@property (nonatomic, readonly) NSString* currentLocale;

+ (instancetype)sharedInstance;

@end

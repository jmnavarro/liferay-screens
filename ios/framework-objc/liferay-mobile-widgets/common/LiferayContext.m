//
//  LiferayContext.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 09/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "LiferayContext.h"
#import "LoginStorage.h"
#import "LRSession.h"

@implementation LiferayContext


+ (instancetype)sharedInstance {
	static LiferayContext *_instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}


- (id)init {
	if (self = [super init]) {
		self.currentSession = [LoginStorage loadStoredSession];

		NSString *propertiesPath = [[NSBundle mainBundle] pathForResource:@"liferay-context" ofType:@"plist"];
		if (propertiesPath) {
			NSDictionary *properties = [[NSDictionary alloc] initWithContentsOfFile:propertiesPath];
			self.server = properties[@"server"];
			self.companyId = [properties[@"companyId"] longLongValue];
			self.groupId = [properties[@"groupId"] longLongValue];
		}
	}

	return self;
}

- (NSString*) currentLocale {
	NSString *locale = [[NSLocale autoupdatingCurrentLocale] localeIdentifier];
	NSRange startRange = [locale rangeOfString:@"_"];
	return [locale stringByReplacingCharactersInRange:NSMakeRange(0, startRange.length+1) withString:[[NSLocale preferredLanguages] objectAtIndex:0]];
}

@end

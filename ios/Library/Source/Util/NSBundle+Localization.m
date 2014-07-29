//
//  NSBundle+Localization.m
//  Liferay iOS SDK
//
//  Created by jmWork on 22/07/14.
//  Copyright (c) 2014 Liferay Inc. All rights reserved.
//

#import "NSBundle+Localization.h"
#import "LRSession.h"

NSString *const TRANSLATION_TABLE_USER_MESSAGES = @"UserMessages";
NSString *const TRANSLATION_TABLE_EXCEPTION_MESSAGES = @"ExceptionMessages";
NSString *const TRANSLATION_TABLE_CUSTOM_MESSAGES = @"CustomMessages";

static NSMutableArray *_translationTables = nil;

@implementation NSBundle (Localization)

+ (NSBundle *)localizedBundle {
	NSBundle *bundle = [self _sharedBundle];

	NSArray *preferredLanguages = [NSLocale preferredLanguages];

	NSLocale *currentLocale = [NSLocale localeWithLocaleIdentifier:
		[preferredLanguages objectAtIndex:0]];

    NSString *lang = [currentLocale.localeIdentifier substringToIndex:2];

    NSString *langPath = [bundle pathForResource:lang ofType:@"lproj"];

	for (int i = 0; !langPath && i < [preferredLanguages count]; ++i) {
		NSString *preferredLanguage = [preferredLanguages objectAtIndex:i];

		langPath = [bundle pathForResource:preferredLanguage ofType:@"lproj"];
	}

	return langPath ? [NSBundle bundleWithPath:langPath] : nil;
}

+ (void)registerTranslationTable:(NSString *)translationTableName {
	if (!_translationTables) {
		_translationTables = [[NSMutableArray alloc] initWithCapacity:4];
	}

	[_translationTables addObject:translationTableName];
}

+ (void)unregisterTranslationTable:(NSString *)translationTableName {
	[_translationTables removeObject:translationTableName];
}


+ (NSBundle *)_sharedBundle {
    static NSBundle *classBundle  = nil;
    static NSBundle *sdkBundle = nil;
    static dispatch_once_t once;

    dispatch_once(&once, ^{
        classBundle = [NSBundle bundleForClass:[LRSession class]];

	    NSString *bundlePath =
			[classBundle pathForResource:@"Liferay-iOS-SDK" ofType:@"bundle"];

        sdkBundle = [NSBundle bundleWithPath:bundlePath];

		[self registerTranslationTable:TRANSLATION_TABLE_USER_MESSAGES];
		[self registerTranslationTable:TRANSLATION_TABLE_EXCEPTION_MESSAGES];
    });

	return sdkBundle ?: classBundle;
}

- (BOOL)existsStringForKey:(NSString *)key {
	return ([self fetchStringForKey:key] != nil);
}

- (NSString *)localizedStringForKey:(NSString *)key {
	NSString *localizedString = [self fetchStringForKey:key];

	if (!localizedString) {
		NSLog(@"WARNING: Couldn't be found translation key '%@'", key);
		localizedString = key;
	}

	return localizedString;
}

- (NSString *)fetchStringForKey:(NSString *)key {
	NSString *localizedString = [self fetchStringForKey:key
		tableName:TRANSLATION_TABLE_CUSTOM_MESSAGES];

	if (localizedString) {
		return localizedString;
	}

	for (NSString *tableName in _translationTables) {
		localizedString = [self fetchStringForKey:key tableName:tableName];

		if (localizedString) {
			return localizedString;
		}
	}

	return nil;
}

- (NSString *)fetchStringForKey:(NSString *)key
		tableName:(NSString *)tableName {

	static NSString *const EMPTY_TRANSLATION = @"empty";

	NSString *localizedString = [self localizedStringForKey:key
		value:EMPTY_TRANSLATION table:tableName];

	if (localizedString == EMPTY_TRANSLATION) {
		localizedString = nil;
	}

	return localizedString;
}

@end

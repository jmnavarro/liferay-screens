/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

#import "LRScreensmobileService_v62.h"

/**
 * @author Bruno Farache
 */
@implementation LRScreensmobileService_v62

- (NSDictionary *)addScreensMobileWithTacticId:(long long)tacticId appId:(NSString *)appId placeholderId:(NSString *)placeholderId assetEntryId:(long long)assetEntryId customContentMap:(NSDictionary *)customContentMap serviceContext:(LRJSONObjectWrapper *)serviceContext error:(NSError **)error {
	NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
		@"tacticId": @(tacticId),
		@"appId": [self checkNull: appId],
		@"placeholderId": [self checkNull: placeholderId],
		@"assetEntryId": @(assetEntryId),
		@"customContentMap": [self checkNull: customContentMap],
	}];

	[self mangleWrapperWithParams:_params name:@"serviceContext" className:@"com.liferay.portal.service.ServiceContext" wrapper:serviceContext];

	NSDictionary *_command = @{@"/channel-screens-mobile.screensmobile/add-screens-mobile": _params};

	return (NSDictionary *)[self.session invoke:_command error:error];
}

- (NSArray *)getContentWithAppId:(NSString *)appId groupId:(long long)groupId userContext:(NSDictionary *)userContext serviceContext:(LRJSONObjectWrapper *)serviceContext error:(NSError **)error {
	NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
		@"appId": [self checkNull: appId],
		@"groupId": @(groupId),
		@"userContext": [self checkNull: userContext],
	}];

	[self mangleWrapperWithParams:_params name:@"serviceContext" className:@"com.liferay.portal.service.ServiceContext" wrapper:serviceContext];

	NSDictionary *_command = @{@"/channel-screens-mobile.screensmobile/get-content": _params};

	return (NSArray *)[self.session invoke:_command error:error];
}

- (NSArray *)getContentWithAppId:(NSString *)appId groupId:(long long)groupId placeholderId:(NSString *)placeholderId userContext:(NSDictionary *)userContext serviceContext:(LRJSONObjectWrapper *)serviceContext error:(NSError **)error {
	NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
		@"appId": [self checkNull: appId],
		@"groupId": @(groupId),
		@"placeholderId": [self checkNull: placeholderId],
		@"userContext": [self checkNull: userContext],
	}];

	[self mangleWrapperWithParams:_params name:@"serviceContext" className:@"com.liferay.portal.service.ServiceContext" wrapper:serviceContext];

	NSDictionary *_command = @{@"/channel-screens-mobile.screensmobile/get-content": _params};

	return (NSArray *)[self.session invoke:_command error:error];
}

- (NSArray *)getContentWithAppId:(NSString *)appId groupId:(long long)groupId placeholderIds:(NSArray *)placeholderIds userContext:(NSDictionary *)userContext serviceContext:(LRJSONObjectWrapper *)serviceContext error:(NSError **)error {
	NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
		@"appId": [self checkNull: appId],
		@"groupId": @(groupId),
		@"placeholderIds": [self checkNull: placeholderIds],
		@"userContext": [self checkNull: userContext],
	}];

	[self mangleWrapperWithParams:_params name:@"serviceContext" className:@"com.liferay.portal.service.ServiceContext" wrapper:serviceContext];

	NSDictionary *_command = @{@"/channel-screens-mobile.screensmobile/get-content": _params};

	return (NSArray *)[self.session invoke:_command error:error];
}

- (NSDictionary *)getScreensMobileWithScreensMobileId:(long long)screensMobileId error:(NSError **)error {
	NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
		@"screensMobileId": @(screensMobileId)
	}];

	NSDictionary *_command = @{@"/channel-screens-mobile.screensmobile/get-screens-mobile": _params};

	return (NSDictionary *)[self.session invoke:_command error:error];
}

- (NSDictionary *)updateScreensMobileWithScreensMobileId:(long long)screensMobileId appId:(NSString *)appId placeholderId:(NSString *)placeholderId assetEntryId:(long long)assetEntryId customContentMap:(NSDictionary *)customContentMap serviceContext:(LRJSONObjectWrapper *)serviceContext error:(NSError **)error {
	NSMutableDictionary *_params = [NSMutableDictionary dictionaryWithDictionary:@{
		@"screensMobileId": @(screensMobileId),
		@"appId": [self checkNull: appId],
		@"placeholderId": [self checkNull: placeholderId],
		@"assetEntryId": @(assetEntryId),
		@"customContentMap": [self checkNull: customContentMap],
	}];

	[self mangleWrapperWithParams:_params name:@"serviceContext" className:@"com.liferay.portal.service.ServiceContext" wrapper:serviceContext];

	NSDictionary *_command = @{@"/channel-screens-mobile.screensmobile/update-screens-mobile": _params};

	return (NSDictionary *)[self.session invoke:_command error:error];
}

@end
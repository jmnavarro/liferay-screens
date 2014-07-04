//
//  LoginPortlet.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 06/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "JournalArticleWidget.h"
#import "JournalArticleView.h"
#import "LRSession.h"
#import "LRJournalArticleService_v62.h"
#import "BasePortlet+ProgressHUD.h"
#import "LiferayContext.h"



@interface JournalArticleWidget()

@property (nonatomic, strong) LRSession *currentSession;

@end

@implementation JournalArticleWidget

-(void) onShow {
	if (_articleId != 0 && [LiferayContext sharedInstance].currentSession) {
		[self sendRequest];
	}
}

- (void)sendRequest {
	[self showHUDWithMessage:@"Loading article" andDetails:@"Wait few seconds..."];

	if (self.groupId == 0) {
		self.groupId = [LiferayContext sharedInstance].groupId;
	}

	self.currentSession = [[LRSession alloc] init:[LiferayContext sharedInstance].currentSession];
	self.currentSession.callback = self;

	LRJournalArticleService_v62 *service = [[LRJournalArticleService_v62 alloc] initWithSession:self.currentSession];

	NSError *error = nil;
	[service getArticleContentWithGroupId:self.groupId
								articleId:self.articleId
							   languageId:[LiferayContext sharedInstance].currentLocale
							 themeDisplay:nil
									error:&error];
	if (error) {
		[self onFailure:error];
	}
}

- (void)onServerError:(NSError *)error {
	[self hideHUDWithMessage:@"Error getting article" andDetails:nil];
}

- (void)onServerResult:(id)result {
	NSString *content = (NSString *)result;

	((JournalArticleView *)self.portletView).htmlContent = content;

	[self hideHUD];
}


@end

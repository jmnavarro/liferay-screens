//
//  LoginPortlet.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 06/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePortlet.h"
#import "BasePortletDelegate.h"

@protocol JournalWidgetDelegate <BasePortletDelegate>

- (void)onArticleContentReceived:(NSString*)content;

@end

@interface JournalArticleWidget : BasePortlet

@property (nonatomic, assign) long long groupId;
@property (nonatomic, strong) NSString *articleId;

@end

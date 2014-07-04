//
//  LoginPortlet.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 06/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePortlet.h"
#import "LRSession.h"


@protocol LoginWidgetDelegate <BasePortletDelegate>

- (void)onLogin:(LRSession *)session withAttributes:(NSDictionary *)attrs;

@end


@interface LoginWidget : BasePortlet


@end

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


@protocol SignUpWidgetDelegate <NSObject>

- (void)onSignedUp:(LRSession *)session withAttributes:(NSDictionary *)attrs;

@end


@interface SignUpWidget : BasePortlet

@property (nonatomic, strong) NSString *creatorUsername;
@property (nonatomic, strong) NSString *creatorPassword;

@property (nonatomic, assign) long long groupId;

@end

//
//  BasePortletDelegate.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 18/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BasePortletDelegate <NSObject>

@optional

- (void)onCustomAction:(NSString *)actionName fromSender:(UIControl *)sender;

- (void)onServerResult:(id)response;
- (void)onServerError:(NSError *)error;

@end

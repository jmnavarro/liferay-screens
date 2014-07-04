//
//  BasePortlet.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 18/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePortletView.h"
#import "BasePortletDelegate.h"
#import "LRCallback.h"

@interface BasePortlet : UIView<LRCallback>

@property (nonatomic, weak) BasePortletView *portletView;
@property (nonatomic, weak) IBOutlet id<BasePortletDelegate> delegate;

- (void)onCreate;
- (void)onShow;
- (void)onHide;
- (void)onCustomAction:(NSString *)actionName fromSender:(UIControl *)sender;

- (void)onServerResult:(id)result;
- (void)onServerError:(NSError *)error;

@end

//
//  BasePortletView.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 18/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void (^CustomActionBlock)(NSString *actionName, UIControl* sender);


@interface BasePortletView : UIView

@property (nonatomic, copy) CustomActionBlock customActionBlock;

- (void)onCreate;

@end

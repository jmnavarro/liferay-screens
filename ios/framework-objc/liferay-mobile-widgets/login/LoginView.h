//
//  LoginView.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 22/05/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePortletView.h"

@class LoginWidget;

@interface LoginView : BasePortletView

@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UISwitch *remember;

@end

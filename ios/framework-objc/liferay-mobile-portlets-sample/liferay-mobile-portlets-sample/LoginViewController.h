//
//  ViewController.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 22/05/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginWidget.h"
#import "SignUpWidget.h"


@interface LoginViewController : UIViewController<LoginWidgetDelegate, SignUpWidgetDelegate>


@end

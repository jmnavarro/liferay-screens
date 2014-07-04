//
//  BasePortlet+ProgressHUD.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 18/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "BasePortlet.h"


@interface BasePortlet (ProgressHUD)

- (void)showHUDWithMessage:(NSString*)message andDetails:(NSString*)details;
- (void)hideHUDWithMessage:(NSString*)message andDetails:(NSString*)details;
- (void)showHUD;
- (void)hideHUD;

@end

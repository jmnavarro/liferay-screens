//
//  BasePortlet+ProgressHUD.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 18/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "BasePortlet+ProgressHUD.h"
#import "MBProgressHUD.h"
#import "Global.h"


static MBProgressHUD *_progressHUD = nil;


@implementation BasePortlet (ProgressHUD)

- (UIView *)rootView:(UIView *)currentView {
	if (currentView.superview == nil) {
		return currentView;
	}

	return [self rootView:currentView.superview];

}

- (void)showHUD {
	@synchronized([BasePortlet class]) {
		if (!_progressHUD) {
			_progressHUD = [MBProgressHUD showHUDAddedTo:[self rootView:self]
												animated:YES];
		}
	}
}

- (void)hideHUD {
	@synchronized([BasePortlet class]) {
		if (_progressHUD) {
			[_progressHUD hide:YES];
			_progressHUD = nil;
		}
	}
}

- (void)showHUDWithMessage:(NSString*)message andDetails:(NSString*)details {
	@synchronized([BasePortlet class]) {
		if (!_progressHUD) {
			_progressHUD = [MBProgressHUD showHUDAddedTo:[self rootView:self]
												animated:YES];
		}
		if (message) {
			_progressHUD.labelText = message;
		}
		_progressHUD.detailsLabelText = valueOrEmpty(details);
	}
}

- (void)hideHUDWithMessage:(NSString*)message andDetails:(NSString*)details {
	@synchronized([BasePortlet class]) {
		if (_progressHUD) {
			_progressHUD.mode = MBProgressHUDModeText;

			_progressHUD.labelText = message;
			_progressHUD.detailsLabelText = valueOrEmpty(details);

			NSTimeInterval delay = 1.5 + ([message length] + [details length]) * 0.01;
			[_progressHUD hide:YES afterDelay:delay];
			_progressHUD = nil;
		}
	}
}




@end

//
//  BasePortletView.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 18/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "BasePortletView.h"


@interface BasePortletView()

- (IBAction)onCustomAction:(UIControl *)sender;

@end


@implementation BasePortletView

- (IBAction)onCustomAction:(UIControl *)sender
{
	[self endEditing:YES];

	if (self.customActionBlock) {
		self.customActionBlock(sender.restorationIdentifier, sender);
	}
}

- (void)awakeFromNib {
	[self addCustomActionsForViews:self];
	[self onCreate];
}

- (void)onCreate {
	
}

- (void)addCustomActionsForViews:(UIView *)parentView
{
	for (id subview in parentView.subviews) {
        if ([subview isKindOfClass:[UIControl class]]) {
			[self addCustomActionForControl:(UIControl *)subview];
        }

		[self addCustomActionsForViews:subview];
    }
}

- (void)addCustomActionForControl:(UIControl *)control
{
	NSArray *actions = [control actionsForTarget:control
								 forControlEvent:UIControlEventTouchUpInside];

	if ([actions count] == 0) {
		[control addTarget:self
					action:@selector(onCustomAction:)
		  forControlEvents:UIControlEventTouchUpInside];
	}
}

@end

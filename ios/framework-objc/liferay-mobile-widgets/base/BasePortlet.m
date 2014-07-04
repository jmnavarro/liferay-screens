//
//  BasePortlet.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 18/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "BasePortlet.h"

@implementation BasePortlet


- (void)awakeFromNib
{
	self.clipsToBounds = YES;
	[self loadPortletView];
	[self onCreate];
}

- (void)didMoveToWindow {
	if (self.window) {
		[self onShow];
	}
	else {
		[self onHide];
	}
}

- (void)loadPortletView
{
	self.portletView = [self portletViewFromNib];

    self.portletView.frame = (CGRect){CGPointZero, self.frame.size};

    [self addSubview:self.portletView];

	self.portletView.customActionBlock =
		^void (NSString *actionName, UIControl *sender) {
			if ([self.delegate respondsToSelector:@selector(onCustomAction:fromSender:)]) {
				[self.delegate onCustomAction:sender.restorationIdentifier
								   fromSender:sender];
			}
			[self onCustomAction:actionName fromSender:sender];
		};
}

- (BasePortletView *)portletViewFromNib {
	NSString *className = NSStringFromClass([self class]);
	NSString *portletName = [className componentsSeparatedByString:@"Widget"][0];
	NSString *viewName = [portletName stringByAppendingString:@"View"];

	NSString *nibName = [viewName stringByAppendingString:@"-ext"];
	if (![[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {
		nibName = viewName;

		if (![[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"]) {
			NSAssert(NO, @"Fatal error: can't find view xib file for widget '%@'. Make sure you have a xib file with name '%@'", className, nibName);
		}

	}

	NSArray *views = nil;
	@try {
		views = [[NSBundle mainBundle] loadNibNamed:nibName
											  owner:self
												options:nil];
		NSAssert([views count] > 0, @"xib '%@' seems to be malformed.", nibName);
	}
	@catch (NSException *exception) {
		NSLog(@"Fatal error: can't load xib file with name %@", nibName);
	}
	@finally {
	}

	return [views objectAtIndex:0];
}

- (void)onFailure:(NSError *)error {
	if ([self.delegate respondsToSelector:@selector(onServerError:)]) {
		[self.delegate onServerError:error];
	}

	[self onServerError:error];
}

- (void)onSuccess:(id)result {
	if ([self.delegate respondsToSelector:@selector(onServerResult:)]) {
		[self.delegate onServerResult:result];
	}

	[self onServerResult:result];
}

- (void)onCreate {
}

- (void)onShow {
}

- (void)onHide {
}

- (void)onCustomAction:(NSString *)actionName fromSender:(UIControl *)sender {
}

- (void)onServerError:(NSError *)error {
}

- (void)onServerResult:(id)result {
}

@end

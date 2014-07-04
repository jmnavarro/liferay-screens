//
//  WebContentView.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 10/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "JournalArticleView.h"
#import "LiferayContext.h"

@interface JournalArticleView()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end


@implementation JournalArticleView

- (void)setHtmlContent:(NSString *)htmlContent {
	NSURL *serverURL = [NSURL URLWithString:[LiferayContext sharedInstance].server];
	[self.webView loadHTMLString:htmlContent baseURL:serverURL];
}

@end

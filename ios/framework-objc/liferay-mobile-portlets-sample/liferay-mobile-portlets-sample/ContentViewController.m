//
//  ContentViewController.m
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 10/06/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import "ContentViewController.h"
#import "LoginStorage.h"
#import "JournalArticleWidget.h"

@interface ContentViewController ()

@property (weak, nonatomic) IBOutlet JournalArticleWidget *journalArticle;
@property (weak, nonatomic) IBOutlet UITextField *articleId;

- (IBAction)getAction:(id)sender;


@end

@implementation ContentViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"logout"]) {
		[LoginStorage clearStoredSession];
	}

    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (IBAction)getAction:(id)sender {
	[self.view endEditing:YES];

	if ([self.articleId.text length] > 0) {
		self.journalArticle.articleId = self.articleId.text;
	}
//	self.journalArticle.articleId = @"12527"; // con template
//	self.journalArticle.articleId = @"12627"; // basic web content
//	[self.journalArticle sendRequest];
}


- (void)onArticleContentReceived:(NSString*)content {
}

- (void)onArticleError:(NSError*)err {
	NSLog(@"Error -> %@", err);
}


@end

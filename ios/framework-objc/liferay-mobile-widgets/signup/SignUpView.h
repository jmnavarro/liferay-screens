//
//  LoginView.h
//  liferay-mobile-portlets-sample
//
//  Created by jmWork on 22/05/14.
//  Copyright (c) 2014 Liferay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasePortletView.h"


@interface TouchScrollView : UIScrollView

@end


@interface SignUpView : BasePortletView

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UITextField *username;
@property (nonatomic, weak) IBOutlet UITextField *password;
@property (nonatomic, weak) IBOutlet UITextField *email;
@property (nonatomic, weak) IBOutlet UITextField *firstName;
@property (nonatomic, weak) IBOutlet UITextField *lastName;
@property (nonatomic, weak) IBOutlet UISegmentedControl *gender;

@property (nonatomic, readonly) NSString *genderValue;

@end

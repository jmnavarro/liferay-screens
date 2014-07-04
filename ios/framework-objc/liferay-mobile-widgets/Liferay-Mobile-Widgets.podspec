Pod::Spec.new do |s|
	s.name			= "Liferay-Mobile-Widgets"
	s.version		= "6.2.0.1"
	s.summary		= "Build iOS apps for Liferay."
	s.homepage		= "https://www.liferay.com/community/liferay-projects/liferay-mobile-sdk"
	s.license		= "LPGL 2.1"
	s.author		= {"Jose Manuel Navarro" => "jose.navarro@liferay.com"}
	s.platform		= :ios
	s.source_files	= "**/*.{h,m}"
	s.resources     = "**/*.{xib,plist}"
	s.requires_arc	= true
	s.dependency      'Liferay-iOS-SDK'
	s.dependency      'MBProgressHUD'
end
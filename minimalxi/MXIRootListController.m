#include "MXIRootListController.h"
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBPreferences.h>
#define xTitleIconPath	@"/Library/PreferenceBundles/MinimalXI.bundle/icon2@2x.png"


@implementation MXIRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)setTitle:(id)title {
	[super setTitle:title];

	UIImage *icon = [[UIImage alloc] initWithContentsOfFile:xTitleIconPath];
	if (icon) {
		UIImageView *iconView = [[UIImageView alloc] initWithImage:icon];
		iconView.layer.cornerRadius = iconView.frame.size.height /2;
		iconView.layer.masksToBounds = YES;
		iconView.layer.borderWidth = 0;
		self.navigationItem.titleView = iconView;
	}
}

-(void)respring {
	system("killall -9 SpringBoard");
}

@end

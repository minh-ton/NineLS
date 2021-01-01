#include "NineLSSTUSubPrefController.h"
#import <Preferences/PSSpecifier.h>
#import "libcolorpicker.h"

#define kTintColor [UIColor colorWithRed: 0.42 green: 0.54 blue: 0.80 alpha: 1.00];

@implementation NineLSSTUSubPrefController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"SlideToUnlock" target:self];
	}

	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/User/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (__bridge CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.view.tintColor = kTintColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]].onTintColor = kTintColor;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)textcolor {
	NSMutableDictionary const *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.minhton.ninelspref.plist"];
	NSString *customTextColor = [prefs objectForKey:@"slideToUnlockColor"];

	NSString *fallbackHex = @"#000000";

	UIColor *startColor = LCPParseColorString(customTextColor, fallbackHex); // this color will be used at startup
	PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:NO];

	[alert displayWithCompletion: ^void (UIColor *pickedColor) {
	NSString *hexString = [UIColor hexFromColor:pickedColor];

	[prefs setValue:hexString forKey:@"slideToUnlockColor"];
	[prefs writeToFile:@"/var/mobile/Library/Preferences/me.minhton.ninelspref.plist" atomically:YES];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/prefsupdated"), nil, nil, true);
	}];
}

@end

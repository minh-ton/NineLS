#include "NineLSRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <Cephei/HBRespringController.h>
#import <QuartzCore/CoreAnimation.h>
#import <spawn.h>

#define kTintColor [UIColor colorWithRed: 0.42 green: 0.54 blue: 0.80 alpha: 1.00];

CAEmitterLayer *fireworksEmitter;
CAEmitterCell* rocket;
CAEmitterCell* burst;
CAEmitterCell* spark;

@implementation NineLSRootListController

@synthesize respringButton;

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
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

-(void)startFireworks {
    fireworksEmitter = [CAEmitterLayer layer];
    CGRect viewBounds = self.view.layer.bounds;
    fireworksEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height);
    fireworksEmitter.emitterSize = CGSizeMake(viewBounds.size.width/2.0, 0.0);
    fireworksEmitter.emitterMode = kCAEmitterLayerOutline;
    fireworksEmitter.emitterShape	= kCAEmitterLayerRectangle;
    fireworksEmitter.renderMode	= kCAEmitterLayerAdditive;
    fireworksEmitter.seed = (arc4random()%100)+1;

    rocket = [CAEmitterCell emitterCell];
    rocket.birthRate = 1.0;
    rocket.emissionRange = 0.25 * M_PI;
    rocket.velocity	= 380;
    rocket.velocityRange	= 100;
    rocket.yAcceleration	= 75;
    rocket.lifetime	= 1.02;
    rocket.contents	= (id) [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/NineLSPref.bundle/bomb.png"] CGImage];
    rocket.scale = 0.2;
    rocket.color = [[UIColor redColor] CGColor];
    rocket.greenRange	= 1.0;
    rocket.redRange	= 1.0;
    rocket.blueRange = 1.0;
    rocket.spinRange = M_PI;

    burst = [CAEmitterCell emitterCell];
    burst.birthRate	= 1.0;
    burst.velocity = 0;
    burst.scale	= 3.5;
    burst.redSpeed =-1.5;
    burst.blueSpeed	=+1.5;
    burst.greenSpeed =+1.0;
    burst.lifetime = 0.35;

    spark = [CAEmitterCell emitterCell];
    spark.birthRate	= 1000;
    spark.velocity = 50;
    spark.emissionRange	= 2* M_PI;
    spark.yAcceleration	= 20;
    spark.lifetime = 2;
    spark.contents = (id) [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/NineLSPref.bundle/splash.png"] CGImage];
    spark.scaleSpeed =-0.2;
    spark.greenSpeed =-0.1;
    spark.redSpeed = 0.4;
    spark.blueSpeed	=-0.1;
    spark.alphaSpeed =-0.25;
    spark.spin = 2* M_PI;
    spark.spinRange	= 2* M_PI;

    fireworksEmitter.emitterCells	= [NSArray arrayWithObject:rocket];
    rocket.emitterCells = [NSArray arrayWithObject:burst];
    burst.emitterCells = [NSArray arrayWithObject:spark];

    [self.view.layer addSublayer:fireworksEmitter];
}

-(void)stopFireworks {
    fireworksEmitter.birthRate=0;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.view.tintColor = kTintColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[self.class]].onTintColor = kTintColor;

	[self startFireworks];
	[self performSelector:@selector(stopFireworks) withObject:self afterDelay:5.0];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (instancetype)init {
    self = [super init];

    if (self) {
        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring:)];
				self.respringButton.tintColor = kTintColor;
        self.navigationItem.rightBarButtonItem = self.respringButton;
				self.navigationItem.leftBarButtonItem.tintColor = kTintColor;
        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"NineLS";
				self.titleLabel.hidden = YES;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,10,10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/NineLSPref.bundle/NineLSIcon@2x.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 1.0;
        [self.navigationItem.titleView addSubview:self.iconView];

        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];
    }

    return self;
}

- (void)respring:(id)sender {
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Apply Settings" message:@"Are you sure you want to respring?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction* respringAction = [UIAlertAction actionWithTitle:@"Respring" style:UIAlertActionStyleDestructive
	   handler:^(UIAlertAction * action) {
		pid_t pid;
		int status;
		const char *args[] = {"sbreload", NULL, NULL, NULL};
		[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=NineLS"]];
		posix_spawn(&pid, "usr/bin/sbreload", NULL, NULL, (char *const *)args, NULL);
		waitpid(pid, &status, WEXITED);

	}];
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
	handler:^(UIAlertAction * action) {}];

	[alert addAction:respringAction];
	[alert addAction:cancelAction];

	[self presentViewController:alert animated:YES completion:nil];
}

- (void)reddit {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.reddit.com/user/Minh-Ton"] options:@{} completionHandler:nil];
}

- (void)github {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Minh-Ton"] options:@{} completionHandler:nil];
}

- (void)sourcecode {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Minh-Ton/NineLS"] options:@{} completionHandler:nil];
}

- (void)website {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://minh-ton.github.io"] options:@{} completionHandler:nil];
}

- (void)resetpref {

	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Reset Settings" message:@"Are you sure you want to reset all changes?" preferredStyle:UIAlertControllerStyleAlert];

	UIAlertAction* respringAction = [UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive
	   handler:^(UIAlertAction * action) {
		[[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/me.minhton.ninelspref.plist" error:nil];
		pid_t pid;
		int status;
		const char *args[] = {"sbreload", NULL, NULL, NULL};
		[HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=NineLS"]];
		posix_spawn(&pid, "usr/bin/sbreload", NULL, NULL, (char *const *)args, NULL);
		waitpid(pid, &status, WEXITED);
	}];
	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
	handler:^(UIAlertAction * action) {}];

	[alert addAction:respringAction];
	[alert addAction:cancelAction];

	[self presentViewController:alert animated:YES completion:nil];
}

@end

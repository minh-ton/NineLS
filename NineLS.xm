#import "NineLS.h"

// For Slide To Unlock text color

@implementation UIColor(Hexadecimal)
+ (UIColor *)colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
@end

static bool isOnLockscreen = true;

BOOL enableNineLS;
BOOL lockSound;

// slide to unlock
BOOL slideToUnlockEnabled;
NSString *slideToUnlockText;
NSInteger slideToUnlockSize;
NSString *slideToUnlockColor;
BOOL slideToUnlockChevron;
BOOL slideToUnlockAutoHide;
NSString *lsText;

// notifs
BOOL notifEnabled;

BOOL bannersEnabled;
BOOL notifEnableSeparators;
float notifSeparatorAlpha;
BOOL notifdisableGrouping;

// music
BOOL musicEnabled;

BOOL musicHideTimeControls;
BOOL musicHideMediaControls;
BOOL musicHideVolumeSlider;
BOOL musicHideSongArtwork;
BOOL musicHideSongTitle;
BOOL musicHideArtistTitle;

BOOL musicProgressBarCustom;
BOOL musicControlButtonsCustom;
BOOL musicVolumeSliderCustom;
BOOL musicSongArtworkCustom;
BOOL musicSongTitleCustom;
BOOL musicArtistTitleCustom;

float musicTimesControlsXPosition;
float musicTimesControlsYPosition;
float musicMediaControlsXPosition;
float musicMediaControlsYPosition;
float musicVolumeSliderXPosition;
float musicVolumeSliderYPosition;
float musicArtworkXPosition;
float musicArtworkYPosition;
float musicSongNameXPosition;
float musicSongNameYPosition;
float musicArtistNameXPosition;
float musicArtistNameYPosition;

// Views
static CSScrollView *scrollView;
static CSMainPageView *mainPageView;
static CSFixedFooterViewController *fixedFooterViewController;
static CSTeachableMomentsContainerViewController *containerViewController;
static CSTodayContentView *todayContentView;
static CSViewController *viewController;
static CSCoverSheetView *coverSheetView;

// for notifications
static CSCoverSheetViewController *coversheetView;
static NCNotificationShortLookView *notifContentView;

// for music player
static MediaControlsTimeControl *playerTimeControl;
static MediaControlsVolumeSlider *volumeSlider;
static MediaControlsTransportStackView *mediaControls;
static MRUNowPlayingTimeControlsView *newPlayerTimeControl;
static MRUNowPlayingTransportControlsView *newMediaControls;
static MRUNowPlayingVolumeSlider *newVolumeSlider;

BOOL isCurrentlyActive = NO;
long long notificationCount;
CGFloat lastContentOffset;

// Copy the default preferences
void initNineLS() {
  NSMutableDictionary const *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/me.minhton.ninelspref.plist"];

  if (!prefs) {
    NSURL *source = [NSURL fileURLWithPath:@"/Library/PreferenceBundles/NineLSPref.bundle/defaults.plist"];
    NSURL *destination = [NSURL fileURLWithPath:@"/var/mobile/Library/Preferences/me.minhton.ninelspref.plist"];
    [[NSFileManager defaultManager] copyItemAtURL:source toURL:destination error:nil];
  }

  enableNineLS = [[prefs objectForKey:@"enableNineLS"] boolValue]; // done
  lockSound = [[prefs objectForKey:@"lockSound"] boolValue]; // done

  // slide to unlock
  slideToUnlockEnabled = [[prefs objectForKey:@"slideToUnlockEnabled"] boolValue]; // done
  slideToUnlockText = [prefs objectForKey:@"slideToUnlockText"]; // done
  slideToUnlockColor = [prefs objectForKey:@"slideToUnlockColor"]; // done
  slideToUnlockSize = [[prefs objectForKey:@"slideToUnlockSize"] integerValue]; // done
  slideToUnlockChevron = [[prefs objectForKey:@"slideToUnlockChevron"] boolValue]; // done
  slideToUnlockAutoHide = [[prefs objectForKey:@"slideToUnlockAutoHide"] boolValue]; // done

  // notifs
  notifEnabled = [[prefs objectForKey:@"notifEnabled"] boolValue]; // done
  bannersEnabled = [[prefs objectForKey:@"bannersEnabled"] boolValue]; // done
  notifEnableSeparators = [[prefs objectForKey:@"notifEnableSeparators"] boolValue]; // done
  notifdisableGrouping = [[prefs objectForKey:@"notifdisableGrouping"] boolValue]; // done
  notifSeparatorAlpha = [[prefs objectForKey:@"notifSeparatorAlpha"] floatValue]; // done

  // music
  musicEnabled = [[prefs objectForKey:@"musicEnabled"] boolValue]; // done
  musicHideTimeControls = [[prefs objectForKey:@"musicHideTimeControls"] boolValue]; // done
  musicHideMediaControls = [[prefs objectForKey:@"musicHideMediaControls"] boolValue]; // done
  musicHideVolumeSlider = [[prefs objectForKey:@"musicHideVolumeSlider"] boolValue]; // done
  musicHideSongArtwork = [[prefs objectForKey:@"musicHideSongArtwork"] boolValue];
  musicHideSongTitle = [[prefs objectForKey:@"musicHideSongTitle"] boolValue];
  musicHideArtistTitle = [[prefs objectForKey:@"musicHideArtistTitle"] boolValue];

  musicProgressBarCustom = [[prefs objectForKey:@"musicProgressBarCustom"] boolValue]; // done
  musicControlButtonsCustom = [[prefs objectForKey:@"musicControlButtonsCustom"] boolValue]; // done
  musicVolumeSliderCustom = [[prefs objectForKey:@"musicVolumeSliderCustom"] boolValue]; // done
  musicSongArtworkCustom = [[prefs objectForKey:@"musicSongArtworkCustom"] boolValue]; // done
  musicSongTitleCustom = [[prefs objectForKey:@"musicSongTitleCustom"] boolValue]; // done
  musicArtistTitleCustom = [[prefs objectForKey:@"musicArtistTitleCustom"] boolValue]; // done

  musicTimesControlsXPosition = [[prefs objectForKey:@"musicTimesControlsXPosition"] floatValue]; // done
  musicTimesControlsYPosition = [[prefs objectForKey:@"musicTimesControlsYPosition"] floatValue]; // done
  musicMediaControlsXPosition = [[prefs objectForKey:@"musicMediaControlsXPosition"] floatValue]; // done
  musicMediaControlsYPosition = [[prefs objectForKey:@"musicMediaControlsYPosition"] floatValue]; // done
  musicVolumeSliderXPosition = [[prefs objectForKey:@"musicVolumeSliderXPosition"] floatValue]; // done
  musicVolumeSliderYPosition = [[prefs objectForKey:@"musicVolumeSliderYPosition"] floatValue]; // done
  musicArtworkXPosition = [[prefs objectForKey:@"musicArtworkXPosition"] floatValue]; // done
  musicArtworkYPosition = [[prefs objectForKey:@"musicArtworkYPosition"] floatValue]; // done
  musicSongNameXPosition = [[prefs objectForKey:@"musicSongNameXPosition"] floatValue]; // done
  musicSongNameYPosition = [[prefs objectForKey:@"musicSongNameYPosition"] floatValue]; // done
  musicArtistNameXPosition = [[prefs objectForKey:@"musicArtistNameXPosition"] floatValue]; // done
  musicArtistNameYPosition = [[prefs objectForKey:@"musicArtistNameYPosition"] floatValue]; // done
}

// for fake notifications
static BBServer* bbServer = nil;

static dispatch_queue_t getBBServerQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
    void* handle = dlopen(NULL, RTLD_GLOBAL);
        if (handle) {
            dispatch_queue_t __weak *pointer = (__weak dispatch_queue_t *) dlsym(handle, "__BBServerQueue");
            if (pointer) queue = *pointer;
            dlclose(handle);
        }
    });
    return queue;

}

static void fakeNotification(NSString *sectionID, NSDate *date, NSString *message, bool banner) {
	BBBulletin* bulletin = [[%c(BBBulletin) alloc] init];
	bulletin.title = @"NineLS";
  bulletin.message = message;
  bulletin.sectionID = sectionID;
  bulletin.bulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
  bulletin.recordID = [[NSProcessInfo processInfo] globallyUniqueString];
  bulletin.publisherBulletinID = [[NSProcessInfo processInfo] globallyUniqueString];
  bulletin.date = date;
  bulletin.defaultAction = [%c(BBAction) actionWithLaunchBundleID:sectionID callblock:nil];
  bulletin.clearable = YES;
  bulletin.showsMessagePreview = YES;
  bulletin.publicationDate = date;
  bulletin.lastInterruptDate = date;

  if (banner) {
      if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
          dispatch_sync(getBBServerQueue(), ^{
              [bbServer publishBulletin:bulletin destinations:15];
          });
      }
  } else {
      if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:alwaysToLockScreen:)]) {
          dispatch_sync(getBBServerQueue(), ^{
              [bbServer publishBulletin:bulletin destinations:4 alwaysToLockScreen:YES];
          });
      } else if ([bbServer respondsToSelector:@selector(publishBulletin:destinations:)]) {
          dispatch_sync(getBBServerQueue(), ^{
              [bbServer publishBulletin:bulletin destinations:4];
          });
      }
    }
}

void NineLSTestNotifs() {
  [[%c(SBLockScreenManager) sharedInstance] lockUIFromSource:1 withOptions:nil];
  fakeNotification(@"com.apple.mobilephone", [NSDate date], @"Missed call", false);
  fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Hey there!", false);
  fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"NineLS brings back the iOS 9 Lock Screen!", false);
  fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"And check out these iOS 9 Notifications!", false);
  fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Wow!", false);
  fakeNotification(@"com.apple.AppStore", [NSDate date], @"Happy New Year 2021!", false);
  fakeNotification(@"com.apple.Music", [NSDate date], @"iOS 9 Lock Screen (feat. Apple)", false);
  fakeNotification(@"com.apple.siri", [NSDate date], @"iOS 9 Lock Screen is beautiful!", false);
  fakeNotification(@"com.apple.siri", [NSDate date], @"I love NineLS!", false);
}

void NineLSTestBanner() {
  fakeNotification(@"com.apple.MobileSMS", [NSDate date], @"Check out the iOS 9 Banners!", true);
}

// update Slide to Unlock
void SlideToUnlockUpdateAll() {
  [mainPageView updateNineUnlockState]; //CSMainPageView
  [fixedFooterViewController updateNineUnlockState]; //CSFixedFooterViewController
  [containerViewController updateNineUnlockState];
  [todayContentView updateNineUnlockState];
}

// lockscreen check
void setIsOnLockscreen(bool value) {
    isOnLockscreen = value;
    if (slideToUnlockEnabled) SlideToUnlockUpdateAll();
}

// ===================== SLIDE TO UNLOCK =========================

%group SlideToUnlock

%hook CSMainPageView

%property (nonatomic, retain) _UIGlintyStringView *SlideToUnlockView;

-(id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    mainPageView = self;
    return orig;
}

-(void)layoutSubviews {
    %orig;
    if (!self.SlideToUnlockView) {
        self.SlideToUnlockView = [[_UIGlintyStringView alloc] initWithText:slideToUnlockText andFont:[UIFont systemFontOfSize:slideToUnlockSize]];
    }
    [self updateNineUnlockState];
}

%new;
-(void)updateNineUnlockState {
    if (isOnLockscreen) {
        [self addSubview:self.SlideToUnlockView];
        self.SlideToUnlockView.frame = CGRectMake(0, self.frame.size.height - 150, self.frame.size.width, 150);
        [self sendSubviewToBack:self.SlideToUnlockView];
        if (slideToUnlockChevron) {
          [self.SlideToUnlockView setChevronStyle:1];
        } else {
          [self.SlideToUnlockView setChevronStyle:0];
        }

        [self.SlideToUnlockView hide];
        [self.SlideToUnlockView show];

        if (slideToUnlockAutoHide) {
          int notify_token2;

          notify_register_dispatch("me.minhton.ninels/showSTU", &notify_token2, dispatch_get_main_queue(), ^(int token) {
            [self.SlideToUnlockView show];
          });

          notify_register_dispatch("me.minhton.ninels/hideSTU", &notify_token2, dispatch_get_main_queue(), ^(int token) {
            [self.SlideToUnlockView hide];
          });
        }

        UIColor *primaryColor = [UIColor colorWithHexString:slideToUnlockColor];
        if (viewController && [viewController legibilitySettings]) {
            CGFloat white = 0;
            CGFloat alpha = 0;
            [[viewController legibilitySettings].primaryColor getWhite:&white alpha:&alpha];
        }
        self.SlideToUnlockView.layer.sublayers[0].sublayers[2].backgroundColor = [primaryColor colorWithAlphaComponent:0.65].CGColor;
    } else {
      [self.SlideToUnlockView hide];
      [self.SlideToUnlockView removeFromSuperview];
    }
}
%end

// My sketchy way to hide the "Press home to unlock" text...
%hook SBUICallToActionLabel

- (void)setText:(id)arg1 forLanguage:(id)arg2 animated:(bool)arg3 {
	lsText = @"";
	return %orig(lsText, arg2, arg3);
}

%end

// Hide the homebar on iPhoneX and newer models

%hook CSTeachableMomentsContainerViewController

-(id)init {
    id orig = %orig;
    containerViewController = self;
    return orig;
}

-(void)viewDidLoad{
    %orig;
    [self updateNineUnlockState];
}

%new;
-(void)updateNineUnlockState {
  self.view.alpha = 0.0;
  self.view.hidden = YES;
}
%end

// Move the date & time with Slide to Unlock...
%hook CSTodayPageViewController
-(void)aggregateAppearance:(id)arg1 {
    %orig;
    if (isOnLockscreen) {
        CSComponent *dateView = [[%c(CSComponent) dateView] hidden:YES];
        [arg1 addComponent:dateView];
    }
}
%end

// Hide lockscreen's (quite annoying) page dots.

%hook CSFixedFooterViewController

-(id)init {
    id orig = %orig;
    fixedFooterViewController = self;
    return orig;
}

-(void)viewDidLoad{
    %orig;
    [self updateNineUnlockState];
}

%new;
-(void)updateNineUnlockState {
  self.view.alpha = 0.0;
  self.view.hidden = YES;
}

%end

// Hide quick actions (flashlight & camera) on iPhone X and later

%hook CSCoverSheetView
- (void)layoutSubviews {
  %orig;
  [self updateNineUnlockState];
}

%new
- (void)updateNineUnlockState {
  UIView *quickActions = MSHookIvar<UIView *>(self, "_quickActionsView");
  quickActions.hidden = YES;
  quickActions.alpha = 0;
}
%end

%hook CSViewController

-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2 {
    id orig = %orig;
    viewController = orig;
    return orig;
}

-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2 legibilityProvider:(id)arg3  {
    id orig = %orig;
    viewController = orig;
    return orig;
}

-(BOOL)isPasscodeLockVisible {
    return true;
}

%end

// Thanks Skitty's Six(LS) Tweak!
// Set isLocked

%hook CSCoverSheetViewController

- (void)viewWillAppear:(BOOL)arg1 {
  %orig;
  setIsOnLockscreen(!self.authenticated);
}

%end

// Force enable today-view simply because this tweak
// replace the today view with the passcode view.

%hook SBMainDisplayPolicyAggregator

-(BOOL)_allowsCapabilityLockScreenTodayViewWithExplanation:(id*)arg1 {
    return YES;
}

%end

%end

%group iOS13

%hook SBUIPasscodeLockNumberPad
-(void)_cancelButtonHit {
	%orig;
	if (scrollView) {
	   [scrollView scrollToPageAtIndex:1 animated:true];
	}
}
%end

// This basically check if we have completed scrolling
// to the right => Bring up the passcode screen

%hook CSScrollView

-(id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    scrollView = self;
    return orig;
}

- (void)_bs_didEndScrolling {
    %orig;
    if (self.currentPageIndex == 0 && self.pageRelativeScrollOffset < 1 && isOnLockscreen) {
        // Request unlock device
        [[%c(SBLockScreenManager) sharedInstance] lockScreenViewControllerRequestsUnlock];
    }
}

%end

// Completely empty the today view...

%hook CSTodayContentView

-(id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    todayContentView = self;
    return orig;
}

-(void)layoutSubviews {
    %orig;
    [self updateNineUnlockState];
}

%new;
-(void)updateNineUnlockState {
  if (isOnLockscreen) {
      self.alpha = 0.0;
      self.hidden = YES;
  } else {
      self.alpha = 1.0;
      self.hidden = NO;
  }
}

%end

// My crazy workaround for the problem where coversheet doesn't want to
// disappear after unlocking.

// It will create a minor issue when you press on a message notification
// to reply => Use passcode => It will automaticatically unlock the phone to home screen.

%hook SBPasscodeEntryTransientOverlayViewController
-(void)viewDidDisappear:(BOOL)arg1 {
  [[%c(SBLockScreenManager) sharedInstance] lockScreenViewControllerRequestsUnlock];
  // Also a fix of Coversheet not automatically scroll to
  // the Notification Center main view...
  // (Doesn't work with phones have no passcode set...)
  if (scrollView) {
      [scrollView scrollToPageAtIndex:1 animated:true];
  }
  return %orig(arg1);
}
%end

// end of iOS13 group
%end

%group iOS14

// Completely empty the today view...

%hook SBTodayViewController

- (void)viewDidAppear:(bool)arg1 {
  %orig;
  if (isOnLockscreen) [[%c(SBLockScreenManager) sharedInstance] lockScreenViewControllerRequestsUnlock];
}

- (void)viewWillLayoutSubviews {
  %orig;
  self.scrollView.hidden = isOnLockscreen;
  self.spotlightContainerView.hidden = isOnLockscreen;
}

%end

%hook SBLockScreenManager
-(BOOL)_finishUIUnlockFromSource:(int)arg1 withOptions:(id)arg2 {
  setIsOnLockscreen(false);
  return %orig;
}
%end

// My crazy workaround for the problem where coversheet doesn't want to
// disappear after unlocking.

// It will create a minor issue when you press on a message notification
// to reply => Use passcode => It will automaticatically unlock the phone to home screen.

%hook SBPasscodeEntryTransientOverlayViewController
-(void)viewDidDisappear:(BOOL)arg1 {
  [(SpringBoard *)[UIApplication sharedApplication] _simulateHomeButtonPress];
  [(SpringBoard *)[UIApplication sharedApplication] _simulateHomeButtonPress];
  return %orig(arg1);
}
%end

// end of iOS14 group
%end

// ===================== NOTIFICATIONS =========================

%group Notifications

// ---- CUSTOMIZE NOTIFICATIONS ------
// -----------------------------------

// Add separators between notifications

%hook NCNotificationShortLookView

%property (nonatomic, retain) _UITableViewCellSeparatorView *lineView;

-(void)layoutSubviews {
	%orig;
  notifContentView = self;

  if (!self.lineView) {
    self.lineView.drawsWithVibrantLightMode = NO;
    self.lineView = [[%c(_UITableViewCellSeparatorView) alloc] init];
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVibrancyEffect *vibEffect = [UIVibrancyEffect effectForBlurEffect:effect];
    [self.lineView setSeparatorEffect:vibEffect];
    self.lineView.alpha = notifSeparatorAlpha;
  }

  self.lineView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.frame.size.width, 0.5);

  // Check if it's banner of notification
  if (![((NCNotificationShortLookViewController*)[self _viewControllerForAncestor]).delegate isKindOfClass:%c(SBNotificationBannerDestination)]) {
    // Is a notification
    self.backgroundView.hidden = YES;
    if (notifEnableSeparators) {
      [self addSubview:self.lineView];
    }
  } else {
    // Is a banner
    if (bannersEnabled) {
      [self.backgroundView.layer setCornerRadius:0];
      if (self.backgroundView.layer.frame.size.width != [[UIScreen mainScreen] bounds].size.width * 2) {
        self.backgroundView.layer.frame = CGRectMake(self.backgroundView.layer.frame.origin.x - 4, self.backgroundView.layer.frame.origin.y - 5, [[UIScreen mainScreen] bounds].size.width * 2, self.backgroundView.layer.frame.size.height + 5);
      }
    }
  }
}
%end

// Create a blur view behind notifications

%hook CSCoverSheetViewController

%property (nonatomic, retain) UIView *epicBlurView;
%property (nonatomic, retain) UIVisualEffectView *blurEffect;

- (void)viewDidLoad {
  %orig;
  coversheetView = self;
  if (!self.epicBlurView) {
    self.epicBlurView = [[UIView alloc] init];
    self.epicBlurView.backgroundColor = [UIColor clearColor];
    self.blurEffect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.epicBlurView.hidden = NO;
    self.epicBlurView.alpha = 0;
    [self.epicBlurView addSubview:self.blurEffect];
  }

	[self updateViews];
}

%new
-(void)updateViews {
	self.epicBlurView.frame = [[UIScreen mainScreen] bounds];
	self.blurEffect.frame = self.epicBlurView.bounds;

  if (![self.epicBlurView isDescendantOfView:[self view]]) [[self view] insertSubview:self.epicBlurView atIndex:0];
}
%end

// Adapt to light/dark mode change

%hook CSMainPageView

-(void)layoutSubviews {

  if (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
    [UIView animateWithDuration:1.0 animations:^{
      coversheetView.blurEffect.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    }];
  } else {
    [UIView animateWithDuration:1.0 animations:^{
      coversheetView.blurEffect.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    }];
  }
}

%end

// ---- NOTIFICATIONS HANDLING -------
// -----------------------------------

// From Litten's Lisa tweak
// Detect notifications => Unhide blur view

%hook NCNotificationMasterList

- (unsigned long long)notificationCount {
    if (%orig > 0) {
      if (slideToUnlockAutoHide) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/hideSTU"), nil, nil, true);
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        coversheetView.epicBlurView.alpha = isCurrentlyActive ? 0 : 1;
      } completion:nil];
    } else {
      if (slideToUnlockAutoHide) CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/showSTU"), nil, nil, true);
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        coversheetView.epicBlurView.alpha = 0;
      } completion:nil];
    }
    return %orig;
}
%end

// ---- HIDE UNWANTED ELEMENTS -------
// -----------------------------------

// Hide DND Notification

%hook DNDNotificationsService
  -(id)initWithClientIdentifier:(id)arg1 {
    return nil;
  }
%end

// Hide notification action buttons background

%hook NCNotificationListCellActionButton
-(void)_configureBackgroundViewIfNecessary {
	%orig;
	self.backgroundView.alpha = 0;
}
%end

// Fix notifications grouping
// From Lightmann's Aeaea tweak

%hook NCNotificationListView

-(void)setSubviewPerformingGroupingAnimation:(BOOL)arg1 {
  %orig;
	if (self.grouped && self.visibleViews.count >= 2 && !notifdisableGrouping) {
		NSArray *keys = [self.visibleViews allKeys];
		for (NSNumber *key in keys) {
			UIView *value =[self.visibleViews objectForKey:key];
			int keyInt = [key intValue];
			if(keyInt == 0) {
				[value setHidden:NO];
			} else {
				[value setHidden:YES];
			}
		}
	}
	if ((!self.grouped || self.visibleViews.count < 2) && !notifdisableGrouping) {
		NSArray *keys =[self.visibleViews allKeys];
		for (NSNumber *key in keys) {
			UIView *value = [self.visibleViews objectForKey:key];
			[value setHidden:NO];
		}
	}
}

%end

// end of group
%end

%group NoNotifGrouping

// Hide group notifications buttons

%hook NCToggleControlPair
  -(void)layoutSubviews {
    self.hidden = YES;
  }
%end

%hook NCToggleControl
  -(void)layoutSubviews {
    self.hidden = YES;
  }
%end

// Hide notification groups labels

%hook NCNotificationListCoalescingHeaderCell
  -(void)layoutSubviews {
    self.hidden = YES;
  }
%end

%hook NCNotificationListCoalescingControlsCell
 -(void)layoutSubviews {
   self.hidden = YES;
 }
%end

%hook NCNotificationGroupList
-(BOOL)isGrouped {
  return NO;
}

-(void)setGrouped:(BOOL)arg1 {
  return %orig(NO);
}

-(BOOL)notificationListViewIsGroup:(id)arg1 {
  return NO;
}

-(BOOL)_isContentRevealedForNotificationRequest:(id)arg1 {
  return YES;
}
%end

%hook NCNotificationListView

- (double)_headerViewHeight { // Reduce large space between notifications
  return 0;
}

- (double)_footerViewHeight { // Reduce large space between notifications
  return 0;
}

- (BOOL)_isGrouping {
  return NO;
}

-(BOOL)isPerformingGroupingAnimation {
  return NO;
}

%end

// end of group
%end


%group NotifTest

%hook BBServer

- (id)initWithQueue:(id)arg1 {
  bbServer = %orig;
  return bbServer;
}

- (id)initWithQueue:(id)arg1 dataProviderManager:(id)arg2 syncService:(id)arg3 dismissalSyncCache:(id)arg4 observerListener:(id)arg5 utilitiesListener:(id)arg6 conduitListener:(id)arg7 systemStateListener:(id)arg8 settingsListener:(id)arg9 {
  bbServer = %orig;
  return bbServer;
}

- (void)dealloc {
  if (bbServer == self) bbServer = nil;
  %orig;
}
%end

%end

// ===================== MUSIC PLAYER =========================

%group MusicPlayer

%hook CSMainPageView

// Use auto-scroll label (marquee label) for long song names / artist names
// https://github.com/cbpowell/MarqueeLabel-ObjC/

%property (nonatomic, retain) MarqueeLabel *songTitleLabel;
%property (nonatomic, retain) MarqueeLabel *artistTitleLabel;
%property (nonatomic, retain) UIImageView *artworkImageView;
%property (nonatomic, retain) UIView *epicBlurView;
%property (nonatomic, retain) UIVisualEffectView *blurEffect;

-(id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    mainPageView = self;
    return orig;
}

-(void)layoutSubviews {
  %orig;

  // Song name (will add a "Tap to view Album name" feature in the future)
  if (!self.songTitleLabel) {
    self.songTitleLabel = [[MarqueeLabel alloc] init];
    [self.songTitleLabel setTextColor:[UIColor whiteColor]];
    [self.songTitleLabel setFont:[UIFont systemFontOfSize:22.0 weight:UIFontWeightMedium]];
    if (musicSongTitleCustom) {
      self.songTitleLabel.frame = CGRectMake(musicSongNameXPosition, musicSongNameYPosition, [[UIScreen mainScreen] bounds].size.width - 70, 30);
    } else {
      self.songTitleLabel.frame = CGRectMake(coverSheetView.frame.size.width/2 - ([[UIScreen mainScreen] bounds].size.width - 70)/2, 70, [[UIScreen mainScreen] bounds].size.width - 70, 30);
    }
    self.songTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.songTitleLabel.marqueeType = MLLeftRight;
    self.songTitleLabel.rate = 60.0f;
    self.songTitleLabel.fadeLength = 10.0f;
    self.songTitleLabel.hidden = YES;
  }

  // Song artist
  if (!self.artistTitleLabel) {
    self.artistTitleLabel = [[MarqueeLabel alloc] init];
    [self.artistTitleLabel setTextColor:[UIColor lightGrayColor]];
    [self.artistTitleLabel setFont:[UIFont systemFontOfSize:21.0 weight:UIFontWeightRegular]];
    if (musicArtistTitleCustom) {
      self.artistTitleLabel.frame = CGRectMake(musicArtistNameXPosition, musicArtistNameYPosition, [[UIScreen mainScreen] bounds].size.width - 70, 30);
    } else {
      self.artistTitleLabel.frame = CGRectMake(coverSheetView.frame.size.width/2 - ([[UIScreen mainScreen] bounds].size.width - 70)/2, 100, [[UIScreen mainScreen] bounds].size.width - 70, 30);
    }
    self.artistTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.artistTitleLabel.marqueeType = MLLeftRight;
    self.artistTitleLabel.rate = 60.0f;
    self.artistTitleLabel.fadeLength = 10.0f;
    self.artistTitleLabel.hidden = YES;
  }

  // Big artwork
  if (!self.artworkImageView) {
    float height_width = [[UIScreen mainScreen] bounds].size.width - 50;
    self.artworkImageView = [[UIImageView alloc] init];
    CGRect artworkFrame = self.frame;
    artworkFrame.size.width = height_width;
    artworkFrame.size.height = height_width;
    self.artworkImageView.frame = artworkFrame;
    [self.artworkImageView setClipsToBounds:YES];
    if (musicSongArtworkCustom) {
      self.artworkImageView.frame = CGRectMake(musicArtworkXPosition, musicArtworkYPosition, height_width, height_width);
    } else {
      self.artworkImageView.frame = CGRectMake(coverSheetView.frame.size.width/2 - height_width/2, 250, height_width, height_width);
    }
    self.artworkImageView.layer.cornerRadius = 5.0;
  }

  // The iconic player blur in iOS 9
  if (!self.epicBlurView) {
    self.epicBlurView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.epicBlurView.backgroundColor = [UIColor clearColor];
    self.epicBlurView.alpha = 0;

    self.blurEffect = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    self.blurEffect.frame = self.epicBlurView.bounds;
    self.epicBlurView.hidden = YES;
    [self.epicBlurView addSubview:self.blurEffect];
  }

  [self updateNineMusicState];
}

%new
-(void)refreshNineMusicViews {
  if (musicProgressBarCustom) {
    playerTimeControl.frame = CGRectMake(musicTimesControlsXPosition, musicTimesControlsYPosition, playerTimeControl.frame.size.width, playerTimeControl.frame.size.height);
  } else {
    playerTimeControl.frame = CGRectMake(coverSheetView.frame.size.width/2 - playerTimeControl.frame.size.width/2, 18, playerTimeControl.frame.size.width, playerTimeControl.frame.size.height);
  }

  if (musicControlButtonsCustom) {
    mediaControls.frame = CGRectMake(musicMediaControlsXPosition, musicMediaControlsYPosition, mediaControls.frame.size.width, mediaControls.frame.size.height);
  } else {
    mediaControls.frame = CGRectMake(mainPageView.epicBlurView.frame.size.width/2 - mediaControls.frame.size.width/2, 135, mediaControls.frame.size.width, mediaControls.frame.size.height);
  }

  if (musicVolumeSliderCustom) {
    volumeSlider.frame = CGRectMake(musicVolumeSliderXPosition, musicVolumeSliderYPosition, volumeSlider.frame.size.width, volumeSlider.frame.size.height);
  } else {
    volumeSlider.frame = CGRectMake(mainPageView.epicBlurView.frame.size.width/2 - volumeSlider.frame.size.width/2, 203, volumeSlider.frame.size.width, volumeSlider.frame.size.height);
  }
}

%new
-(void)updateNineMusicState {
  [self addSubview:self.epicBlurView];
  [self.epicBlurView addSubview:self.artworkImageView];
  [self.epicBlurView addSubview:self.songTitleLabel];
  [self.epicBlurView addSubview:self.artistTitleLabel];

  [self addSubview:playerTimeControl];
  [self addSubview:volumeSlider];
  [self addSubview:mediaControls];

  [self addSubview:newMediaControls];
  [self addSubview:newPlayerTimeControl];
  [self addSubview:newVolumeSlider];

  // A workaround for an issue which damages the CC Module...
  [self refreshNineMusicViews];

  [UIView animateWithDuration:0.4 animations:^(void) {
    self.epicBlurView.alpha = 1;
  } completion:nil];

  [self sendSubviewToBack:self.epicBlurView];
  [mainPageView.artworkImageView setHidden:musicHideSongArtwork];

  // Detect light/dark mode

  if (UIScreen.mainScreen.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
    [UIView animateWithDuration:1.0 animations:^{
      self.blurEffect.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
      [self.songTitleLabel setTextColor:[UIColor whiteColor]];
      [self.artistTitleLabel setTextColor:[UIColor lightGrayColor]];
    }];
    [volumeSlider removeFromSuperview];
    [self addSubview:volumeSlider];
    [newVolumeSlider removeFromSuperview];
    [self addSubview:newVolumeSlider];
  } else {
    [UIView animateWithDuration:1.0 animations:^{
      self.blurEffect.effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
      [self.songTitleLabel setTextColor:[UIColor blackColor]];
      [self.artistTitleLabel setTextColor:[UIColor colorWithWhite:0 alpha:0.6]];
    }];
    [volumeSlider removeFromSuperview];
    [self addSubview:volumeSlider];
    [newVolumeSlider removeFromSuperview];
    [self addSubview:newVolumeSlider];
  }

  // Tell NineUnlock to hide/show slide to unlock view
  if (!isCurrentlyActive) {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/showSTU"), nil, nil, true);
  } else if (isCurrentlyActive) {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/hideSTU"), nil, nil, true);
  }
}

%end

%hook CSCoverSheetView
- (void)setFrame:(CGRect)frame {
    %orig;
    coverSheetView = self;
}
%end

// ---------------------------
// ---------------------------

// Track duration/time slider

%hook MediaControlsTimeControl
- (void)layoutSubviews {
  %orig;
  MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]) {
    playerTimeControl = self;
  }
}
%end

// iOS 14.2+
%hook MRUNowPlayingTimeControlsView

-(void)setFrame:(CGRect)frame {
  MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) {
    %orig;
  } else {
    if (musicProgressBarCustom) {
      %orig(CGRectMake(musicTimesControlsXPosition, musicTimesControlsYPosition, frame.size.width, frame.size.height));
    } else {
      %orig(CGRectMake(coverSheetView.frame.size.width/2 - frame.size.width/2, 23, frame.size.width, frame.size.height));
    }
  }
}

- (void)layoutSubviews {
  %orig;
  MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && ![controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) {
    newPlayerTimeControl = self;
  }
}
%end

// Volume slider

%hook MediaControlsVolumeSlider
- (void)layoutSubviews {
  %orig;
  MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]) {
    volumeSlider = self;
    // Hide first, because it left an ugly blue circle on the lockscreen after respring
    volumeSlider.hidden = YES;
  }
}

%end

// iOS 14.2+
%hook MRUNowPlayingVolumeSlider

-(void)setFrame:(CGRect)frame {
  MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) {
    %orig;
  } else {
    if (musicVolumeSliderCustom) {
      %orig(CGRectMake(musicVolumeSliderXPosition, musicVolumeSliderYPosition, frame.size.width, frame.size.height));
    } else {
      %orig(CGRectMake(mainPageView.epicBlurView.frame.size.width/2 - frame.size.width/2, 193, frame.size.width, frame.size.height));
    }
  }
}

- (void)layoutSubviews {
  %orig;
  MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && ![controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) {
    newVolumeSlider = self;
    // Hide first, because it left an ugly blue circle on the lockscreen after respring
    newVolumeSlider.hidden = YES;
  }
}
%end

// Media Control buttons (play/pause/skip)

%hook MediaControlsTransportStackView
- (void)layoutSubviews {
	%orig;
  MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]) {
    %orig;
    mediaControls = self;
  }
}

%end

// iOS 14.2+

%hook MRUNowPlayingTransportControlsView

-(void)setFrame:(CGRect)frame {
  MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) {
    %orig;
  } else {
    if (musicControlButtonsCustom) {
      %orig(CGRectMake(musicMediaControlsXPosition, musicMediaControlsYPosition, frame.size.width, frame.size.height));
    } else {
      %orig(CGRectMake(mainPageView.epicBlurView.frame.size.width/2 - frame.size.width/2, 138, frame.size.width, frame.size.height));
    }
  }
}

- (void)layoutSubviews {
	%orig;
  MRUNowPlayingViewController *controller = (MRUNowPlayingViewController *)[self _viewControllerForAncestor];
  if ([controller respondsToSelector:@selector(delegate)] && ![controller.delegate isKindOfClass:%c(MRUControlCenterViewController)]) {
    %orig;
    newMediaControls = self;
  }
}

%end

// ----- HIDE UGLY STUFF -------
// -----------------------------

/* %hook SBStatusBarStateAggregator
-(void)_updateLockItem {}
%end */

// Hide "No older notifications" text

%hook NCNotificationListSectionRevealHintView
- (void)didMoveToWindow {
  %orig;
  self.hidden = isCurrentlyActive;
}
%end

// Hide the ugly default music player

%hook CSAdjunctItemView
-(void)_updateSizeToMimic {
	%orig;
  // From _lightmann's Vinyl tweak https://github.com/UsrLightmann/Vinyl/
  [self.heightAnchor constraintEqualToConstant:0].active = true;
  self.hidden = YES;
}
%end

%hook CSAdjunctListView
-(void)layoutSubviews {
	%orig;
  self.hidden = YES;
}
%end

// Hide the default music name / artist / artwork

%hook MediaControlsHeaderView
-(void)layoutSubviews{
	%orig;

	MRPlatterViewController *controller = (MRPlatterViewController *)[self _viewControllerForAncestor];
	if ([controller respondsToSelector:@selector(delegate)] && [controller.delegate isKindOfClass:%c(CSMediaControlsViewController)]) {
    self.hidden = YES;
	}
}
%end

// Hide Face ID Lock

%hook SBUIProudLockIconView
- (void)layoutSubviews {
  %orig;

  self.hidden = isCurrentlyActive;
  self.alpha = isCurrentlyActive ? 0.0 : 1.0;
}
%end

%hook SBUIFaceIDCameraGlyphView
- (void)layoutSubviews {
  %orig;

  self.hidden = isCurrentlyActive;
  self.alpha = isCurrentlyActive ? 0.0 : 1.0;
}
%end

// ----- HOW NOTIFICATIONS BEHAVE IN IOS 9? -------
// ------------------------------------------------

// Detect notifications => Hide / unhide the artwork

%hook NCNotificationMasterList

// From Litten's Lisa tweak [Fixed November 26th]
- (unsigned long long)notificationCount {
    notificationCount = %orig;
    if (%orig > 0) {
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainPageView.artworkImageView setAlpha:musicHideSongArtwork ? 1 : 0];
      } completion:nil];
    } else {
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainPageView.artworkImageView setAlpha:1];
      } completion:nil];
    }
    return %orig;
}

%end

// Positioning the notification scroll view

// Litten's 2nd pull request on GitHub (edited a little bit)

%hook CSCombinedListViewController
- (double)_minInsetsToPushDateOffScreen { // lower notifications while playing
  if (!isCurrentlyActive) return %orig;
  double orig = %orig;
  return orig + (isCurrentlyActive ? 40.0 : 0.0);
}

- (UIEdgeInsets)_listViewDefaultContentInsets { // lower notifications while playing
  if (!isCurrentlyActive) return %orig;
  UIEdgeInsets originalInsets = %orig;
  originalInsets.top += isCurrentlyActive ? 40.0 : 0.0;
  return originalInsets;
}
%end

%hook NCNotificationListView

- (void)_scrollViewWillBeginDragging {
	%orig;

  lastContentOffset = self.contentOffset.y;

  if (isCurrentlyActive == YES && notificationCount > 0) {
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
      [mainPageView.songTitleLabel setAlpha:0];
      [mainPageView.artistTitleLabel setAlpha:0];
      [volumeSlider setAlpha:0];
      [newVolumeSlider setAlpha:0];
      [mediaControls setAlpha:0];
      [newMediaControls setAlpha:0];
      [playerTimeControl setAlpha:0];
      [newPlayerTimeControl setAlpha:0];
      [volumeSlider setHidden:YES];
      [newVolumeSlider setHidden:YES];
    } completion:nil];
  }
}

- (void)_scrollViewDidEndDraggingWithDeceleration:(BOOL)arg1 {
	%orig;

  // Show/hide buttons upon notification list scroll (https://stackoverflow.com/a/56429397)
  // Problem: Still hide buttons with no notifications [Fixed November 26th]

  if (lastContentOffset < self.contentOffset.y) {
    if (isCurrentlyActive == YES && notificationCount > 0) {
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainPageView.songTitleLabel setAlpha:0];
        [mainPageView.artistTitleLabel setAlpha:0];
        [volumeSlider setAlpha:0];
        [newVolumeSlider setAlpha:0];
        [mediaControls setAlpha:0];
        [newMediaControls setAlpha:0];
        [playerTimeControl setAlpha:0];
        [newPlayerTimeControl setAlpha:0];
        [volumeSlider setHidden:YES];
        [newVolumeSlider setHidden:YES];
      } completion:nil];
    }
  } else if (lastContentOffset > self.contentOffset.y) {
    if (isCurrentlyActive == YES) {
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainPageView.songTitleLabel setAlpha:1];
        [mainPageView.artistTitleLabel setAlpha:1];
        [volumeSlider setAlpha:1];
        [newVolumeSlider setAlpha:1];
        [mediaControls setAlpha:1];
        [newMediaControls setAlpha:1];
        [playerTimeControl setAlpha:1];
        [newPlayerTimeControl setAlpha:1];
        [volumeSlider setHidden:musicHideVolumeSlider];
        [newVolumeSlider setHidden:musicHideVolumeSlider];
      } completion:nil];
    }
  } else if (lastContentOffset > self.contentOffset.y && self._sf_isScrolledPastTop == YES) {
    if (isCurrentlyActive == YES) {
      [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [mainPageView.songTitleLabel setAlpha:1];
        [mainPageView.artistTitleLabel setAlpha:1];
        [volumeSlider setAlpha:1];
        [newVolumeSlider setAlpha:1];
        [mediaControls setAlpha:1];
        [newMediaControls setAlpha:0];
        [playerTimeControl setAlpha:1];
        [newPlayerTimeControl setAlpha:1];
        [volumeSlider setHidden:musicHideVolumeSlider];
        [newVolumeSlider setHidden:musicHideVolumeSlider];
      } completion:nil];
    }
  }
}
%end


// ----- GET SONG DATA -------
// ---------------------------

%hook SBMediaController

// From Litten's Lobelias tweak
// https://github.com/Litteeen/Lobelias/

- (void)setNowPlayingInfo:(id)arg1 {
  %orig;
    [mainPageView refreshNineMusicViews];
    MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
        if (information) {
            NSDictionary* dict = (__bridge NSDictionary *)information;
            NSString *songTitle = [NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoTitle]];
            NSString *artistTitle = [NSString stringWithFormat:@"%@", [dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtist]];
            UIImage *currentArtwork = [UIImage imageWithData:[dict objectForKey:(__bridge NSString*)kMRMediaRemoteNowPlayingInfoArtworkData]];

            mainPageView.songTitleLabel.text = songTitle;
            mainPageView.artistTitleLabel.text = artistTitle;

            if (dict) {
              if (dict[(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtworkData]) {
                [UIView transitionWithView:mainPageView.artworkImageView duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    mainPageView.artworkImageView.image = currentArtwork;
                } completion:nil];
              }
              [mainPageView.epicBlurView setHidden:NO];
              [mainPageView.songTitleLabel setHidden:musicHideSongTitle];
              [mainPageView.artistTitleLabel setHidden:musicHideArtistTitle];
              [volumeSlider setHidden:musicHideVolumeSlider];
              [newVolumeSlider setHidden:musicHideVolumeSlider];
              [mediaControls setHidden:musicHideMediaControls];
              [newMediaControls setHidden:musicHideMediaControls];
              [playerTimeControl setHidden:musicHideTimeControls];
              [newPlayerTimeControl setHidden:musicHideTimeControls];
              isCurrentlyActive = YES;

              // Tell NineUnlock to hide
              CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/hideSTU"), nil, nil, true);
            }
        } else {
          [mainPageView.epicBlurView setHidden:YES];
          [mainPageView.songTitleLabel setHidden:YES];
          [mainPageView.artistTitleLabel setHidden:YES];
          [volumeSlider setHidden:YES];
          [newVolumeSlider setHidden:YES];
          [mediaControls setHidden:YES];
          [newMediaControls setHidden:YES];
          [playerTimeControl setHidden:YES];
          [newPlayerTimeControl setHidden:YES];
          isCurrentlyActive = NO;

          // Tell NineUnlock to show
          CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/showSTU"), nil, nil, true);
        }
    });
}
%end

// Reload data after respring

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;
	[[%c(SBMediaController) sharedInstance] setNowPlayingInfo:0];
}
%end

%end

%group PlayLockSound

// Play iOS 9 Locksound

%hook SBSleepWakeHardwareButtonInteraction
- (void)_playLockSound {
    if (lockSound) {
      if (!(MSHookIvar<NSUInteger>([objc_getClass("SBLockStateAggregator") sharedInstance], "_lockState") == 0)) return;
      SystemSoundID sound = 0;
      AudioServicesDisposeSystemSoundID(sound);
      AudioServicesCreateSystemSoundID((CFURLRef) CFBridgingRetain([NSURL fileURLWithPath:@"/Library/Application Support/NineLS/lock.caf"]), &sound);
      AudioServicesPlaySystemSound((SystemSoundID)sound);
    } else {
      %orig;
    }
}
%end

%end

static void displayStatusChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    setIsOnLockscreen(true);

    [mainPageView.artworkImageView setHidden:musicHideSongArtwork];

    // Check if music app is active => prevent safe mode
    if ([[%c(SBMediaController) sharedInstance] hasTrack]) {
      [mainPageView.epicBlurView setHidden:NO];
      [mainPageView.songTitleLabel setHidden:musicHideSongTitle];
      [mainPageView.artistTitleLabel setHidden:musicHideArtistTitle];
      [volumeSlider setHidden:musicHideVolumeSlider];
      [newVolumeSlider setHidden:musicHideVolumeSlider];
      [mediaControls setHidden:musicHideMediaControls];
      [newMediaControls setHidden:musicHideMediaControls];
      [playerTimeControl setHidden:musicHideTimeControls];
      [newPlayerTimeControl setHidden:musicHideTimeControls];
      isCurrentlyActive = YES;

      // Tell Slide to Unlock to hide
      CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/hideSTU"), nil, nil, true);
    } else {
      [mainPageView.epicBlurView setHidden:YES];
      [mainPageView.songTitleLabel setHidden:YES];
      [mainPageView.artistTitleLabel setHidden:YES];
      [volumeSlider setHidden:YES];
      [mediaControls setHidden:YES];
      [newMediaControls setHidden:YES];
      [playerTimeControl setHidden:YES];
      [newPlayerTimeControl setHidden:YES];
      isCurrentlyActive = NO;

      // Tell Slide to Unlock to show
      CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("me.minhton.ninels/showSTU"), nil, nil, true);
    }
}

%ctor{
  initNineLS();

  if (enableNineLS) {

    if (notifEnabled) {
      %init(Notifications);
      %init(NotifTest);
      if (notifdisableGrouping) {
        %init(NoNotifGrouping);
      }
      CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)NineLSTestNotifs, (CFStringRef)@"me.minhton.ninels/TestNotifications", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
      CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)NineLSTestBanner, (CFStringRef)@"me.minhton.ninels/TestBanner", NULL, (CFNotificationSuspensionBehavior)kNilOptions);
    }

    if (slideToUnlockEnabled) {
      %init(SlideToUnlock);
      // update Slide to unlock
      if (mainPageView) {
        [mainPageView.SlideToUnlockView setText:slideToUnlockText];
        [mainPageView.SlideToUnlockView setNeedsTextUpdate:true];
        [mainPageView.SlideToUnlockView updateText];
      }
      if ([[[UIDevice currentDevice] systemVersion] floatValue] < 14.0) {
        %init(iOS13);
      } else {
        %init(iOS14);
      }
    }

    if (musicEnabled) %init(MusicPlayer);

    %init(PlayLockSound);

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)initNineLS, CFSTR("me.minhton.ninels/prefsupdated"), NULL, CFNotificationSuspensionBehaviorCoalesce);
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, displayStatusChanged, CFSTR("com.apple.iokit.hid.displayStatus"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  }
}

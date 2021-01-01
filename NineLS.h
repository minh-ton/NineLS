#import "substrate.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <notify.h>
#import <dlfcn.h>
#import "support/MarqueeLabel.h"
#import <MediaRemote/MediaRemote.h>
#import <AudioToolbox/AudioServices.h>
#import <SpringBoard/SpringBoard.h>

// ====================== SLIDE TO UNLOCK ===========================
// =================================================================

@interface UIColor(Hexadecimal)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
@end

@interface _UIGlintyStringView : UIView {

	BOOL _animationRepeats;
	BOOL _adjustsFontSizeToFitWidth;
	BOOL _hasCustomBackgroundColor;
	BOOL _highlight;
	BOOL _allowsLuminanceAdjustments;
	BOOL _usesBackgroundDimming;
	BOOL _needsTextUpdate;
	BOOL _animating;
	BOOL _fading;
	BOOL _showing;
	int _textIndex;
	NSString* _text;
	UIFont* _font;
	NSString* _textLanguage;
	UIView* _backgroundView;
	UIColor* _backgroundColor;
	UIColor* _chevronBackgroundColor;
	long long _chevronStyle;
	double _horizontalPadding;
	UILabel* _label;
	UIView* _spotlightView;
	UIImage* _chevron;
	UIView* _highlightView;
	UIView* _effectView;
	UIView* _blurView;
	UIView* _shimmerImageView;
	UIView* _reflectionImageView;
	double _blurAlpha;
	NSMutableSet* _blurHiddenRequesters;
	CGSize _labelSize;
	CGRect _chevronFrame;

}

@property (assign,nonatomic) BOOL needsTextUpdate;                                    //@synthesize needsTextUpdate=_needsTextUpdate - In the implementation block
@property (nonatomic,retain) UILabel * label;                                         //@synthesize label=_label - In the implementation block
@property (assign,nonatomic) CGSize labelSize;                                        //@synthesize labelSize=_labelSize - In the implementation block
@property (nonatomic,retain) UIView * spotlightView;                                  //@synthesize spotlightView=_spotlightView - In the implementation block
@property (assign,nonatomic) int textIndex;                                           //@synthesize textIndex=_textIndex - In the implementation block
@property (nonatomic,retain) UIImage * chevron;                                       //@synthesize chevron=_chevron - In the implementation block
@property (assign,nonatomic) CGRect chevronFrame;                                     //@synthesize chevronFrame=_chevronFrame - In the implementation block
@property (nonatomic,retain) UIView * highlightView;                                  //@synthesize highlightView=_highlightView - In the implementation block
@property (assign,nonatomic) BOOL animating;                                          //@synthesize animating=_animating - In the implementation block
@property (assign,nonatomic) BOOL fading;                                             //@synthesize fading=_fading - In the implementation block
@property (assign,nonatomic) BOOL showing;                                            //@synthesize showing=_showing - In the implementation block
@property (nonatomic,retain) UIView * effectView;                                     //@synthesize effectView=_effectView - In the implementation block
@property (nonatomic,retain) UIView * blurView;                                       //@synthesize blurView=_blurView - In the implementation block
@property (nonatomic,retain) UIView * shimmerImageView;                               //@synthesize shimmerImageView=_shimmerImageView - In the implementation block
@property (nonatomic,retain) UIView * reflectionImageView;                            //@synthesize reflectionImageView=_reflectionImageView - In the implementation block
@property (assign,nonatomic) double blurAlpha;                                        //@synthesize blurAlpha=_blurAlpha - In the implementation block
@property (nonatomic,retain) NSMutableSet * blurHiddenRequesters;                     //@synthesize blurHiddenRequesters=_blurHiddenRequesters - In the implementation block
@property (nonatomic,copy) NSString * text;                                           //@synthesize text=_text - In the implementation block
@property (nonatomic,retain) UIFont * font;                                           //@synthesize font=_font - In the implementation block
@property (nonatomic,copy) NSString * textLanguage;                                   //@synthesize textLanguage=_textLanguage - In the implementation block
@property (nonatomic,readonly) CGRect labelFrame;
@property (nonatomic,retain) UIView * backgroundView;                                 //@synthesize backgroundView=_backgroundView - In the implementation block
@property (nonatomic,retain) UIColor * backgroundColor;                               //@synthesize backgroundColor=_backgroundColor - In the implementation block
@property (nonatomic,retain) UIColor * chevronBackgroundColor;                        //@synthesize chevronBackgroundColor=_chevronBackgroundColor - In the implementation block
@property (assign,nonatomic) BOOL animationRepeats;                                   //@synthesize animationRepeats=_animationRepeats - In the implementation block
@property (assign,nonatomic) BOOL adjustsFontSizeToFitWidth;                          //@synthesize adjustsFontSizeToFitWidth=_adjustsFontSizeToFitWidth - In the implementation block
@property (assign,nonatomic) BOOL hasCustomBackgroundColor;                           //@synthesize hasCustomBackgroundColor=_hasCustomBackgroundColor - In the implementation block
@property (assign,nonatomic) long long chevronStyle;                                  //@synthesize chevronStyle=_chevronStyle - In the implementation block
@property (assign,nonatomic) double horizontalPadding;                                //@synthesize horizontalPadding=_horizontalPadding - In the implementation block
@property (assign,nonatomic) BOOL highlight;                                          //@synthesize highlight=_highlight - In the implementation block
@property (assign,nonatomic) BOOL allowsLuminanceAdjustments;                         //@synthesize allowsLuminanceAdjustments=_allowsLuminanceAdjustments - In the implementation block
@property (assign,nonatomic) BOOL usesBackgroundDimming;                              //@synthesize usesBackgroundDimming=_usesBackgroundDimming - In the implementation block
-(void)layoutSubviews;
-(void)hide;
-(void)show;
-(void)setLegibilitySettings:(id)arg1;
-(void)setBackgroundColor:(UIColor *)arg1 ;
-(UIColor *)backgroundColor;
-(void)dealloc;
-(void)didMoveToWindow;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(id)_highlightColor;
-(NSString *)text;
-(void)setText:(NSString *)arg1 ;
-(void)setFont:(UIFont *)arg1 ;
-(void)setBackgroundView:(UIView *)arg1 ;
-(UIView *)backgroundView;
-(void)startAnimating;
-(UIFont *)font;
-(void)setHighlightView:(UIView *)arg1 ;
-(UIView *)highlightView;
-(BOOL)isAnimating;
-(void)stopAnimating;
-(void)setAnimating:(BOOL)arg1 ;
-(void)setAdjustsFontSizeToFitWidth:(BOOL)arg1 ;
-(UILabel *)label;
-(void)setLabel:(UILabel *)arg1 ;
-(UIView *)effectView;
-(BOOL)adjustsFontSizeToFitWidth;
-(void)fadeOutWithDuration:(double)arg1 ;
-(BOOL)animating;
-(void)setEffectView:(UIView *)arg1 ;
-(void)setChevronStyle:(long long)arg1 ;
-(void)updateText;
-(void)setNeedsTextUpdate:(BOOL)arg1 ;
-(BOOL)hasCustomBackgroundColor;
-(void)setBlurAlpha:(double)arg1 ;
-(UIView *)blurView;
-(void)updateBlurForHiddenRequesters;
-(BOOL)fading;
-(void)addGlintyAnimations;
-(void)removeGlintyAnimations;
-(void)hideEffects;
-(void)hideBlur;
-(void)setShowing:(BOOL)arg1 ;
-(void)showEffects;
-(void)showBlur;
-(void)setFading:(BOOL)arg1 ;
-(void)fadeInWithDuration:(double)arg1 ;
-(id)_chevronImageForStyle:(long long)arg1 ;
-(void)setChevron:(UIImage *)arg1 ;
-(void)updateTextWithBounds:(CGRect)arg1 ;
-(double)_chevronWidthWithPadding;
-(double)_chevronWidthWithPaddingCompression:(double)arg1 ;
-(double)_chevronHeightWithMaxOffset;
-(void)_updateLabelWithFrame:(CGRect)arg1 ;
-(double)_chevronVerticalOffset;
-(BOOL)allowsLuminanceAdjustments;
-(UIImage *)chevron;
-(id)shapeViewForCharactersInString:(id)arg1 withFont:(id)arg2 centeredInFrame:(CGRect)arg3 ;
-(void)setShimmerImageView:(UIView *)arg1 ;
-(void)setReflectionImageView:(UIView *)arg1 ;
-(BOOL)usesBackgroundDimming;
-(void)setBlurView:(UIView *)arg1 ;
-(double)blurAlpha;
-(UIView *)shimmerImageView;
-(UIView *)reflectionImageView;
-(void)addShimmerAnimationToLayer:(id)arg1 ;
-(void)addReflectionAnimationToLayer:(id)arg1 ;
-(id)_highlightCompositingFilter;
-(BOOL)needsTextUpdate;
-(CGSize)_labelSizeThatFits:(CGSize)arg1 ;
-(double)_chevronPadding;
-(double)baselineOffsetFromBottomWithSize:(CGSize)arg1 ;
-(id)initWithText:(id)arg1 andFont:(id)arg2 ;
-(void)setTextLanguage:(NSString *)arg1 ;
-(void)setBlurHidden:(BOOL)arg1 forRequester:(id)arg2 ;
-(void)fadeOut;
-(void)fadeIn;
-(void)setHighlight:(BOOL)arg1 ;
-(void)setHorizontalPadding:(double)arg1 ;
-(void)_updateHighlight;
-(CGRect)labelFrame;
-(CGRect)chevronFrame;
-(double)baselineOffsetFromBottom;
-(NSString *)textLanguage;
-(UIColor *)chevronBackgroundColor;
-(void)setChevronBackgroundColor:(UIColor *)arg1 ;
-(BOOL)animationRepeats;
-(void)setAnimationRepeats:(BOOL)arg1 ;
-(void)setHasCustomBackgroundColor:(BOOL)arg1 ;
-(long long)chevronStyle;
-(double)horizontalPadding;
-(BOOL)highlight;
-(void)setAllowsLuminanceAdjustments:(BOOL)arg1 ;
-(void)setUsesBackgroundDimming:(BOOL)arg1 ;
-(CGSize)labelSize;
-(void)setLabelSize:(CGSize)arg1 ;
-(UIView *)spotlightView;
-(void)setSpotlightView:(UIView *)arg1 ;
-(int)textIndex;
-(void)setTextIndex:(int)arg1 ;
-(void)setChevronFrame:(CGRect)arg1 ;
-(NSMutableSet *)blurHiddenRequesters;
-(void)setBlurHiddenRequesters:(NSMutableSet *)arg1 ;
@end

@interface CSPasscodeViewController : UIViewController
-(void)performCustomTransitionToVisible:(BOOL)arg1 withAnimationSettings:(id)arg2 completion:(/*^block*/id)arg3 ;
-(void)aggregateBehavior:(id)arg1 ;
-(id)displayLayoutElementIdentifier;
-(void)setUseBiometricPresentation:(BOOL)arg1 ;
-(void)setBiometricButtonsInitiallyVisible:(BOOL)arg1 ;

@end

@interface CSTodayPageViewController : UIViewController
@end

@interface SBPasscodeEntryTransientOverlayViewController : UIView
@end

@interface SBUILegibilityLabel : UILabel
@end

@interface CSComponent : NSObject
+(id)dateView;
-(id)hidden:(BOOL)arg1 ;
@end

@interface CSAppearance : NSObject
-(void)addComponent:(id)arg1;
@end

@interface NCNotificationListSectionRevealHintView : UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface CSPageControl : UIView
-(void)updateNineUnlockState;
@end

@interface CSTodayContentView : UIView
-(void)updateNineUnlockState;
@end

@interface SBFTouchPassThroughView : UIView
@end

@interface SBTodayViewController : UIView
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) SBFTouchPassThroughView *spotlightContainerView;
@end

@interface SBHRootSidebarController : UIView
@end

@interface _UILegibilitySettings : NSObject
@property (nonatomic,retain) UIColor * primaryColor;
@end

@interface CSViewController : UIViewController
@property (assign,getter=isAuthenticated,nonatomic) BOOL authenticated;
-(id)_passcodeViewController;
-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2 ;
-(id)initWithPageViewControllers:(id)arg1 mainPageContentViewController:(id)arg2 legibilityProvider:(id)arg3 ;
@property (nonatomic,readonly) _UILegibilitySettings * legibilitySettings;

@end

@interface CSScrollView : UIView
@property (assign,nonatomic) NSUInteger currentPageIndex;
-(BOOL)resetContentOffsetToCurrentPage;
-(void)_layoutScrollView;
-(void)layoutPages;
-(void)layoutSubviews;
-(void)setCurrentPageIndex:(NSUInteger)idx;
-(BOOL)scrollToPageAtIndex:(unsigned long long)arg1 animated:(BOOL)arg2 ;
-(id)initWithFrame:(CGRect)arg1 ;
-(void)_bs_didEndScrolling;
-(void)_bs_didScrollWithContext:(id)arg1 ;
-(double)pageRelativeScrollOffset;

@end

@interface CSTeachableMomentsContainerViewController : UIViewController
-(void)updateNineUnlockState;
@end

@interface SBUIPasscodeLockNumberPad : UIView

-(void)setVisible:(BOOL)arg1 animated:(BOOL)arg2 ;
-(void)_cancelButtonHit;

@end

@interface CSCoverSheetView : UIView
- (void)updateNineUnlockState;
@end

@interface SBDashBoardQuickActionsButton : UIView
@end

@interface CSFixedFooterViewController : UIViewController {

	NSString* _cachedMesaFailureText;
	BOOL _temporaryMesaFailureTextActive;
	BOOL _authenticatedSinceFingerOn;

}

@property (nonatomic,readonly) UIView * fixedFooterView;
@property (readonly) unsigned long long hash;
@property (readonly) Class superclass;
@property (copy,readonly) NSString * description;
@property (copy,readonly) NSString * debugDescription;
+(Class)viewClass;
-(void)dashBoardStatusTextViewControllerContentDidChange:(id)arg1 ;
-(UIView *)fixedFooterView;
-(void)updateCallToActionForMesaMatchFailure;
-(void)_addCallToAction;
-(void)_addStatusTextViewControllerIfNecessary;
-(void)_updateCallToActionTextAnimated:(BOOL)arg1 ;
-(id)init;
-(BOOL)handleEvent:(id)arg1 ;
-(void)viewDidLoad;
-(void)viewWillAppear:(BOOL)arg1 ;
-(void)viewDidAppear:(BOOL)arg1 ;
-(void)viewDidDisappear:(BOOL)arg1 ;
-(void)updateNineUnlockState;
@end

@interface SBCoverSheetSlidingViewController : UIViewController

-(void)_handleDismissGesture:(id)arg1 ;
-(void)setPresented:(BOOL)arg1 animated:(BOOL)arg2 withCompletion:(/*^block*/id)arg3 ;

@end

@interface SBCoverSheetPrimarySlidingViewController : SBCoverSheetSlidingViewController

@end

// ====================== Notifications ===========================
// =================================================================

// test notifications
@interface BBAction : NSObject
+ (id)actionWithLaunchBundleID:(id)arg1 callblock:(id)arg2;
@end

@interface BBBulletin : NSObject
@property(nonatomic, copy)NSString* sectionID;
@property(nonatomic, copy)NSString* recordID;
@property(nonatomic, copy)NSString* publisherBulletinID;
@property(nonatomic, copy)NSString* title;
@property(nonatomic, copy)NSString* message;
@property(nonatomic, retain)NSDate* date;
@property(assign, nonatomic)BOOL clearable;
@property(nonatomic)BOOL showsMessagePreview;
@property(nonatomic, copy)BBAction* defaultAction;
@property(nonatomic, copy)NSString* bulletinID;
@property(nonatomic, retain)NSDate* lastInterruptDate;
@property(nonatomic, retain)NSDate* publicationDate;
@end

@interface BBServer : NSObject
- (void)publishBulletin:(BBBulletin *)arg1 destinations:(NSUInteger)arg2 alwaysToLockScreen:(BOOL)arg3;
- (void)publishBulletin:(id)arg1 destinations:(unsigned long long)arg2;
@end

@interface BBObserver : NSObject
@end

@interface NCBulletinNotificationSource : NSObject
- (BBObserver *)observer;
@end

@interface SBNCNotificationDispatcher : NSObject
- (NCBulletinNotificationSource *)notificationSource;
@end

@interface SBLockScreenManager : NSObject
+(id)sharedInstance;
-(void)lockScreenViewControllerRequestsUnlock;
-(void)lockUIFromSource:(int)arg1 withOptions:(id)arg2 ;
@end

@interface _UITableViewCellSeparatorView : UIView
@property (nonatomic) BOOL drawsWithVibrantLightMode;
-(void)setSeparatorEffect:(UIVisualEffect *)arg1 ;
@end

@interface NCNotificationShortLookViewController : UIViewController
@property (nonatomic, weak) id delegate;
@end

@interface NCNotificationListView : UIScrollView
@property (assign,getter=isGrouped,nonatomic) BOOL grouped;
@property (nonatomic, strong, readwrite) NSMutableDictionary * visibleViews;
@property (nonatomic, readwrite) BOOL _sf_isScrolledPastTop;
@end

@interface MTMaterialView : UIView
@end

@interface NCNotificationShortLookView : UIView
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) _UITableViewCellSeparatorView *lineView;
-(void)updateViews;
@end

@interface NCNotificationListCellActionButton : UIControl
@property(nonatomic, retain) MTMaterialView *backgroundView;
@end

@interface NCToggleControlPair: UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface NCToggleControl: UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface NCNotificationListCoalescingHeaderCell: UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface NCNotificationListCoalescingControlsCell: UIView
@property (nonatomic, assign, readwrite, getter = isHidden) BOOL hidden;
@end

@interface CSCoverSheetViewController : UIViewController
@property (assign,getter=isAuthenticated,nonatomic) BOOL authenticated;
@property (nonatomic, retain) UIView *epicBlurView;
@property (nonatomic, retain) UIVisualEffectView *blurEffect;
-(void)updateViews;
@end

// ====================== Music Player ===========================
// =================================================================

@interface UIView (Private)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface MRPlatterViewController : UIViewController
@property (assign,nonatomic) id delegate;
@end

@interface MRUNowPlayingViewController : UIViewController
@property (assign,nonatomic) id delegate;
@end

@interface CSMediaControlsViewController : UIViewController
@end

@interface MediaControlsTimeControl : UIView
@end

@interface MRUNowPlayingTimeControlsView : UIView
@end

@interface MediaControlsTransportStackView : UIView
@end

@interface MRUNowPlayingTransportControlsView : UIView
@end

@interface CSMainPageView : UIView
@property (nonatomic, retain) MarqueeLabel *songTitleLabel;
@property (nonatomic, retain) MarqueeLabel *artistTitleLabel;
@property (nonatomic, retain) UIImageView *artworkImageView;
@property (nonatomic, retain) UIView *epicBlurView;
@property (nonatomic, retain) UIVisualEffectView *blurEffect;
@property (nonatomic, retain) _UIGlintyStringView *SlideToUnlockView;
-(void)updateNineUnlockState;
-(void)updateNineMusicState;
-(void)refreshNineMusicViews;
@end

@interface MediaControlsVolumeSlider : UIView
@end

@interface MRUNowPlayingVolumeSlider : UIView
@end

@interface MediaControlsHeaderView : UIView
@end

@interface CSAdjunctItemView : UIView
@end

@interface CSAdjunctListView : UIView
@end

@interface SBMediaController : NSObject
+ (id)sharedInstance;
- (void)setNowPlayingInfo:(id)arg1;
- (BOOL)hasTrack;
@end

@interface PLPlatterView : UIView
@property (nonatomic,retain) UIView * backgroundView;
@end

@interface SBUIProudLockIconView: UIView
@end

@interface SBUIFaceIDCameraGlyphView: UIView
@end

@interface NCNotificationListStalenessEventTracker : NSObject
@end

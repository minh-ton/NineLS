#import <Preferences/PSHeaderFooterView.h>

@interface NineLSRootListHeaderView : UITableViewHeaderFooterView <PSHeaderFooterView> {
	UIImageView* _headerImageView;
	CGFloat _currentWidth;
	CGFloat _aspectRatio;
}

@end

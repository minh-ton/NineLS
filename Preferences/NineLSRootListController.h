#import <Preferences/PSListController.h>
#import <Cephei/HBPreferences.h>

@interface NineLSRootListController : PSListController
@property (nonatomic, retain) UIBarButtonItem *respringButton;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
- (void)respring:(id)sender;
@end

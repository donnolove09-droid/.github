#import <UIKit/UIKit.h>

// ASNLIGHT UI-only sample.
// This project intentionally contains no game-memory access, ESP tracking,
// aimbot, Silent Aim, AimKill, damage manipulation, or game-function hooks.

@interface ASNLIGHTPanel : UIWindow
@property(nonatomic, strong) UIButton *launcher;
@property(nonatomic, strong) UIView *panel;
@property(nonatomic, strong) UISegmentedControl *tabs;
@property(nonatomic, strong) UIView *content;
@end

@implementation ASNLIGHTPanel

- (instancetype)init {
    self = [super initWithFrame:UIScreen.mainScreen.bounds];
    if (!self) return nil;
    self.windowLevel = UIWindowLevelAlert + 10;
    self.backgroundColor = UIColor.clearColor;
    self.rootViewController = [UIViewController new];
    self.rootViewController.view.backgroundColor = UIColor.clearColor;
    [self buildLauncher];
    [self buildPanel];
    self.hidden = NO;
    return self;
}

- (UIColor *)red { return [UIColor colorWithRed:0.95 green:0.02 blue:0.10 alpha:1]; }
- (UIColor *)dark { return [UIColor colorWithRed:0.035 green:0.018 blue:0.025 alpha:0.97]; }

- (void)buildLauncher {
    self.launcher = [UIButton buttonWithType:UIButtonTypeSystem];
    self.launcher.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 76, 180, 60, 60);
    self.launcher.backgroundColor = self.dark;
    self.launcher.layer.cornerRadius = 30;
    self.launcher.layer.borderWidth = 2;
    self.launcher.layer.borderColor = self.red.CGColor;
    [self.launcher setTitle:@"AS" forState:UIControlStateNormal];
    [self.launcher setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.launcher.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.launcher addTarget:self action:@selector(togglePanel) forControlEvents:UIControlEventTouchUpInside];
    [self.rootViewController.view addSubview:self.launcher];
}

- (void)buildPanel {
    CGFloat w = MIN(UIScreen.mainScreen.bounds.size.width - 28, 560);
    CGFloat h = 340;
    self.panel = [[UIView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width-w)/2,
                                                          (UIScreen.mainScreen.bounds.size.height-h)/2, w, h)];
    self.panel.backgroundColor = self.dark;
    self.panel.layer.cornerRadius = 20;
    self.panel.layer.borderWidth = 2;
    self.panel.layer.borderColor = self.red.CGColor;
    self.panel.hidden = YES;
    self.panel.clipsToBounds = YES;
    [self.rootViewController.view addSubview:self.panel];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, w-70, 42)];
    title.text = @"ASNLIGHT";
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont boldSystemFontOfSize:25];
    [self.panel addSubview:title];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(w-52, 8, 40, 40);
    [close setTitle:@"×" forState:UIControlStateNormal];
    [close setTitleColor:self.red forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [close addTarget:self action:@selector(togglePanel) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:close];

    self.tabs = [[UISegmentedControl alloc] initWithItems:@[@"ESP UI", @"Aimbot UI", @"Thông tin"]];
    self.tabs.frame = CGRectMake(14, 58, w-28, 36);
    self.tabs.selectedSegmentIndex = 0;
    self.tabs.tintColor = self.red;
    [self.tabs addTarget:self action:@selector(tabChanged) forControlEvents:UIControlEventValueChanged];
    [self.panel addSubview:self.tabs];

    self.content = [[UIView alloc] initWithFrame:CGRectMake(14, 104, w-28, h-118)];
    self.content.backgroundColor = [UIColor colorWithWhite:0.08 alpha:1];
    self.content.layer.cornerRadius = 14;
    [self.panel addSubview:self.content];
    [self showTab:0];
}

- (void)showTab:(NSInteger)index {
    [self.content.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    NSArray *rows = @[];
    if (index == 0) rows = @[@"ESP display (UI demo)", @"Box indicator (UI demo)", @"Line indicator (UI demo)", @"Name label (UI demo)", @"Distance label (UI demo)", @"Health label (UI demo)", @"Player count (UI demo)", @"Show bot (UI demo)"];
    if (index == 1) rows = @[@"Aimbot panel (UI demo)", @"Silent Aim (UI demo)", @"AimKill (UI demo)", @"Aim body part: Head / Neck / Body", @"Aim mode: Always / Fire / Scope / F+S", @"FOV control (UI demo)"];
    if (index == 2) rows = @[@"NHÀ PHÁT TRIỂN", @"ASEANLIGHT", @"TELEGRAM", @"@thelightasean", @"ASNLIGHT • UI EDITION"];

    CGFloat y = 12;
    for (NSString *row in rows) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, y, self.content.bounds.size.width-28, 30)];
        label.text = row;
        label.textColor = (index == 2 && ( [row isEqualToString:@"ASEANLIGHT"] || [row isEqualToString:@"@thelightasean"])) ? self.red : UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        [self.content addSubview:label];
        y += 34;
    }
    if (index == 2) {
        UILabel *note = [[UILabel alloc] initWithFrame:CGRectMake(14, y+2, self.content.bounds.size.width-28, 40)];
        note.text = @"Các mục trên chỉ là giao diện minh họa.";
        note.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        note.font = [UIFont systemFontOfSize:12];
        [self.content addSubview:note];
    }
}

- (void)tabChanged { [self showTab:self.tabs.selectedSegmentIndex]; }
- (void)togglePanel { self.panel.hidden = !self.panel.hidden; }
@end

static ASNLIGHTPanel *gASNLIGHTPanel;

%ctor {
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!gASNLIGHTPanel) gASNLIGHTPanel = [[ASNLIGHTPanel alloc] init];
        });
    }
}

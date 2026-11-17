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

    self.windowLevel = UIWindowLevelAlert + 100; // cao hơn để không bị game đè
    self.backgroundColor = UIColor.clearColor;
    self.userInteractionEnabled = YES;
    self.rootViewController = [UIViewController new];
    self.rootViewController.view.backgroundColor = UIColor.clearColor;
    self.rootViewController.view.userInteractionEnabled = YES;

    [self buildLauncher];
    [self buildPanel];

    self.hidden = NO;
    [self makeKeyAndVisible]; // BẮT BUỘC – thiếu dòng này là nút không hiện

    return self;
}

- (UIColor *)red { return [UIColor colorWithRed:0.95 green:0.02 blue:0.10 alpha:1]; }
- (UIColor *)dark { return [UIColor colorWithRed:0.035 green:0.018 blue:0.025 alpha:0.97]; }

- (void)buildLauncher {
    self.launcher = [UIButton buttonWithType:UIButtonTypeCustom];
    self.launcher.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width - 76, 180, 60, 60);
    self.launcher.backgroundColor = self.dark;
    self.launcher.layer.cornerRadius = 30;
    self.launcher.layer.borderWidth = 2;
    self.launcher.layer.borderColor = self.red.CGColor;
    self.launcher.clipsToBounds = YES;
    [self.launcher setTitle:@"AS" forState:UIControlStateNormal];
    [self.launcher setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.launcher.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.launcher addTarget:self action:@selector(togglePanel) forControlEvents:UIControlEventTouchUpInside];

    // Cho phép kéo nút
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragLauncher:)];
    [self.launcher addGestureRecognizer:pan];

    [self.rootViewController.view addSubview:self.launcher];
}

- (void)dragLauncher:(UIPanGestureRecognizer *)pan {
    CGPoint translation = [pan translationInView:self];
    CGPoint center = self.launcher.center;
    center.x += translation.x;
    center.y += translation.y;

    // Giới hạn trong màn hình
    CGFloat half = 30;
    CGFloat maxX = UIScreen.mainScreen.bounds.size.width - half;
    CGFloat maxY = UIScreen.mainScreen.bounds.size.height - half;
    center.x = MAX(half, MIN(center.x, maxX));
    center.y = MAX(half, MIN(center.y, maxY));

    self.launcher.center = center;
    [pan setTranslation:CGPointZero inView:self];
}

- (void)buildPanel {
    CGFloat w = MIN(UIScreen.mainScreen.bounds.size.width - 28, 560);
    CGFloat h = 340;
    self.panel = [[UIView alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width - w) / 2,
                                                          (UIScreen.mainScreen.bounds.size.height - h) / 2, w, h)];
    self.panel.backgroundColor = self.dark;
    self.panel.layer.cornerRadius = 20;
    self.panel.layer.borderWidth = 2;
    self.panel.layer.borderColor = self.red.CGColor;
    self.panel.hidden = YES;
    self.panel.clipsToBounds = YES;
    self.panel.userInteractionEnabled = YES;
    [self.rootViewController.view addSubview:self.panel];

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(16, 8, w - 70, 42)];
    title.text = @"ASNLIGHT";
    title.textColor = UIColor.whiteColor;
    title.font = [UIFont boldSystemFontOfSize:25];
    [self.panel addSubview:title];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    close.frame = CGRectMake(w - 52, 8, 40, 40);
    [close setTitle:@"×" forState:UIControlStateNormal];
    [close setTitleColor:self.red forState:UIControlStateNormal];
    close.titleLabel.font = [UIFont boldSystemFontOfSize:30];
    [close addTarget:self action:@selector(togglePanel) forControlEvents:UIControlEventTouchUpInside];
    [self.panel addSubview:close];

    self.tabs = [[UISegmentedControl alloc] initWithItems:@[@"ESP UI", @"Aimbot UI", @"Thông tin"]];
    self.tabs.frame = CGRectMake(14, 58, w - 28, 36);
    self.tabs.selectedSegmentIndex = 0;
    self.tabs.tintColor = self.red;
    [self.tabs addTarget:self action:@selector(tabChanged) forControlEvents:UIControlEventValueChanged];
    [self.panel addSubview:self.tabs];

    self.content = [[UIView alloc] initWithFrame:CGRectMake(14, 104, w - 28, h - 118)];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, y, self.content.bounds.size.width - 28, 30)];
        label.text = row;
        label.textColor = (index == 2 && ([row isEqualToString:@"ASEANLIGHT"] || [row isEqualToString:@"@thelightasean"])) ? self.red : UIColor.whiteColor;
        label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
        [self.content addSubview:label];
        y += 34;
    }
    if (index == 2) {
        UILabel *note = [[UILabel alloc] initWithFrame:CGRectMake(14, y + 2, self.content.bounds.size.width - 28, 40)];
        note.text = @"Các mục trên chỉ là giao diện minh họa.";
        note.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        note.font = [UIFont systemFontOfSize:12];
        [self.content addSubview:note];
    }
}

- (void)tabChanged {
    [self showTab:self.tabs.selectedSegmentIndex];
}

- (void)togglePanel {
    self.panel.hidden = !self.panel.hidden;
    if (!self.panel.hidden) {
        // Đưa panel lên trên cùng khi mở
        [self.rootViewController.view bringSubviewToFront:self.panel];
    }
}

@end

static ASNLIGHTPanel *gASNLIGHTPanel;

static void CreateASNLIGHTPanel(void) {
    if (gASNLIGHTPanel) return;
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CreateASNLIGHTPanel();
        });
        return;
    }
    gASNLIGHTPanel = [[ASNLIGHTPanel alloc] init];
}

%ctor {
    @autoreleasepool {
        // Cách 1: Đợi app launch xong (an toàn nhất)
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                // Delay thêm 1.5s để Free Fire load xong UI
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CreateASNLIGHTPanel();
                });
            });
        }];

        // Cách 2: Fallback nếu notification không kịp (một số bản inject)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CreateASNLIGHTPanel();
        });
    }
}

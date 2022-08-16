//
//  LKTips.m
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import "LKTips.h"
#import "LKToastBackgroundView.h"
#import "LKToastContentView.h"

// 用于找到 Loading 视图，便于隐藏
@interface LKLoadingTips : LKTips
@end
@implementation LKLoadingTips
@end
// 默认消失时间 1.5s
static NSTimeInterval _hideTimeInterval;

@interface LKTips ()
// 默认loading 加载相对位置 默认 居中
@property (nonatomic, assign) LKToastViewPosition defaultLoadingTipPosition;
// 默认Toast 加载相对位置 默认 底部
@property (nonatomic, assign) LKToastViewPosition defaultTipPosition;

@property (nonatomic, strong) UIWindow *frontWindow;

@end

@implementation LKTips

+ (LKTips *)shareTips {
    static LKTips *shareTips;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareTips = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return shareTips;
}
#pragma mark Loading
- (instancetype)initWithView:(UIView *)view {
    self = [super initWithView:view];
    if (self) {
        self.defaultLoadingTipPosition = LKToastViewPositionCenter;
        self.defaultTipPosition = LKToastViewPositionBottom;
        _hideTimeInterval = 1.5f;
    }
    return self;
}


+ (void)showLoading {
    LKTips *tips = [LKTips createLoadingTipsToView:nil];
    [tips showLoading:nil detailText:@""];
}
+ (void)hideLoading {
    [[LKTips shareTips] hideAnimation:YES];
}

+ (void)showLoadingInView:(UIView *)view {
    LKLoadingTips *tips = [self createLoadingTipsToView:view];
    tips.userInteractionEnabled = YES;
    [tips showLoading:nil detailText:nil];
}

+ (void)hideLoadingInView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        NSString *viewName = NSStringFromClass([subView class]);
        if ([viewName isEqualToString:@"LKLoadingTips"]) {
            LKLoadingTips *tips = (LKLoadingTips *)subView;
            [tips hideAnimation:NO];
        }
    }
}

+ (void)showFreeLoadingInView:(UIView *)view {
    LKLoadingTips *tips = [self createLoadingTipsToView:view];
    tips.userInteractionEnabled = NO;
    [tips showLoading:nil detailText:nil];
}
+ (void)hideFreeLoadingInView:(UIView *)view {
    [self hideLoadingInView:view];
}
#pragma mark - Toast
+ (void)showTip:(NSString *)tip {
    if (!tip) {
        tip = @"返回错误为 nil";
    }
    LKTips *tips = [self createTipsToView:nil];
    [tips showTipWithText:tip detailText:nil hideAfterDelay:_hideTimeInterval];
}
+ (void)showWithText:(NSString *)text {
    if (!text) {
        text = @"返回信息为 nil";
    }
    LKTips *tips = [self createTipsToView:nil];
    [tips showTipWithText:text detailText:nil hideAfterDelay:_hideTimeInterval];
}

+ (void)showWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    LKTips *tips = [self createTipsToView:nil];
    [tips showTipWithText:text detailText:nil hideAfterDelay:delay];
}

+ (void)showSucceed:(NSString *)text {
    [self showSucceed:text hideAfterDelay:_hideTimeInterval];
}

+ (void)showSucceed:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    LKTips *tips = [self createTipsToView:nil];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[self getImageWithName:@"tips_done"]];
    [iconView sizeToFit];
    [tips showTipWithText:text detailText:nil contentCustomeView:iconView toastPosition:LKToastViewPositionCenter hideAfterDelay:delay];
}

+ (void)showError:(NSString *)text {
    [self showError:text hideAfterDelay:_hideTimeInterval];
}
+ (void)showError:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    LKTips *tips = [self createTipsToView:nil];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[self getImageWithName:@"tips_error"]];
    [tips showTipWithText:text detailText:nil contentCustomeView:iconView toastPosition:LKToastViewPositionCenter hideAfterDelay:delay];
}

+ (void)showInfo:(NSString *)text {
    [self showInfo:text hideAfterDelay:_hideTimeInterval];
}
+ (void)showInfo:(NSString *)text hideAfterDelay:(NSTimeInterval)delay {
    LKTips *tips = [self createTipsToView:nil];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:[self getImageWithName:@"tips_info"]];
    [tips showTipWithText:text detailText:nil contentCustomeView:iconView toastPosition:LKToastViewPositionCenter hideAfterDelay:delay];
}

#pragma mark -Method
- (void)showLoading:(NSString *)text detailText:(NSString *)detailText {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [indicator startAnimating];
    
    LKToastContentView *contentView = (LKToastContentView *)self.contentView;
    contentView.customView = indicator;
    self.toastPosition = self.defaultLoadingTipPosition;
    contentView.textLabelText = text ?: @"";
    contentView.detailTextLabelText = detailText ?: @"";
    [self showAnimation:YES];
}

- (void)showTipWithText:(NSString *)text detailText:(NSString *)detailText hideAfterDelay:(NSTimeInterval)delay {
    [self showTipWithText:text detailText:detailText contentCustomeView:nil toastPosition:self.defaultTipPosition hideAfterDelay:delay];
}

- (void)showTipWithText:(NSString *)text detailText:(NSString *)detailText toastPosition:(LKToastViewPosition)position hideAfterDelay:(NSTimeInterval)delay {
    [self showTipWithText:text detailText:detailText contentCustomeView:nil toastPosition:position hideAfterDelay:delay];
}

- (void)showTipWithText:(NSString *)text detailText:(NSString *)detailText contentCustomeView:(UIView *)contentCustomView toastPosition:(LKToastViewPosition)position hideAfterDelay:(NSTimeInterval)delay {
    LKToastContentView *contentView = (LKToastContentView *)self.contentView;
    contentView.customView = contentCustomView;
    self.toastPosition = position;
    self.userInteractionEnabled = NO;
    contentView.textLabelText = text ?: @"";
    contentView.detailTextLabelText = detailText ?: @"";
    [self showAnimation:YES];
    if (delay <= 0) {
        [self hideAnimation:YES afterDelay:_hideTimeInterval];
    } else {
        [self hideAnimation:YES afterDelay:delay];
    }
}

+ (UIImage *)getImageWithName:(NSString *)iconName {
    static NSBundle *resourceBoundle = nil;
    if (!resourceBoundle) {
        NSBundle *mainBoundle = [NSBundle bundleForClass:self];
        NSString *sourcePath = [mainBoundle pathForResource:@"LKToast_Resources" ofType:@"bundle"];
        resourceBoundle = [NSBundle bundleWithPath:sourcePath] ?: mainBoundle;
    }
    UIImage *icon = [UIImage imageNamed:iconName inBundle:resourceBoundle compatibleWithTraitCollection:nil];
    return icon;
}
#pragma 获取创建的tips
+ (LKLoadingTips *)createLoadingTipsToView:(UIView *)view {
    if (view) {
        LKLoadingTips *tips = [[LKLoadingTips alloc] initWithView:view];
        [view addSubview:tips];
        tips.removeFromSuperViewWhenHide = YES;
        return tips;
    } else {
        [LKTips shareTips].parentView = [LKTips shareTips].frontWindow;
        [LKTips shareTips].removeFromSuperViewWhenHide = YES;
        [[LKTips shareTips].frontWindow addSubview:[LKTips shareTips]];
        return (LKLoadingTips *)[LKTips shareTips];
    }
}

+ (LKTips *)createTipsToView:(UIView *)view {
    if (view) {
        LKTips *tips = [[LKTips alloc] initWithView:view];
        [view addSubview:tips];
        tips.removeFromSuperViewWhenHide = YES;
        return tips;
    } else {
        [LKTips shareTips].parentView = [LKTips shareTips].frontWindow;
        [LKTips shareTips].removeFromSuperViewWhenHide = YES;
        [[LKTips shareTips].frontWindow addSubview:[LKTips shareTips]];
        return [LKTips shareTips];
    }
}

- (UIWindow *)frontWindow {
    NSEnumerator *frontToBackWindows = [[UIApplication sharedApplication].windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows) {
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelSupported = (window.windowLevel >= UIWindowLevelNormal && window.windowLevel <= UIWindowLevelNormal);
        if (windowOnMainScreen && windowIsVisible && windowLevelSupported) {
            return window;
        }
    }
    return nil;
}

@end

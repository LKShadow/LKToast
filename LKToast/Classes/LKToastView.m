//
//  LKToast.m
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import "LKToastView.h"
#import "LKToastBackgroundView.h"
#import "LKToastContentView.h"
#import "LKToastAnimator.h"

@implementation LKToastView

#pragma mark -初始化

- (instancetype)init {
    return [self initWithView:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithView:nil];
}

- (instancetype)initWithView:(UIView *)view {
    self = [super initWithFrame:view.bounds];
    if (self) {
        _parentView = view;
        [self configInit];
    }
    return self;
}

- (void)dealloc {
    [self removeNotifications];
}

- (void)configInit {
    
//    NSAssert(_parentView, @"请使用‘initWithView:’进行初始化,且view不能为空");
    
    self.toastPosition = LKToastViewPositionCenter;
    // 根据一定层级进行添加到视图上
    self.backgroundView = [self defaultBackgroundView];
    self.contentView = [self defaultContentView];
    
    self.opaque = NO;
    self.alpha = 0.0;
    self.backgroundColor = [UIColor clearColor];
    self.layer.allowsGroupOpacity = NO;
    
    self.tintColor = [UIColor whiteColor];
    
    _maskView = [[UIView alloc] init];
    _maskView.userInteractionEnabled = NO;
    self.maskView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.maskView];
    
    [self registerNotifications];
}

#pragma mark - Show  / Hide

- (void)showAnimation:(BOOL)animated {
    // show 之前需要layout一下，防止同一个tip切换不同的状态导致layout没有更新
    [self setNeedsLayout];
    
    self.alpha = 1.0;
    if (self.willShowBlock) {
        self.willShowBlock(self.parentView, animated);
    }
    if (animated) {
        if (!self.toastAnimator) {
            self.toastAnimator = [self defaultAnimator];
        }
        if (self.toastAnimator) {
            __weak __typeof(self) weakSelf = self;
            [self.toastAnimator showWithCompletion:^(BOOL finished) {
                if (weakSelf.didShowBlock) {
                    weakSelf.didShowBlock(weakSelf.parentView, animated);
                }
            }];
        }
    } else {
        self.backgroundView.alpha = 1.0;
        self.contentView.alpha = 1.0f;
        if (self.didShowBlock) {
            self.didShowBlock(self.parentView, animated);
        }
    }
}

- (void)hideAnimation:(BOOL)animated {
    if (self.willHideBlock) {
        self.willHideBlock(self.parentView, animated);
    }
    
    if (animated) {
        if (!self.toastAnimator) {
            self.toastAnimator = [self defaultAnimator];
        }
        if (self.toastAnimator) {
            __weak __typeof(self) weakSelf = self;
            [self.toastAnimator hideWithCompletion:^(BOOL finished) {
                if (finished) {
                    [weakSelf didHideWithAnimated:animated];
                }
            }];
        }
    } else {
        self.backgroundView.alpha = 0.0;
        self.contentView.alpha = 0.0;
        [self didHideWithAnimated:animated];
    }
}

- (void)didHideWithAnimated:(BOOL)animated {
    if (self.didHideBlock) {
        self.didHideBlock(self.parentView, animated);
    }
    
    self.alpha = 0.0;
    if (self.removeFromSuperViewWhenHide) {
        [self removeFromSuperview];
    }
}

- (void)hideAnimation:(BOOL)animated afterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideAnimation:animated];
    });
}

+ (BOOL)hideAllToastInView:(UIView *)view animated:(BOOL)animated {
    NSArray *toastViews = [self toastInView:view];
    BOOL returnFlag = NO;
    for (LKToastView *toastView in toastViews) {
        if (toastView) {
            toastView.removeFromSuperViewWhenHide = YES;
            [toastView hideAnimation:animated];
            returnFlag = YES;
        }
    }
    return returnFlag;
}

+ (instancetype)toastInView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (LKToastView *)subview;
        }
    }
    return nil;
}
+ (NSArray<LKToastView *> *)allToastInView:(UIView *)view {
    NSMutableArray *toastviews = [NSMutableArray array];
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:self]) {
            [toastviews addObject:subview];
        }
    }
    return toastviews;
}

#pragma mark - default
- (LKToastBackgroundView *)defaultBackgroundView {
    LKToastBackgroundView *backgroundView = [[LKToastBackgroundView alloc] init];
    return backgroundView;
}

- (LKToastContentView *)defaultContentView {
    LKToastContentView *contentView = [[LKToastContentView alloc] init];
    return contentView;
}

- (LKToastAnimator *)defaultAnimator {
    LKToastAnimator *animator = [[LKToastAnimator alloc] initWithToastView:self];
    return animator;
}

#pragma mark -- set
- (void)setBackgroundView:(__kindof UIView *)backgroundView {
    if (backgroundView) {
        [self.backgroundView removeFromSuperview];
        _backgroundView = nil;
    }
    _backgroundView = backgroundView;
    self.backgroundView.alpha = 0.0;
    [self addSubview:self.backgroundView];

    [self setNeedsLayout];
}

- (void)setContentView:(__kindof UIView *)contentView {
    if (contentView) {
        [self.contentView removeFromSuperview];
        _contentView = nil;
    }
    _contentView = contentView;
    self.contentView.alpha = 0.0;
    [self addSubview:self.contentView];
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.frame = self.parentView.bounds;
    self.maskView.frame = self.bounds;
    
    CGFloat contentWidth = CGRectGetWidth(self.parentView.bounds);
    CGFloat contentHeight = CGRectGetHeight(self.parentView.bounds);
    
    CGFloat limitWidth = contentWidth - self.marginInsets.left - self.marginInsets.right;
    CGFloat limitHeight = contentHeight - self.marginInsets.top - self.marginInsets.bottom;
    
    if (self.contentView) {
        CGSize contentViewSize = [self.contentView sizeThatFits:CGSizeMake(limitWidth, limitHeight)];
        CGFloat contentViewX = fmax(self.marginInsets.left, (contentWidth - contentViewSize.width)/2) + self.offset.x;
        CGFloat contentViewY = fmax(self.marginInsets.top, (contentHeight - contentViewSize.height)/2) + self.offset.y;
        
        if (self.toastPosition == LKToastViewPositionTop) {
            contentViewY = self.marginInsets.top + self.offset.y;
        } else if (self.toastPosition == LKToastViewPositionBottom) {
            contentViewY = contentHeight - contentViewSize.height - self.marginInsets.bottom + self.offset.y;
        }
        
        CGRect contentRect = CGRectMake(contentViewX, contentViewY, contentViewSize.width, contentViewSize.height);
        self.contentView.frame = contentRect;
    }
    
    if (self.backgroundView) {
        self.backgroundView.frame = self.contentView.frame;
    }
    
}

#pragma mark - 横竖屏
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}

- (void)statusBarOrientationDidChange:(NSNotification *)notification {
    if (!self.parentView) {
        return;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}
#pragma mark - UIAppearance
- (void)setOffset:(CGPoint)offset {
    _offset = offset;
    [self setNeedsLayout];
}
- (void)setMarginInsets:(UIEdgeInsets)marginInsets {
    _marginInsets = marginInsets;
    [self setNeedsLayout];
}
@end

@interface LKToastView (UIAppearance)

@end
@implementation LKToastView (UIAppearance)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self setDefaultAppearance];
    });
}

+ (void)setDefaultAppearance {
    LKToastView *appearance = [LKToastView appearance];
    appearance.offset = CGPointMake(0, -20);
    appearance.marginInsets = UIEdgeInsetsMake(20, 20, 20, 20);
}

@end

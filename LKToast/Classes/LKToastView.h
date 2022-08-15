//
//  LKToast.h
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import <Foundation/Foundation.h>
@class LKToastAnimator;
NS_ASSUME_NONNULL_BEGIN
/** 定义toastview显示的位置，默认居中 */
typedef NS_ENUM(NSUInteger, LKToastViewPosition) {
    LKToastViewPositionTop,
    LKToastViewPositionCenter,
    LKToastViewPositionBottom,
};
/**
 * `LKToastView`是一个用来显示toast的控件，其主要结构包括：`backgroundView`、`contentView`，这两个view都是通过外部赋值获取，默认使用`LKToastBackgroundView`和`LKToastContentView`。
 *
 * 拓展性：`LKToastBackgroundView`和`LKToastContentView`是提供的默认的view，这两个view都可以通过appearance来修改样式，如果这两个view满足不了需求，那么也可以通过新建自定义的view来代替这两个view。另外，也提供了默认的toastAnimator来实现ToastView的显示和隐藏动画，如果需要重新定义一套动画，可以继承`LKToastAnimator`并且实现`LKToastViewAnimatorDelegate`中的协议就可以自定义自己的一套动画。
 *
 * 建议使用`LKToastView`的时候，再封装一层，具体可以参考`LKTips`这个类。
 *
 * @see LKToastBackgroundView
 * @see LKToastContentView
 * @see LKToastAnimator
 * @see LKTips
 */
@interface LKToastView : UIView
/**
 生成一个toastview的唯一初始化方法, view 的bounds将会作为 ToastView的默认frame
 @Param view toastView的superView
 */
- (instancetype)initWithView:(UIView *)view;
/**
 parentView 是ToastView初始化的时候传进去的那个View
 */
@property (nonatomic, weak) UIView *parentView;
/**
 显示ToastView
 */
- (void)showAnimation:(BOOL)animated;
/**
 隐藏ToastView 默认0.25 秒后自动隐藏
 */
- (void)hideAnimation:(BOOL)animated;
/**
 在 'delay' 时间后隐藏 ToastView
 */
- (void)hideAnimation:(BOOL)animated afterDelay:(NSTimeInterval)delay;
/// @warning 如果使用 [LKTips showXxx] 系列快捷方法来显示 tips，willShowBlock 将会在 show 之后才被设置，最终并不会被调用。这种场景建议自己在调用 [LKTips showXxx] 之前执行一段代码，或者不要使用 [LKTips showXxx] 的方式显示 tips
@property(nonatomic, copy) void (^willShowBlock)(UIView *showInView, BOOL animated);
@property(nonatomic, copy) void (^didShowBlock)(UIView *showInView, BOOL animated);
@property(nonatomic, copy) void (^willHideBlock)(UIView *hideInView, BOOL animated);
@property(nonatomic, copy) void (^didHideBlock)(UIView *hideInView, BOOL animated);
/** =============== **/

/**
 * 决定ToastView的位置，目前有上中下三个为止，默认center
 * 布局规则：设置top：从marginInsets.top 开始往下进行布局 、 bottom：从marginInsets.bottom 开始往上布局
 */
@property (nonatomic, assign) LKToastViewPosition toastPosition;
/**
 * ‘LKToastAnimator’ 可以通过实现一些协议来自定义ToastView显示和隐藏的动画，可以继承‘LKToastAnimator’，然后实现协议中的方法。如果不进行赋值，默认使用‘LKToastAnimator’ 默认动画
 */
@property (nonatomic, strong) LKToastAnimator *toastAnimator;

/** =============== **/

/**
 * 遮罩； 会盖住整个superView，防止手指点击到toastview下面的内容，默认透明 并拦截手势操作 。
 */
@property (nonatomic, strong, readonly) UIView *maskView;
/**
 * 承载Toast内容的UIView， 可以自定义并赋值给contentView。如果contentView需要跟随Toastview的tintColor变化而变化，可以重写自定义view的‘tintColorDidChange’来实现。 默认使用LKToastContentView 实现
 */
@property (nonatomic, strong) __kindof UIView *contentView;
/**
 * contentView下面的背景View，默认使用‘LKToastBackgroundView’实现，可以修改背景色和圆角
 */
@property (nonatomic, strong) __kindof UIView *backgroundView;
/**
 * 是否在ToastView隐藏的时候顺便把它从superView上移除，默认NO
 */
@property (nonatomic, assign) BOOL removeFromSuperViewWhenHide;
/** =============== **/

/**
 * 上下左右的偏移值
 */
@property (nonatomic, assign) CGPoint offset UI_APPEARANCE_SELECTOR;
/**
 * ToastView 距离上下左右的最小间距
 */
@property (nonatomic, assign) UIEdgeInsets marginInsets UI_APPEARANCE_SELECTOR;


/** ===========工具方法==============*/
/**
 * 隐藏 ‘View’ 里面的所有 ToastView
 * @Param view 即将隐藏的ToastView的superView
 * @Param animated 是否需要通过动画隐藏
 *
 * @return 如果成功隐藏一个ToastView 则返回YES, 失败返回NO
 */
+ (BOOL)hideAllToastInView:(UIView *)view animated:(BOOL)animated;
/**
 * 返回 'view'里面的最顶级ToastView，如果没有返回nil。
 *
 */
+ (instancetype)toastInView:(UIView *)view;
/**
 * 返回‘view’里面的苏欧欧ToastView， 如果没有返回nil
 */
+ (NSArray <LKToastView *>*)allToastInView:(UIView *)view;

@end


NS_ASSUME_NONNULL_END

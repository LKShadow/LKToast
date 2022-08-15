//
//  LKTips.h
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import "LKToastView.h"

NS_ASSUME_NONNULL_BEGIN
/**
 简单封装ToastView，支持弹出纯文本、loading、如果接口无法满足业务，可以通过LKTips的分类进行接口扩展
 特殊的弹框UI，也可以自己创建LKToastView对象，自定义视图、动画等。
 */
@interface LKTips : LKToastView



#pragma mark - 隐藏 & 显示  方法
/**
 显示在window上的loading，默认在中间， 受 defaultLoadingTipPosition 控制
 */
+ (void)showLoading;
+ (void)hideLoading;

//显示纯文本 tips (默认在屏幕底部) 受 defaultTipPosition 控制
+ (void)showTip:(nullable NSString *)tip;

//添加 Loading 到 View 上
+ (void)showLoadingInView:(UIView *)view;
+ (void)hideLoadingInView:(UIView *)view;

//添加 Loading 到 View 上
+ (void)showFreeLoadingInView:(UIView *)view;
+ (void)hideFreeLoadingInView:(UIView *)view;

//显示纯文本 tips (默认在屏幕下方) 受 defaultTipPosition 控制
+ (void)showWithText:(nullable NSString *)text;
+ (void)showWithText:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;

//显示成功 tips 位置 默认中心 不受defaultTipPosition控制
+ (void)showSucceed:(nullable NSString *)text;
+ (void)showSucceed:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;

//显示错误 tips 位置 默认中心 不受defaultTipPosition控制
+ (void)showError:(nullable NSString *)text;
+ (void)showError:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;

//显示信息 tips 位置 默认中心 不受defaultTipPosition控制
+ (void)showInfo:(nullable NSString *)text;
+ (void)showInfo:(nullable NSString *)text hideAfterDelay:(NSTimeInterval)delay;
@end

NS_ASSUME_NONNULL_END

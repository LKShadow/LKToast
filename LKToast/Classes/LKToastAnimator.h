//
//  LKToastAnimator.h
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import <Foundation/Foundation.h>
@class LKToastView;
NS_ASSUME_NONNULL_BEGIN
/**
 * 'LKToastAnimatorDelegate' 是所有 ‘LKToastAnimator’ 或其子类必须遵循的协议，是动画实现的地方
 */
@protocol LKToastAnimatorDelegate <NSObject>

@required
- (void)showWithCompletion:(void(^)(BOOL finished))completion;
- (void)hideWithCompletion:(void(^)(BOOL finished))completion;
- (BOOL)isShowing;
- (BOOL)isAnimating;

@end
// 动画类型
typedef NS_ENUM(NSUInteger, LKToastAnimatorType) {
    LKToastAnimatorTypeFade     = 0,
    
};


@interface LKToastAnimator : NSObject <LKToastAnimatorDelegate>
/**
 * 初始化方法
 */
- (instancetype)initWithToastView:(LKToastView *)toastView NS_DESIGNATED_INITIALIZER;
/**
 * 获取初始化 传进来的ToastView
 */
@property (nonatomic, weak, readonly) LKToastView *toastView;
/**
 * 设置动画实现类型，目前只有默认的，其他暂未实现
 */
@property (nonatomic, assign) LKToastAnimatorType animatorType;

- (void)cancelAnimation;

@end

NS_ASSUME_NONNULL_END

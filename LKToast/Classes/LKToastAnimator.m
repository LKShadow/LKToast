//
//  LKToastAnimator.m
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import "LKToastAnimator.h"
#import "LKToastView.h"

@implementation LKToastAnimator {
    BOOL _isShowing;
    BOOL _isAnimating;
}

- (instancetype)init {
    NSAssert(NO, @"请使用initWithToastView：初始化");
    return [self initWithToastView:nil];
}


- (instancetype)initWithToastView:(LKToastView *)toastView {
    NSAssert(toastView, @"ToastView不能为空");
    if (self = [super init]) {
        _toastView = toastView;
    }
    return self;
}

- (void)showWithCompletion:(void (^)(BOOL))completion {
    _isShowing = YES;
    _isAnimating = YES;
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.toastView.backgroundView.alpha = 1.0f;
        self.toastView.contentView.alpha = 1.0f;
    } completion:^(BOOL finished) {
        self ->_isAnimating = NO;
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)hideWithCompletion:(void (^)(BOOL))completion {
    _isAnimating = YES;
    
    [UIView animateWithDuration:0.25 delay:0.0f options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.toastView.backgroundView.alpha = 0.0f;
        self.toastView.contentView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self ->_isShowing = NO;
        self ->_isAnimating = NO;
        if (completion) {
            completion(finished);
        }
    }];
}

- (BOOL)isAnimating {
    return _isAnimating;
}

- (BOOL)isShowing {
    return _isShowing;
}

- (void)cancelAnimation {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    [self.toastView.backgroundView.layer removeAllAnimations];
    [self.toastView.contentView.layer removeAllAnimations];
    
    [CATransaction commit];
}

@end

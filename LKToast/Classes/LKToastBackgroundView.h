//
//  LKToastBackgroundView.h
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LKToastBackgroundView : UIView

/**
 * 是否需要磨砂， 默认NO。 仅支持iOS8以上版本，可以通过修改 'styleColor'来控制磨砂效果
 */
@property (nonatomic, assign) BOOL shouldBlurBackgroundView;
/**
 * 如果不设置磨砂，则 styleColor直接作为backgroundColor；如果需要磨砂，则会新增一个UIVisualEffectView放在LKToastBackgroundView上面
 */
@property (nonatomic, strong) UIColor *styleColor UI_APPEARANCE_SELECTOR;
/**
 * 设置圆角
 */
@property (nonatomic, assign) CGFloat cornerRadius UI_APPEARANCE_SELECTOR;

@end

NS_ASSUME_NONNULL_END

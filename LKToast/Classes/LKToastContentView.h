//
//  LKToastContentView.h
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableParagraphStyle (Toast)
/**
 *  快速创建一个NSMutableParagraphStyle
 *  @Param lineHeight 行高
 *  @return 一个NSMutableParagraphStyle对象
 */
+ (instancetype)lk_paragraphStyleWithLineHeight:(CGFloat)lineHeight;
/**
 *  快速创建一个NSMutableParagraphStyle
 *  @Param lineHeight 行高
 *  @Param lineBreakMode 换行模式
 *  @return 一个NSMutableParagraphStyle对象
 */
+ (instancetype)lk_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode;
/**
 *  快速创建一个NSMutableParagraphStyle
 *  @Param lineHeight 行高
 *  @Param lineBreakMode 换行模式
 *  @Param textAlignment 文本对齐方式
 *  @return 一个NSMutableParagraphStyle对象
 */
+ (instancetype)lk_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment;
@end

@interface LKToastContentView : UIView
/**
 * 设置一个UIView，可以是：菊花、图片等等
 */
@property(nonatomic, strong) UIView *customView;

/**
 * 设置第一行大文字label
 */
@property(nonatomic, strong, readonly) UILabel *textLabel;

/**
 * 通过textLabelText设置可以应用textLabelAttributes的样式，如果通过textLabel.text设置则可能导致一些样式失效。
 */
@property(nonatomic, copy) NSString *textLabelText;

/**
 * 设置第二行小文字label
 */
@property(nonatomic, strong, readonly) UILabel *detailTextLabel;

/**
 * 通过detailTextLabelText设置可以应用detailTextLabelAttributes的样式，如果通过detailTextLabel.text设置则可能导致一些样式失效。
 */
@property(nonatomic, copy) NSString *detailTextLabelText;

/**
 * 设置上下左右的padding。
 */
@property(nonatomic, assign) UIEdgeInsets insets UI_APPEARANCE_SELECTOR;

/**
 * 设置最小size。
 */
@property(nonatomic, assign) CGSize minimumSize UI_APPEARANCE_SELECTOR;

/**
 * 设置customView的marginBottom
 */
@property(nonatomic, assign) CGFloat customViewMarginBottom UI_APPEARANCE_SELECTOR;

/**
 * 设置textLabel的marginBottom
 */
@property(nonatomic, assign) CGFloat textLabelMarginBottom UI_APPEARANCE_SELECTOR;

/**
 * 设置detailTextLabel的marginBottom
 */
@property(nonatomic, assign) CGFloat detailTextLabelMarginBottom UI_APPEARANCE_SELECTOR;

/**
 * 设置textLabel的attributes
 */
@property(nonatomic, strong) NSDictionary <NSString *, id> *textLabelAttributes UI_APPEARANCE_SELECTOR;

/**
 * 设置detailTextLabel的attributes
 */
@property(nonatomic, strong) NSDictionary <NSString *, id> *detailTextLabelAttributes UI_APPEARANCE_SELECTOR;
@end

NS_ASSUME_NONNULL_END

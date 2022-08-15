//
//  LKToastContentView.m
//  LKToast
//
//  Created by 李考 on 2022/8/11.
//

#import "LKToastContentView.h"

#define DefaultTextLabelFont [UIFont boldSystemFontOfSize:16]
#define DefaultDetailTextLabelFont [UIFont systemFontOfSize:12]
#define DefaultLabelColor [UIColor whiteColor]
/// 用于居中运算
CG_INLINE CGFloat
CGFloatGetCenter(CGFloat parent, CGFloat child) {
    return (parent - child) / 2.0;
}
@implementation NSMutableParagraphStyle (Toast)

+ (instancetype)lk_paragraphStyleWithLineHeight:(CGFloat)lineHeight {
    return [self lk_paragraphStyleWithLineHeight:lineHeight lineBreakMode:NSLineBreakByWordWrapping textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)lk_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode {
    return [self lk_paragraphStyleWithLineHeight:lineHeight lineBreakMode:lineBreakMode textAlignment:NSTextAlignmentLeft];
}

+ (instancetype)lk_paragraphStyleWithLineHeight:(CGFloat)lineHeight lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)textAlignment {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.minimumLineHeight = lineHeight;
    style.maximumLineHeight = lineHeight;
    style.lineBreakMode = lineBreakMode;
    style.alignment = textAlignment;
    return style;
}

@end

@implementation LKToastContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.allowsGroupOpacity = NO;
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews {
    
    _textLabel = [[UILabel alloc] init];
    self.textLabel.numberOfLines = 0;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = DefaultLabelColor;
    self.textLabel.font = DefaultTextLabelFont;
    self.textLabel.opaque = NO;
    [self addSubview:self.textLabel];
    
    _detailTextLabel = [[UILabel alloc] init];
    self.detailTextLabel.numberOfLines = 0;
    self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    self.detailTextLabel.textColor = DefaultLabelColor;
    self.detailTextLabel.font = DefaultDetailTextLabelFont;
    self.detailTextLabel.opaque = NO;
    [self addSubview:self.detailTextLabel];
    
    self.insets = UIEdgeInsetsMake(16, 16, 16, 16);
    self.minimumSize = CGSizeZero;
    self.customViewMarginBottom = 8;
    self.textLabelMarginBottom = 4;
    self.detailTextLabelMarginBottom = 0;
    self.textLabelAttributes = @{
        NSFontAttributeName : DefaultTextLabelFont,
        NSForegroundColorAttributeName : DefaultLabelColor,
        NSParagraphStyleAttributeName : [NSMutableParagraphStyle lk_paragraphStyleWithLineHeight:22]
    };
    self.detailTextLabelAttributes = @{
        NSFontAttributeName: DefaultTextLabelFont,
        NSForegroundColorAttributeName : DefaultLabelColor,
        NSParagraphStyleAttributeName : [NSMutableParagraphStyle lk_paragraphStyleWithLineHeight:18]
    };
}

- (void)setCustomView:(UIView *)customView {
    if (self.customView) {
        [self.customView removeFromSuperview];
        _customView = nil;
    }
    _customView = customView;
    [self addSubview:self.customView];
    [self updateCustomViewTintColor];
    [self setNeedsLayout];
}

- (void)setTextLabelText:(NSString *)textLabelText {
    _textLabelText = textLabelText;
    if (textLabelText) {
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:textLabelText attributes:self.textLabelAttributes];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        [self setNeedsLayout];
    }
}

- (void)setDetailTextLabelText:(NSString *)detailTextLabelText {
    _detailTextLabelText = detailTextLabelText;
    if (detailTextLabelText) {
        self.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:detailTextLabelText attributes:self.detailTextLabelAttributes];
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    BOOL hasCustomView = !!self.customView;
    BOOL hasTextLabel = self.textLabel.text.length > 0;
    BOOL hasDetailTextLabel = self.detailTextLabel.text.length > 0;
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    CGFloat maxContentWidth = size.width - self.insets.left - self.insets.right;
    CGFloat maxContentHeight = size.height - self.insets.top - self.insets.bottom;
    
    if (hasCustomView) {
        width = fmax(width, CGRectGetWidth(self.customView.bounds));
        height += (CGRectGetHeight(self.customView.bounds) + ((hasTextLabel || hasDetailTextLabel) ? self.customViewMarginBottom : 0));
    }
    
    if (hasTextLabel) {
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(maxContentWidth, maxContentHeight)];
        width = fmax(width, textLabelSize.width);
        height += (textLabelSize.height + (hasDetailTextLabel ? self.textLabelMarginBottom : 0));
    }
    
    if (hasDetailTextLabel) {
        CGSize detailTextLabelSize = [self.detailTextLabel sizeThatFits:CGSizeMake(maxContentWidth, maxContentHeight)];
        width = fmax(width, detailTextLabelSize.width);
        height += (detailTextLabelSize.height + self.detailTextLabelMarginBottom);
    }
    
    width += (self.insets.left + self.insets.right);
    height += (self.insets.top + self.insets.bottom);
    if (!CGSizeEqualToSize(self.minimumSize, CGSizeZero)) {
        width = fmax(width, self.minimumSize.width);
        height = fmax(height, self.minimumSize.height);
    }
    return CGSizeMake(fmin(size.width, width), fmin(size.height, height));
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BOOL hasCustomView = !!self.customView;
    BOOL hasTextLabel = self.textLabel.text.length > 0;
    BOOL hasDetailTextLabel = self.detailTextLabel.text.length > 0;
    
    CGFloat contentWidth = CGRectGetWidth(self.bounds);
    CGFloat maxContentWidth = contentWidth - (self.insets.left + self.insets.right);
    
    CGFloat minY = self.insets.top;
    
    if (hasCustomView) {
        if (!hasTextLabel && !hasDetailTextLabel) {
            // 处理有minimumSize的情况
            minY = CGFloatGetCenter(CGRectGetHeight(self.bounds), CGRectGetHeight(self.customView.bounds));
        }
        self.customView.frame = CGRectMake(CGFloatGetCenter(contentWidth, CGRectGetWidth(self.customView.bounds)), minY, CGRectGetWidth(self.customView.bounds), CGRectGetHeight(self.customView.bounds));
        minY = CGRectGetMaxY(self.customView.frame) + self.customViewMarginBottom;
    }
    
    if (hasTextLabel) {
        CGSize textLabelSize = [self.textLabel sizeThatFits:CGSizeMake(maxContentWidth, CGFLOAT_MAX)];
        if (!hasCustomView && !hasDetailTextLabel) {
            // 处理有minimumSize的情况
            minY = CGFloatGetCenter(CGRectGetHeight(self.bounds), textLabelSize.height);
        }
        self.textLabel.frame = CGRectMake(CGFloatGetCenter(contentWidth, maxContentWidth), minY, maxContentWidth, textLabelSize.height);
        minY = CGRectGetMaxY(self.textLabel.frame) + self.textLabelMarginBottom;
    }
    
    if (hasDetailTextLabel) {
        // 暂时没考虑剩余高度不够用的情况
        CGSize detailTextLabelSize = [self.detailTextLabel sizeThatFits:CGSizeMake(maxContentWidth, CGFLOAT_MAX)];
        if (!hasCustomView && !hasTextLabel) {
            // 处理有minimumSize的情况
            minY = CGFloatGetCenter(CGRectGetHeight(self.bounds), detailTextLabelSize.height);
        }
        self.detailTextLabel.frame = CGRectMake(CGFloatGetCenter(contentWidth, maxContentWidth), minY, maxContentWidth, detailTextLabelSize.height);

    }
}
#pragma mark - Method
- (void)tintColorDidChange {
    if (self.customView) {
        [self updateCustomViewTintColor];
    }
    
    NSMutableDictionary *textLabelAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.textLabelAttributes];
    textLabelAttributes[NSForegroundColorAttributeName] = self.tintColor;
    self.textLabelAttributes = textLabelAttributes;
    self.textLabelText = self.textLabelText;
    
    NSMutableDictionary *detailTextLabelAttributes = [[NSMutableDictionary alloc] initWithDictionary:self.detailTextLabelAttributes];
    detailTextLabelAttributes[NSForegroundColorAttributeName] = self.tintColor;
    self.detailTextLabelAttributes = detailTextLabelAttributes;
    self.detailTextLabelText = self.detailTextLabelText;
}

- (void)updateCustomViewTintColor {
    if (!self.customView) {
        return;
    }
    self.customView.tintColor = self.tintColor;
    if ([self.customView isKindOfClass:[UIImageView class]]) {
        UIImageView *customeView = (UIImageView *)self.customView;
        customeView.image = [customeView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    if ([self.customView isKindOfClass:[UIActivityIndicatorView class]]) {
        UIActivityIndicatorView *customView = (UIActivityIndicatorView *)self.customView;
        customView.color = self.tintColor;
    }
}
#pragma mark - UIAppearance

- (void)setInsets:(UIEdgeInsets)insets {
    _insets = insets;
    [self setNeedsLayout];
}

- (void)setMinimumSize:(CGSize)minimumSize {
    _minimumSize = minimumSize;
    [self setNeedsLayout];
}

- (void)setCustomViewMarginBottom:(CGFloat)customViewMarginBottom {
    _customViewMarginBottom = customViewMarginBottom;
    [self setNeedsLayout];
}

- (void)setTextLabelMarginBottom:(CGFloat)textLabelMarginBottom {
    _textLabelMarginBottom = textLabelMarginBottom;
    [self setNeedsLayout];
}

- (void)setDetailTextLabelMarginBottom:(CGFloat)detailTextLabelMarginBottom {
    _detailTextLabelMarginBottom = detailTextLabelMarginBottom;
    [self setNeedsLayout];
}

- (void)setTextLabelAttributes:(NSDictionary *)textLabelAttributes {
    _textLabelAttributes = textLabelAttributes;
    if (self.textLabelText && self.textLabelText.length > 0) {
        // 刷新label的attributes
        self.textLabelText = self.textLabelText;
    }
}

- (void)setDetailTextLabelAttributes:(NSDictionary *)detailTextLabelAttributes {
    _detailTextLabelAttributes = detailTextLabelAttributes;
    if (self.detailTextLabelText && self.detailTextLabelText.length > 0) {
        // 刷新label的attributes
        self.detailTextLabelText = self.detailTextLabelText;
    }
}

@end

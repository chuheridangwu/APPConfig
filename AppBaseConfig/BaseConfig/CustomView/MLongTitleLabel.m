//
//  MLongTitleLabel.m
//  CategoryProject
//
//  Created by mlive on 2021/4/21.
//

#import "MLongTitleLabel.h"

@interface MLongTitleLabel ()
@property (nonatomic,assign)CGFloat wateTime;
@end

@implementation MLongTitleLabel

- (id)initWithFrame:(CGRect)frame
{
    if (self)
    {
        self = [super initWithFrame:frame];
        self.clipsToBounds = YES;
    }
    return self;
}

- (id)init
{
    if (self)
    {
        self = [super init];
        self.clipsToBounds = YES;
    }
    return self;
}


- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.titleLabel.textColor = _textColor;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    self.titleLabel.textAlignment = _textAlignment;
}

- (void)setFontSize:(CGFloat)fontSize
{
    _fontSize = fontSize;
    if (_text.length > 0)
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_text];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:_fontSize] range:NSMakeRange(0, _titleLabel.attributedText.length)];
        self.titleLabel.attributedText = str;
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self.titleLabel.layer removeAnimationForKey:@"animationViewPosition"];
    self.titleLabel.text = text;
    self.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    
    [_titleLabel sizeToFit];
    if (CGRectGetWidth(_titleLabel.bounds) <= CGRectGetWidth(self.bounds))
    {
        _titleLabel.frame = self.bounds;
    }
    else
    {
        _wateTime = _titleLabel.width / self.width * 3;
        CGPoint fromPoint = CGPointMake(CGRectGetWidth(self.bounds) + CGRectGetWidth(_titleLabel.bounds)/2, _titleLabel.center.y);
        CGPoint toPoint = CGPointMake(-CGRectGetWidth(_titleLabel.bounds)/2, _titleLabel.center.y);
        UIBezierPath *movePath    = [UIBezierPath bezierPath];
        [movePath moveToPoint:fromPoint];
        [movePath addLineToPoint:toPoint];
        
        CAKeyframeAnimation *moveAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        moveAnimation.path                 = movePath.CGPath;
        moveAnimation.removedOnCompletion  = YES;
        moveAnimation.duration             = _wateTime;
        moveAnimation.repeatCount          = 10000;
        [self.titleLabel.layer addAnimation:moveAnimation forKey:@"animationViewPosition"];
    }
}

- (void)dealloc
{
    NSLog(@"SHLongTitleLabel");
//    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(starAnimating) object:nil];
//    _isAnimate = NO;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        if (_textColor)
        {
            _titleLabel.textColor = _textColor;
        }
        _titleLabel.textAlignment = _textAlignment;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end

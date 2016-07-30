//
//  DLAnimationView.m
//  DLAnimation
//
//  Created by DEMO on 16/3/7.
//  Copyright © 2016年 DEMO. All rights reserved.
//

#import "DLAnimationView.h"

//动画总时间
static CGFloat const kAnimationDuration = 5.0f;

//三个logo形成正三角形的外接圆距view的左右边距
static CGFloat const kCircleMargin = 40.0f;

//三logo一开始出现的移动距离和虚线圆线框缩小的动画距离
static CGFloat const kLogoGoOutMove = 30.0f;

//客户logo和供应商logo 下移距离
static CGFloat const kLogoDownMove = 30.0f;

//虚线圆线框从无到有的动画距离
static CGFloat const kCircleZoomOut = 80.0f;

//Slogan Label的宽度
static CGFloat const kSloganLabelWidth = 20.0f;

//小尺寸下 logo 图片的尺寸
static CGFloat const kLogoImgWidthForSmallScreen = 50.0f;

//大于小尺寸下 logo 图片的尺寸
static CGFloat const kLogoImgWidthForBigScreen = 70.0f;

//小尺寸宽度定义
static CGFloat const kSmallScreenWidth = 320.0f;

//三个Logo的图片名
static NSString * const imgClientName   = @"Register_Client";
static NSString * const imgSupplierName = @"Register_Supplier";
static NSString * const imgLogoName     = @"Register_logo";

//Slogan
static NSString * strSlogan = @"欢迎进入，2333333";

@interface DLAnimationView ()
{
    CGFloat _radius;
    CGPoint _centerPoint;
    NSMutableArray * _arrLabel;
}

/**
 *  客户头像logo
 */
@property (nonatomic, strong)UIImageView * imgClient;

/**
 *  供应商头像logo
 */
@property (nonatomic, strong)UIImageView * imgSupplier;

/**
 *  logo
 */
@property (nonatomic, strong)UIImageView * imgLogo;

/**
 *  背景圆形放大view
 */
@property (nonatomic, strong)UIView * viewZoom;

/**
 *  虚线圆圈View
 */
@property (nonatomic, strong)UIView * viewCircle;


/**
 *  虚线圆圈view的layer
 */
@property (nonatomic, strong)CAShapeLayer * layerCircle;

/**
 *  虚线圆圈初始size 的 path
 */
@property (nonatomic, strong)UIBezierPath * pathMidCicrle;

/**
 *  虚线圆圈变大size 的 path
 */
@property (nonatomic, strong)UIBezierPath * pathBigCicrle;

/**
 *  虚线圆圈变小消失size 的 path
 */
@property (nonatomic, strong)UIBezierPath * pathSmallCicrle;

@end

@implementation DLAnimationView

/**
*  初始化方法
*
*  @param frame
*
*  @return self
*/
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit:frame];
        self.backgroundColor = [UIColor colorWithRed:25/255.0 green:27/255.0 blue:31/255.0 alpha:1];
    }
    return self;
}

/**
 *  初始化布局
 */
- (void)commonInit:(CGRect)frame {
    //logo  size
    CGSize imgSize;
    
    if (frame.size.width <= kSmallScreenWidth) {
        imgSize = CGSizeMake(kLogoImgWidthForSmallScreen, kLogoImgWidthForSmallScreen);
    } else {
        imgSize = CGSizeMake(kLogoImgWidthForBigScreen, kLogoImgWidthForBigScreen);
    }
    
    CGFloat minWidth = MIN(frame.size.width, frame.size.height);
    
    //View中心点坐标
    _centerPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    
    //三张logo
    _imgClient = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgClientName]];
    _imgSupplier = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgSupplierName]];
    _imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgLogoName]];
    
    _imgClient.clipsToBounds = YES;
    _imgSupplier.clipsToBounds = YES;
    _imgLogo.clipsToBounds = YES;
    
    
    //圆形变大的View
    _viewZoom = ({
        UIView * view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor colorWithRed:40/255.0 green:160/255.0 blue:150/255.0 alpha:1];
        view;
    });
    
    _radius = minWidth / 2 - kCircleMargin - imgSize.width/2;
    
    CGRect originRect = CGRectMake(0, 0, imgSize.width, imgSize.height);
    _imgLogo.frame = originRect;
    _imgClient.frame = originRect;
    _imgSupplier.frame = originRect;
    
    _imgClient.layer.cornerRadius = _imgClient.bounds.size.width / 2.0;
    _imgSupplier.layer.cornerRadius = _imgClient.bounds.size.width / 2.0;
    _imgLogo.layer.cornerRadius = _imgClient.bounds.size.width / 2.0;
    
    _viewCircle = ({
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _radius * 2, _radius * 2)];
        view.center = _centerPoint;
        view;
    });
    
    _layerCircle = ({
        CAShapeLayer * layer = [[CAShapeLayer alloc] init];
        layer.frame = _viewCircle.bounds;
        layer.strokeColor = [UIColor lightGrayColor].CGColor;
        layer.fillColor   = [UIColor clearColor].CGColor;
        layer.lineWidth   = 2.0f;
        layer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:8], nil];
        layer.lineDashPhase = 3.0f;
        layer;
    });
    
    [_viewCircle.layer addSublayer:_layerCircle];
    
    _pathMidCicrle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(kLogoGoOutMove, kLogoGoOutMove, 2*(_radius - kLogoGoOutMove), 2*(_radius - kLogoGoOutMove))];
    
    _pathBigCicrle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 2*_radius, 2*_radius)];
    
    _pathSmallCicrle = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(kCircleZoomOut, kCircleZoomOut, 2*(_radius - kCircleZoomOut), 2*(_radius - kCircleZoomOut))];
    
    [self addSubview:_viewZoom];
    [self addSubview:_viewCircle];
    [self addSubview:_imgLogo];
    [self addSubview:_imgClient];
    [self addSubview:_imgSupplier];
    
    _arrLabel = [[NSMutableArray alloc] initWithCapacity:strSlogan.length];
    
    //Slogan第一个文字label 的 中心坐标
    int lblCenterX;
    if (strSlogan.length%2 == 0) {
        lblCenterX = self.center.x - kSloganLabelWidth/2 - kSloganLabelWidth * (strSlogan.length/2 - 1);
    } else {
        lblCenterX = self.center.x - kSloganLabelWidth * ceil(strSlogan.length/2);
    }
    
    
    for (int i = 0; i < strSlogan.length; i++) {
        UILabel * lbl = ({
            UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kSloganLabelWidth, kSloganLabelWidth)];
            lbl.center = CGPointMake(lblCenterX + kSloganLabelWidth * i, self.bounds.size.height + kSloganLabelWidth/2);
            lbl.text = [NSString stringWithFormat:@"%C",[strSlogan characterAtIndex:i]];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.textColor = [UIColor whiteColor];
            [self addSubview:lbl];
            lbl;
        });
        
        [_arrLabel addObject:lbl];
    }
    
    //初始位置
//    [self setUpOrigin];
}

- (void)setUpOrigin {
    
    //从内到外的移动
    CGFloat originRadius = _radius - kLogoGoOutMove;
    CGFloat sinRadius    = originRadius * sin(M_PI/6);
    CGFloat cosRadius    = originRadius * cos(M_PI/6);
    
    _imgLogo.center     = CGPointMake(_centerPoint.x , _centerPoint.y - originRadius);
    _imgClient.center   = CGPointMake(_centerPoint.x - cosRadius, _centerPoint.y + sinRadius);
    _imgSupplier.center = CGPointMake(_centerPoint.x + cosRadius, _centerPoint.y + sinRadius);
    
    _imgLogo.alpha     = 0;
    _imgClient.alpha   = 0;
    _imgSupplier.alpha = 0;
    
    _viewZoom.layer.mask = [CAShapeLayer layer];
    
    _layerCircle.path    = _pathMidCicrle.CGPath;
    _layerCircle.opacity = 0.0f;
    
    self.alpha = 1.0f;
    
    for (int i = 0; i < _arrLabel.count; i++) {
        UILabel * lbl = _arrLabel[i];
        lbl.center = CGPointMake(lbl.center.x, - lbl.frame.size.height/2);
    }
    
    //开始动画
    [self performSelector:@selector(fadeAnimation) withObject:nil afterDelay:kAnimationDuration * 0.1];
}

- (void)fadeAnimation {
    CGFloat sinRadius = _radius * sin(M_PI/6);
    CGFloat cosRadius = _radius * cos(M_PI/6);
    
    // path 动画
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue         = (__bridge id)_layerCircle.path;
    pathAnimation.toValue           = (__bridge id)_pathBigCicrle.CGPath;

    // alpha 动画
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.fromValue         = [NSNumber numberWithFloat:0.0f];
    alphaAnimation.toValue           = [NSNumber numberWithFloat:1.0f];

    // 组合动画 使两个动画同时运作
    CAAnimationGroup *groupAnimation   = [[CAAnimationGroup alloc] init];
    groupAnimation.duration            = kAnimationDuration * 0.1;
    groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    groupAnimation.animations          = @[pathAnimation,alphaAnimation];
    groupAnimation.delegate            = self;
    groupAnimation.removedOnCompletion = NO;
    groupAnimation.fillMode            = kCAFillModeForwards;

    [_layerCircle addAnimation:groupAnimation forKey:@"group"];
    
    //logo出现
    [self UIViewCenterFadeAnimationWithSender:_imgLogo Duration:kAnimationDuration * 0.05 Delay:kAnimationDuration * 0.15 Center:CGPointMake(_centerPoint.x , _centerPoint.y - _radius) Alpha:1.0f completion:nil];
    
    //客户logo出现
    [self UIViewCenterFadeAnimationWithSender:_imgClient Duration:kAnimationDuration * 0.05 Delay:kAnimationDuration * 0.20 Center:CGPointMake(_centerPoint.x - cosRadius, _centerPoint.y + sinRadius) Alpha:1.0f completion:nil];
    
    //供应商logo出现
    [self UIViewCenterFadeAnimationWithSender:_imgSupplier Duration:kAnimationDuration * 0.05 Delay:kAnimationDuration * 0.25 Center:CGPointMake(_centerPoint.x + cosRadius, _centerPoint.y + sinRadius) Alpha:1.0f completion:^(BOOL finished) {
        
        //主logo下移
        [UIView animateWithDuration:kAnimationDuration * 0.1 delay:kAnimationDuration * 0.05 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _imgLogo.center = _centerPoint;
        } completion:^(BOOL finished) {
            
            //虚线圆圈缩小
            // path 动画
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
            pathAnimation.fromValue         = (__bridge id)_pathBigCicrle.CGPath;
            pathAnimation.toValue           = (__bridge id)_pathSmallCicrle.CGPath;
            
            // alpha 动画
            CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            alphaAnimation.fromValue         = [NSNumber numberWithFloat:1.0f];
            alphaAnimation.toValue           = [NSNumber numberWithFloat:0.0f];
            
            // 组合动画 使两个动画同时运作
            CAAnimationGroup *groupAnimation   = [[CAAnimationGroup alloc] init];
            groupAnimation.duration            = kAnimationDuration * 0.1;
            groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            groupAnimation.animations          = @[pathAnimation,alphaAnimation];
            groupAnimation.delegate            = self;
            groupAnimation.removedOnCompletion = NO;
            groupAnimation.fillMode            = kCAFillModeForwards;
            
            [_layerCircle addAnimation:groupAnimation forKey:@"group"];
            
            
            
            //主logo消失
            [self UIViewCenterFadeAnimationWithSender:_imgLogo Duration:kAnimationDuration * 0.05 Delay:kAnimationDuration * 0.1 Center:_imgLogo.center Alpha:0.0f completion:^(BOOL finished) {
                
                //字体跳动
                [self performSelector:@selector(springAnimation) withObject:nil afterDelay:kAnimationDuration * 0.1];
            }];
            
            
        }];
        
        //客户logo消失
        [self UIViewCenterFadeAnimationWithSender:_imgClient Duration:kAnimationDuration * 0.08 Delay:kAnimationDuration * 0.12 Center:CGPointMake(_imgClient.center.x, _imgClient.center.y + kLogoDownMove) Alpha:0.0f completion:^(BOOL finished) {
            
            
            //背景圆形遮罩放大
            CGFloat radius = sqrt(_centerPoint.x * _centerPoint.x + _centerPoint.y * _centerPoint.y);
            
            UIBezierPath *startPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_centerPoint.x, _centerPoint.y, 0, 0)];
            UIBezierPath *Mid1Path  = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, _centerPoint.y - _centerPoint.x, _centerPoint.x * 2, _centerPoint.x * 2)];
            UIBezierPath *Mid2Path  = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(_centerPoint.x - _radius, _centerPoint.y- _radius, _radius *2, _radius *2)];
            UIBezierPath *finalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, -(radius - _centerPoint.x), -(radius - _centerPoint.y))];
            
            CABasicAnimation *zoom1Animation   = [CABasicAnimation animationWithKeyPath:@"path"];
            zoom1Animation.fromValue           = (__bridge id)(startPath.CGPath);
            zoom1Animation.toValue             = (__bridge id)(Mid1Path.CGPath);
            zoom1Animation.duration            = kAnimationDuration * 0.2 * 0.3;
            zoom1Animation.timingFunction      = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            zoom1Animation.fillMode            = kCAFillModeForwards;
            zoom1Animation.removedOnCompletion = NO;
            
            CABasicAnimation *zoom2Animation   = [CABasicAnimation animationWithKeyPath:@"path"];
            zoom2Animation.fromValue           = (__bridge id)(Mid1Path.CGPath);
            zoom2Animation.toValue             = (__bridge id)(Mid2Path.CGPath);
            zoom2Animation.duration            = kAnimationDuration * 0.2 * 0.4;
            zoom2Animation.timingFunction      = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            zoom2Animation.fillMode            = kCAFillModeForwards;
            zoom2Animation.removedOnCompletion = NO;
            zoom2Animation.beginTime           = zoom1Animation.duration;
            
            CABasicAnimation *zoom3Animation   = [CABasicAnimation animationWithKeyPath:@"path"];
            zoom3Animation.fromValue           = (__bridge id)(Mid2Path.CGPath);
            zoom3Animation.toValue             = (__bridge id)(finalPath.CGPath);
            zoom3Animation.duration            = kAnimationDuration * 0.2 * 0.3;
            zoom3Animation.timingFunction      = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            zoom3Animation.fillMode            = kCAFillModeForwards;
            zoom3Animation.removedOnCompletion = NO;
            zoom3Animation.beginTime           = zoom2Animation.duration + zoom1Animation.duration;
            
            // 组合动画 使两个动画同时运作
            CAAnimationGroup *groupAnimation   = [[CAAnimationGroup alloc] init];
            groupAnimation.duration            = kAnimationDuration * 0.2;
            groupAnimation.timingFunction      = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            groupAnimation.animations          = @[zoom1Animation,zoom2Animation,zoom3Animation];
            groupAnimation.delegate            = self;
            groupAnimation.removedOnCompletion = NO;
            groupAnimation.fillMode            = kCAFillModeForwards;
            
            [_viewZoom.layer.mask addAnimation:groupAnimation forKey:@"zoomInvert"];
        }];
        
        //供应商logo消失
        [self UIViewCenterFadeAnimationWithSender:_imgSupplier Duration:kAnimationDuration * 0.08 Delay:kAnimationDuration * 0.12 Center:CGPointMake(_imgSupplier.center.x, _imgSupplier.center.y + kLogoDownMove) Alpha:0.0f completion:nil];
        
    }];
    
    
    
}



- (void)springAnimation {
    
    
    for (int i = 0 ; i < _arrLabel.count; i++) {
        
        //随机数生成 弹性系数和速度
        CGFloat damping = (arc4random()%4+6)/10;
        CGFloat velocity = arc4random()%5 + 10;
        
        //欢迎文字的进入动画
        [UIView animateWithDuration:kAnimationDuration * 0.1 delay:0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowUserInteraction animations:^{
            UILabel * lbl = _arrLabel[i];
            lbl.center = CGPointMake(lbl.center.x, _centerPoint.y) ;
        } completion:^(BOOL finished) {
            if (i == _arrLabel.count - 1) {
                
                _imgLogo.center = CGPointMake(_centerPoint.x, 0 - _imgLogo.frame.size.width / 2);
                _imgLogo.alpha = 1.0;
                
                //主logo掉落动画
                [UIView animateWithDuration:kAnimationDuration * 0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    _imgLogo.center = CGPointMake(_centerPoint.x, _centerPoint.y - 100);
                } completion:^(BOOL finished) {
                    //淡出动画
                    [self UIViewCenterFadeAnimationWithSender:self Duration:kAnimationDuration * 0.3 Delay:kAnimationDuration * 0.2 Center:_centerPoint Alpha:0.0f completion:^(BOOL finished) {
                        self.completionBlock();
                    }];
                }];
               
            }
        }];
    }
    
    
}



- (void)UIViewCenterFadeAnimationWithSender:(UIView *)sender Duration:(NSTimeInterval)duration Delay:(NSTimeInterval)delay Center:(CGPoint)center Alpha:(CGFloat)alpha completion:(void (^)(BOOL finished))completion{
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        sender.alpha  = alpha;
        sender.center = center;
    } completion:completion];
}

- (void)dealloc {

}

@end

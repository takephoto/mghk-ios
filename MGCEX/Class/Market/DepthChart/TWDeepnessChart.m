// MGC
//
// TWDeepnessChart.m
// 深度图demo
//
// Created by MGC on 2018/6/4.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "TWDeepnessChart.h"
#import "UIBezierPath+Draw.h"
#import "DepthChartModel.h"
#import "UIView+Extension.h"
#import "DepthLinePositionModel.h"

#define HeightScale  0.7  //最大值占百分比
#define widthradio [[UIScreen mainScreen] bounds].size.width/375
#define heightradio [[UIScreen mainScreen] bounds].size.height/667

@interface TWDeepnessChart(){
    
    __block double _minAssert;
    __block double _maxAssert;
}

@property (nonatomic,strong) NSMutableArray *modelPostionArray;
@property (nonatomic,strong) CAShapeLayer *lineChartLayer;
@property (nonatomic,strong) CAShapeLayer *boxLayer;
@property (nonatomic,strong) UILongPressGestureRecognizer *longPress;
@property (nonatomic,strong) CAShapeLayer *xLayer;
@property (nonatomic,strong) CAShapeLayer *yLayer;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UILabel *valueLabel;
@property (nonatomic,assign) NSInteger curentModelIndex;
@property (nonatomic,strong) CAShapeLayer *timeLayer;
@property (nonatomic,assign) CGFloat priceLayerHeight;

@property (nonatomic, strong) NSMutableArray * buyModelPostionArray;
@property (nonatomic, strong) NSMutableArray * sellModelPostionArray;
@end

@implementation TWDeepnessChart

#pragma mark draw

- (void)draw
{

    [self initConfig];
    [self initModelPostion];
    [self drawLineLayer];
    [self addTimeLayer];
    [self addAxisLayer];
    [self addLabels];
}

- (void)stockFill
{
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    [self draw];
}

- (void)drawLineLayer
{
    //买
    UIBezierPath *buyPath = [UIBezierPath drawLine:self.buyModelPostionArray];
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = buyPath.CGPath;
    self.lineChartLayer.strokeColor = self.buyLineColor.CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];

    self.lineChartLayer.lineWidth = 2;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    self.lineChartLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineChartLayer];
    
    DepthLinePositionModel *lastPoint = _buyModelPostionArray.lastObject;
    
    [buyPath addLineToPoint:CGPointMake(lastPoint.xPosition,(self.height - self.topMargin - self.priceLayerHeight))];
    [buyPath addLineToPoint:CGPointMake(self.leftMargin, (self.height - self.topMargin - self.priceLayerHeight))];
    
    buyPath.lineWidth = 0;
    [self.fillBuyColor setFill];
    [buyPath fill];
    [buyPath stroke];
    [buyPath closePath];
 
    //卖
    UIBezierPath *sellPath = [UIBezierPath drawLine:self.sellModelPostionArray];
    self.lineChartLayer = [CAShapeLayer layer];
    self.lineChartLayer.path = sellPath.CGPath;
    self.lineChartLayer.strokeColor = self.sellLineColor.CGColor;
    self.lineChartLayer.fillColor = [[UIColor clearColor] CGColor];
    
    self.lineChartLayer.lineWidth = 2;
    self.lineChartLayer.lineCap = kCALineCapRound;
    self.lineChartLayer.lineJoin = kCALineJoinRound;
    self.lineChartLayer.contentsScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:self.lineChartLayer];
    
    DepthLinePositionModel *lastSellPoint = _sellModelPostionArray.lastObject;
    DepthLinePositionModel *firstSellPoint = _sellModelPostionArray.firstObject;
    
    [sellPath addLineToPoint:CGPointMake(lastSellPoint.xPosition,(self.height - self.topMargin - self.priceLayerHeight))];
    [sellPath addLineToPoint:CGPointMake(firstSellPoint.xPosition, (self.height - self.topMargin - self.priceLayerHeight))];
    
    sellPath.lineWidth = 0;
    [self.fillSellColor setFill];
    [sellPath fill];
    [sellPath stroke];
    [sellPath closePath];
    
    //[self startRoundAnimation];
}


- (void)addAxisLayer
{
    self.xLayer = [CAShapeLayer layer];
    self.xLayer.lineWidth = 1;
    self.xLayer.lineCap = kCALineCapRound;
    self.xLayer.lineJoin = kCALineJoinRound;
    self.xLayer.strokeColor = [UIColor colorWithHexString:@"FFA500"].CGColor;
    self.xLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.layer addSublayer:self.xLayer];

    self.yLayer = [CAShapeLayer layer];
    self.yLayer.lineWidth = 1;
    self.yLayer.lineCap = kCALineCapRound;
    self.yLayer.lineJoin = kCALineJoinRound;
    self.yLayer.strokeColor = [UIColor colorWithHexString:@"FFA500"].CGColor;
    self.yLayer.fillColor = [[UIColor clearColor] CGColor];
    [self.layer addSublayer:self.yLayer];
    

    CGPoint point = [self getLastModelPostion];

    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:CGPointMake(point.x,0)];
    [xPath addLineToPoint:CGPointMake(point.x,self.height - self.priceLayerHeight)];
    //self.xLayer.path = xPath.CGPath;

    UIBezierPath *yPath = [UIBezierPath bezierPath];
    [yPath moveToPoint:CGPointMake(self.leftMargin,point.y)];
    [yPath addLineToPoint:CGPointMake(self.width - self.rightMargin,point.y)];
    //self.yLayer.path = yPath.CGPath;

//    for (NSInteger i = 1; i<3 ;i++)
//    {
//        CGFloat y = (self.height - self.priceLayerHeight) /3*(i);
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.lineWidth = widthradio;
//        layer.strokeColor = [UIColor colorWithHexString:@"ededed"].CGColor;
//        [layer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],nil]];
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(self.leftMargin,y)];
//        [path addLineToPoint:CGPointMake(self.width - self.rightMargin,y)];
//        layer.path = path.CGPath;
//        [self.layer addSublayer:layer];
//    }
//
//    for (NSInteger i = 1;i < 3;i++)
//    {
//        CGFloat x = self.width/3*(i);
//        CAShapeLayer *layer = [CAShapeLayer layer];
//        layer.lineWidth = heightradio;
//        layer.strokeColor = [UIColor colorWithHexString:@"ededed"].CGColor;
//        [layer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:2],[NSNumber numberWithInt:1],nil]];
//        UIBezierPath *path = [UIBezierPath bezierPath];
//        [path moveToPoint:CGPointMake(x,0)];
//        [path addLineToPoint:CGPointMake(x,self.height - self.priceLayerHeight)];
//        layer.path = path.CGPath;
//        [self.layer addSublayer:layer];
//    }
}

- (void)addTimeLayer
{
    self.timeLayer = [CAShapeLayer layer];
    self.timeLayer.contentsScale = [UIScreen mainScreen].scale;
    self.timeLayer.strokeColor = [UIColor clearColor].CGColor;
    self.timeLayer.fillColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:self.timeLayer];

  
    //最左边价格
    DepthChartModel *model = [self.buyArray firstObject];
    CGFloat x = self.leftMargin+40;
    CATextLayer *layer = [self getTextLayer];
    layer.string = [NSString stringWithFormat:@"%f",model.price];
    layer.position = CGPointMake(x,self.height - _priceLayerHeight/2);
    layer.alignmentMode = kCAAlignmentLeft;
    layer.foregroundColor =self.bottomPriceColor.CGColor;
    layer.bounds = CGRectMake(0, 0, 80, self.priceLayerHeight);
    [self.timeLayer addSublayer:layer];
    
    
    //中间价格
    DepthChartModel * model2 = [self.buyArray lastObject];
    DepthChartModel * model3 = [self.sellArray firstObject];
    float midxprice = (model2.price+model3.price)/2.0;
    CGFloat midx = self.width/2.0;
    CATextLayer *midlayer = [self getTextLayer];
    midlayer.string = [NSString stringWithFormat:@"%f",midxprice];
    midlayer.position = CGPointMake(midx,self.height - _priceLayerHeight/2);
    midlayer.alignmentMode = kCAAlignmentCenter;
    midlayer.foregroundColor =self.bottomPriceColor.CGColor;
    midlayer.bounds = CGRectMake(0, 0, 80, self.priceLayerHeight);
    [self.timeLayer addSublayer:midlayer];
    
    //最右边价格
    DepthChartModel *model4 = [self.sellArray lastObject];
    CGFloat lastx = self.width-_rightMargin-40;
    CATextLayer *lastlayer = [self getTextLayer];
    lastlayer.string = [NSString stringWithFormat:@"%f",model4.price];
    lastlayer.position = CGPointMake(lastx,self.height - _priceLayerHeight/2);
    lastlayer.alignmentMode = kCAAlignmentRight;
    lastlayer.foregroundColor =self.bottomPriceColor.CGColor;
    lastlayer.bounds = CGRectMake(0, 0, 80, self.priceLayerHeight);
    [self.timeLayer addSublayer:lastlayer];
    
    
    DepthChartModel * buyTotalmodel = [self.buyArray firstObject];
    DepthChartModel * sellTotalmodel = [self.sellArray lastObject];
    //拿到最高成交量
    float maxTotal = MAX(buyTotalmodel.totalNumber, sellTotalmodel.totalNumber);
    //拿到最高成交量对应的Y值
    float heightY = (maxTotal - _minAssert)*self.scaleY;
    //计算Y方向上一个单元格对应多少成交量
    float unitNumber = maxTotal/heightY;
    //分多少档
    float unit = 4.0;
    //分多少像素为一档
    float unitHeight = self.maxY/unit;
    //成交量数据
    for(int i=1;i<unit;i++){
        
        CGFloat x = self.leftMargin+40;
        CATextLayer *layer = [self getTextLayer];
        layer.string = [NSString stringWithFormat:@"%.1f",unitNumber*i*unitHeight];
        layer.position = CGPointMake(x,self.maxY-i*unitHeight);
        layer.alignmentMode = kCAAlignmentLeft;
        layer.foregroundColor =self.volumeColor.CGColor;
        layer.bounds = CGRectMake(0, 0, 80, self.priceLayerHeight);
        [self.timeLayer addSublayer:layer];
    }
}

- (void)addLabels
{
    _timeLabel = [self createLabel];
    [self addSubview:_timeLabel];
    _timeLabel.bounds = CGRectMake(0, 0, 100, 20);

    _valueLabel = [self createLabel];
    [self addSubview:_valueLabel];
    _valueLabel.bounds = CGRectMake(0, 0, 100, 20);
}

#pragma mark Animation

- (void)startRoundAnimation
{
    DepthLinePositionModel *nextPoint = [_buyModelPostionArray lastObject];
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(nextPoint.xPosition, nextPoint.yPosition) radius:5 startAngle:0 endAngle:2*M_PI clockwise:YES];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    layer.fillColor = [UIColor colorWithHexString:@"d96c9c"].CGColor;
    [self.layer addSublayer:layer];

    NSInteger pulsingCount = 1;
    double animationDuration = 2;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(nextPoint.xPosition-5,nextPoint.yPosition - 5, 10, 10);
        pulsingLayer.borderColor = [UIColor colorWithHexString:@"e73785"].CGColor;
        pulsingLayer.borderWidth = 1;
        pulsingLayer.cornerRadius = 5;
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;

        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1;
        scaleAnimation.toValue = @2.2;

        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
}

#pragma mark init

- (void)initModelPostion
{
    //获取长按坐标
    _modelPostionArray = [NSMutableArray array];
    for (NSInteger i = 0;i<_dataArray.count;i++)
    {
        DepthChartModel *model = [_dataArray objectAtIndex:i];
        CGFloat xPostion = (self.lineWidth)*i + self.leftMargin;
        CGFloat yPostion = self.maxY - (model.totalNumber - _minAssert)*self.scaleY;
        DepthLinePositionModel *postitionModel = [DepthLinePositionModel initPositon:xPostion yPosition:yPostion color:[UIColor redColor]];
        [_modelPostionArray addObject:postitionModel];
    }
    
    [self.buyModelPostionArray removeAllObjects];
    for (NSInteger i = 0;i<self.buyArray.count;i++)
    {
        DepthChartModel *model = [_buyArray objectAtIndex:i];
        CGFloat xPostion = self.lineWidth*i + self.leftMargin;
        CGFloat yPostion = self.maxY - (model.totalNumber - _minAssert)*self.scaleY;
        DepthLinePositionModel *postitionModel = [DepthLinePositionModel initPositon:xPostion yPosition:yPostion color:[UIColor redColor]];
        [self.buyModelPostionArray addObject:postitionModel];
    }
    
    [self.sellModelPostionArray removeAllObjects];
    for (NSInteger i = 0;i<self.sellArray.count;i++)
    {
        DepthChartModel *model = [_sellArray objectAtIndex:i];
        CGFloat xPostion = self.lineWidth*self.buyArray.count+ self.leftMargin + self.lineWidth*i;
        CGFloat yPostion = self.maxY - (model.totalNumber - _minAssert)*self.scaleY;
        DepthLinePositionModel *postitionModel = [DepthLinePositionModel initPositon:xPostion yPosition:yPostion color:[UIColor redColor]];
        [self.sellModelPostionArray addObject:postitionModel];
    }
}

- (void)initConfig
{

    self.priceLayerHeight = 20;
    self.lineWidth  = (self.width - self.leftMargin - self.rightMargin )/self.timesCount;
    self.maxY = CGFLOAT_MIN;
    self.minY = CGFLOAT_MAX;

    DepthChartModel * firstModel = _dataArray.firstObject;
    _minAssert = firstModel.totalNumber;
    _maxAssert = firstModel.totalNumber;
    
    [_dataArray enumerateObjectsUsingBlock:^(__kindof DepthChartModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if(obj.totalNumber > _maxAssert)
        {
            _maxAssert = obj.totalNumber;
        }
        if(obj.totalNumber < _minAssert)
        {
            _minAssert = obj.totalNumber;
        }
        
    }];

    //画的图不能占全屏，留点空隙
    _maxAssert *= 1.0001;

    self.maxY = (self.height - self.topMargin - self.bottomMargin - self.priceLayerHeight);

    self.scaleY = ((self.height - self.topMargin - self.bottomMargin - self.priceLayerHeight)*HeightScale)/(_maxAssert-_minAssert);

    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressGesture:)];
    [self addGestureRecognizer:self.longPress];
}

#pragma mark 长按手势

- (void)LongPressGesture:(UILongPressGestureRecognizer*)longPress
{
    static CGFloat oldPositionX = 0;
    if(UIGestureRecognizerStateChanged == longPress.state || UIGestureRecognizerStateBegan == longPress.state)
    {
        CGPoint location = [longPress locationInView:self];
        CGPoint point = [self getLongPressModelPostionWithXPostion:location.x];

        UIBezierPath *xPath = [UIBezierPath bezierPath];
        [xPath moveToPoint:CGPointMake(point.x,0)];
        [xPath addLineToPoint:CGPointMake(point.x,self.height - self.priceLayerHeight)];
        self.xLayer.path = xPath.CGPath;

        UIBezierPath *yPath = [UIBezierPath bezierPath];
        [yPath moveToPoint:CGPointMake(self.leftMargin,point.y)];
        [yPath addLineToPoint:CGPointMake(self.width - self.rightMargin,point.y)];
        self.yLayer.path = yPath.CGPath;

        _timeLabel.center = CGPointMake(point.x, _timeLabel.height/2);
        _valueLabel.center = CGPointMake(_valueLabel.width/2 + self.leftMargin, point.y);
        if (_timeLabel.center.x  + _timeLabel.width/2 >= self.width - self.rightMargin)
        {
            _timeLabel.center = CGPointMake(self.width-_timeLabel.width/2 - self.rightMargin, _timeLabel.height/2);
        }

        else if (_timeLabel.center.x  - _timeLabel.width/2 <= self.leftMargin)
        {
            _timeLabel.center = CGPointMake(self.leftMargin + _timeLabel.width/2, _timeLabel.height/2);
        }

        DepthChartModel *model = _dataArray[_curentModelIndex];
        _timeLabel.text = [NSString stringWithFormat:@"%f",model.price];
        _valueLabel.text = [NSString stringWithFormat:@"%f",model.totalNumber];
        _timeLabel.hidden = NO;
        _valueLabel.hidden = NO;
//        _timeLabel.backgroundColor = [UIColor redColor];
//        _valueLabel.backgroundColor = _priceLabelColor;
        _timeLabel.textColor = [UIColor whiteColor];
        _valueLabel.textColor = [UIColor whiteColor];
        oldPositionX = location.x;
    }

    if(longPress.state == UIGestureRecognizerStateEnded)
    {
        self.xLayer.path = [UIBezierPath bezierPath].CGPath;
        self.yLayer.path = [UIBezierPath bezierPath].CGPath;
        _timeLabel.hidden = YES;
        _valueLabel.hidden = YES;
        oldPositionX = 0;
    }
}

#pragma mark 长按获取坐标

- (CGPoint)getLongPressModelPostionWithXPostion:(CGFloat)xPostion
{
    for (NSInteger i = 0; i<self.modelPostionArray.count; i++) {
        DepthLinePositionModel *model = self.modelPostionArray[i];
        CGFloat minX = fabs(model.xPosition - self.lineWidth);
        CGFloat maxX = model.xPosition + self.lineWidth;

        if (xPostion - self.leftMargin >= minX && xPostion - self.rightMargin  < maxX)
        {
            _curentModelIndex = i;
            return CGPointMake(model.xPosition , model.yPosition);
        }
    }

    DepthLinePositionModel *lastPoint = _modelPostionArray.lastObject;
    if (xPostion >= lastPoint.xPosition)
    {
        _curentModelIndex = _modelPostionArray.count - 1;
        return CGPointMake(lastPoint.xPosition, lastPoint.yPosition);
    }

    DepthLinePositionModel *firstPoint = _modelPostionArray.firstObject;
    if (fabs(xPostion - self.leftMargin)  <= firstPoint.xPosition)
    {
        _curentModelIndex = 0;
        return CGPointMake(firstPoint.xPosition, firstPoint.yPosition);
    }
    return CGPointZero;
}

- (CGPoint)getLastModelPostion
{
    if (_modelPostionArray.count>0)
    {
        DepthLinePositionModel *lastPoint = _modelPostionArray.lastObject;
        return CGPointMake(lastPoint.xPosition, lastPoint.yPosition);
    }
    return CGPointZero;
}

#pragma mark privateMethod

- (UILabel*)createLabel
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor colorWithHexString:@"a8a8a8"];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithHexString:@"353535"];
    label.hidden = YES;
    return label;
}

- (CAShapeLayer*)getAxispLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.strokeColor = [UIColor colorWithHexString:@"ededed"].CGColor;
    layer.fillColor = [[UIColor clearColor] CGColor];
    layer.contentsScale = [UIScreen mainScreen].scale;
    return layer;
}

- (CATextLayer*)getTextLayer
{
    CATextLayer *layer = [CATextLayer layer];
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.fontSize = 12.f;
    layer.foregroundColor =
    [UIColor grayColor].CGColor;
    return layer;
}


#pragma mark -- 懒加载

- (NSMutableArray*)modelPostionArray
{
    if (!_modelPostionArray)
    {
        _modelPostionArray = [NSMutableArray array];
    }
    return _modelPostionArray;
}

-(NSMutableArray *)buyModelPostionArray{
    if(!_buyModelPostionArray){
        _buyModelPostionArray = [NSMutableArray new];
    }
    return _buyModelPostionArray;
}

-(NSMutableArray *)sellModelPostionArray{
    if(!_sellModelPostionArray){
        _sellModelPostionArray = [NSMutableArray new];
    }
    return _sellModelPostionArray;
}
@end

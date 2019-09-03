// MGC
//
// CustomSegmentedView.m
// MGCPay
//
// Created by MGC on 2018/3/20.
// Copyright © 2018年 Joblee. All rights reserved.
//
// @ description <#描述#> 

#import "CustomSegmentedView.h"

@interface CustomSegmentedView()
#define kActionViewTag 10000
#define kActionLabelTag 100
@property (nonatomic, strong) NSArray * segmentArr;
@end

@implementation CustomSegmentedView

-(instancetype)initWithSegmentArr:(NSArray *)array frame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.segmentArr = array;
        [self setUpViews];
    }
    return self;
}

-(void)layoutSubviews
{
    
}
-(void)setUpViews{
    _backView = [[UIView alloc]init];
    [self addSubview:_backView];
    _backView.backgroundColor = kNavTintColor;
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    for(int i=0;i<self.segmentArr.count;i++){
        [self addItemWithIndex:i];
    }
    
    self.segLabel1 = [self viewWithTag:kActionLabelTag];
    self.segLabel2 = [self viewWithTag:kActionLabelTag+1];
    self.segLabel3 = [self viewWithTag:kActionLabelTag+2];
    self.segLabel4 = [self viewWithTag:kActionLabelTag+3];

    _slidView = [[UIView alloc]init];
    [_backView addSubview:_slidView];
    _slidView.backgroundColor = kBackGroundColor;
    [_slidView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backView);
        make.bottom.mas_equalTo(_backView.mas_bottom);
        make.width.mas_equalTo(self.frame.size.width/self.segmentArr.count);
        make.height.mas_equalTo(Adapted(2));
    }];
}
//添加item
- (void)addItemWithIndex:(NSInteger)index
{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(index*self.bounds.size.width/_segmentArr.count, 0, self.bounds.size.width/_segmentArr.count, self.bounds.size.height)];
    [self addSubview:label];
    label.tag = kActionLabelTag+index;
    label.textColor = k99999Color;
    label.font = H17;
    label.userInteractionEnabled = YES;
    label.text = self.segmentArr[index];
    label.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LabelClick:)];
    [label addGestureRecognizer:tap];
    
    UIView * segmentationView = [[UIView alloc]init];
    [_backView addSubview:segmentationView];
    segmentationView.backgroundColor = kBackAssistColor;
    segmentationView.tag = kActionViewTag+index;
    segmentationView.frame = CGRectMake(index*self.bounds.size.width/_segmentArr.count, (self.bounds.size.height-self.bounds.size.height*0.5)/2.0, 1, self.bounds.size.height*0.5);
}
- (void)removeItemWithIndex:(NSInteger)index
{
    UILabel * label = [self viewWithTag:kActionLabelTag+index];
    [label removeFromSuperview];
    UIView * segmentationView = [self viewWithTag:kActionViewTag+index];
    [segmentationView removeFromSuperview];
}
///更新控件
-(void)updateWithSegmentArr:(NSArray *)array frame:(CGRect)frame
{
    //检查是否有多余的item,多余的移除，缺少的添加
    //多余
    if (self.segmentArr.count>array) {
        for(int i=array.count-1;i<self.segmentArr.count;i++){
            
        }
    }
    //缺少
    if (self.segmentArr.count>array) {
        for(int i=array.count-1;i<self.segmentArr.count;i++){
            UILabel * label = [self viewWithTag:i+1];
            [label removeFromSuperview];
        }
    }
    
    for(int i=0;i<self.segmentArr.count;i++){
        UILabel * label = [self viewWithTag:i+1];
        label.text = self.segmentArr[i];
    }
    self.segmentArr = array;
}
///点击选项
-(void)LabelClick:(UITapGestureRecognizer *)ges{

    UILabel * label = (UILabel *)[self viewWithTag:ges.view.tag];
    if (self.selectTextColor) {
        for (int i=1;i<=_segmentArr.count;i++) {
            UILabel *labelTemp = [self viewWithTag:i];
            labelTemp.textColor = kTextColor;
        }
        label.textColor = self.selectTextColor;
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _slidView.frame;
        frame.origin.x = label.frame.origin.x;
        _slidView.frame = frame;
        
    }];

    
    if(self.segmentCallBlock){
        self.segmentCallBlock(ges.view.tag,label);
    }
}
///切换到某个选项
-(void)changeToIndex:(NSInteger)index{
    index += 1;
    UILabel *label = [self viewWithTag:index];
    if (self.selectTextColor) {
        for (int i=1;i<=_segmentArr.count;i++) {
            UILabel *labelTemp = [self viewWithTag:i];
            labelTemp.textColor = kTextColor;
        }
        label.textColor = self.selectTextColor;
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = _slidView.frame;
        frame.origin.x = label.frame.origin.x;
        _slidView.frame = frame;
        
    }];
    
    if(self.segmentCallBlock){
        self.segmentCallBlock(index,label);
    }
}
///设置选中颜色
-(void)setSegmentColor:(UIColor *)segmentColor{
    _segmentColor = segmentColor;
    _slidView.backgroundColor = _segmentColor;
}

@end

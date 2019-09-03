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
//label
#define kActionLabelTag 100
//view
#define kActionViewTag 10000

@interface CustomSegmentedView()
@property (nonatomic, strong) NSArray * segmentArr;
//@property (nonatomic, strong) NSArray * segmentArr;
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
    //文案标签
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(index*self.bounds.size.width/_segmentArr.count, 0, self.bounds.size.width/_segmentArr.count, self.bounds.size.height)];
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(index*self.bounds.size.width/_segmentArr.count);
        make.width.mas_equalTo(self.bounds.size.width/_segmentArr.count);
    }];
    label.tag = kActionLabelTag+index;
    label.textColor = k99999Color;
    label.font = H16;
    label.numberOfLines = 0;
    label.userInteractionEnabled = YES;
    label.text = self.segmentArr[index];
    label.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LabelClick:)];
    [label addGestureRecognizer:tap];
    //分割线
//    UIView * segmentationView = [[UIView alloc]init];
//    [_backView addSubview:segmentationView];
//    segmentationView.backgroundColor = kBackAssistColor;
//    segmentationView.tag = kActionViewTag+index;
//    segmentationView.frame = CGRectMake(index*self.bounds.size.width/_segmentArr.count, (self.bounds.size.height-self.bounds.size.height*0.5)/2.0, 1, self.bounds.size.height*0.5);
}

///点击选项
-(void)LabelClick:(UITapGestureRecognizer *)ges{
    
    UILabel * label = (UILabel *)[self viewWithTag:ges.view.tag];
    if (self.selectTextColor) {
        for (int i=0;i<=_segmentArr.count;i++) {
            UILabel *labelTemp = [self viewWithTag:kActionLabelTag+i];
            labelTemp.textColor = self.textColor;
        }
        label.textColor = self.selectTextColor;
    }
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        [_slidView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_offset((ges.view.tag - 100) *label.width);
        }];
        [_slidView.superview layoutIfNeeded];
    }];
    if(self.segmentCallBlock){
        self.segmentCallBlock(ges.view.tag-kActionLabelTag,label);
    }
}
///代码切换到某个选项
-(void)changeToIndex:(NSInteger)index{
    
    UILabel *label = [self viewWithTag:kActionLabelTag+index];
    if (self.selectTextColor) {
        for (int i=0;i<=_segmentArr.count-1;i++) {
            UILabel *labelTemp = [self viewWithTag:kActionLabelTag+i];
            labelTemp.textColor = self.textColor;
        }
        label.textColor = self.selectTextColor;
    }
    
    [self layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{

        [_slidView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_offset(index *label.width);
        }];
        [_slidView.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        
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

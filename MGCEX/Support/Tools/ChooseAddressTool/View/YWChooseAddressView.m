//
//  YWChooseAddressView.m
//  YWChooseAddressView
//
//  Created by 90Candy on 17/12/22.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "YWChooseAddressView.h"
#import "YWAddressView.h"
#import "YWAddressTableViewCell.h"
#import "YWAddressModel.h"


#define YWCOLOR(_R,_G,_B,_A)    [UIColor colorWithRed:_R/255.0 green:_G/255.0 blue:_B/255.0 alpha:_A]
static  CGFloat  const  kHYTopViewHeight = 40; //顶部视图的高度
static  CGFloat  const  kHYTopTabbarHeight = 30; //地址标签栏的高度

@interface YWChooseAddressView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    BOOL        _isShow;
    UIView      *_backView;
}
@property (nonatomic,weak) YWAddressView        * topTabbar;
@property (nonatomic,weak) UIScrollView         * contentView;
@property (nonatomic,weak) UIView               * underLine;
@property (nonatomic,strong) NSMutableArray     * dataSouce;
@property (nonatomic,strong) NSMutableArray     * cityDataSouce;
@property (nonatomic,strong) NSMutableArray     * districtDataSouce;
@property (nonatomic,strong) NSMutableArray     * tableViews;
@property (nonatomic,strong) NSMutableArray     * topTabbarItems;
@property (nonatomic,weak) UIButton             * selectedBtn;

//当前选中的cell
@property (nonatomic, strong) YWAddressModel * selectProvince;
@property (nonatomic, strong) YWAddressModel * selectCity;
@property (nonatomic, strong) YWAddressModel * selectDistrict;
@end

@implementation YWChooseAddressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - setUp UI

- (void)setUp {
    
    
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT)];
    _backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _backView.alpha = 0.0f;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [_backView addGestureRecognizer:tap];

    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topView];
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"选择您所在地区";
    [titleLabel sizeToFit];
    [topView addSubview:titleLabel];
    titleLabel.centerY = topView.height * 0.5;
    titleLabel.centerX = topView.width * 0.5;
    UIView * separateLine = [self separateLine];
    [topView addSubview: separateLine];
    separateLine.top = topView.height - separateLine.height;
    topView.backgroundColor = [UIColor whiteColor];

    
    YWAddressView * topTabbar = [[YWAddressView alloc]initWithFrame:CGRectMake(0, topView.height, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    
    _underLine.backgroundColor = [UIColor orangeColor];
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kHYTopViewHeight - kHYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(MAIN_SCREEN_WIDTH, 0);
    [self addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    _contentView.backgroundColor = [UIColor whiteColor];
    [self addTableView];
    _contentView.delegate = self;
}


- (void)addTableView {

    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * MAIN_SCREEN_WIDTH, 0, MAIN_SCREEN_WIDTH, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 80, 0);
    tabbleView.rowHeight = 44;
    [tabbleView registerClass:[YWAddressTableViewCell class] forCellReuseIdentifier:@"YWAddressTableViewCell"];
}

- (void)addTopBarItem {
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:YWCOLOR(43, 43, 43, 1) forState:UIControlStateNormal];
    [topBarItem setTitleColor:YWCOLOR(255, 85, 0, 1) forState:UIControlStateSelected];
    [topBarItem sizeToFit];
     topBarItem.centerY = _topTabbar.height*0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([self.tableViews indexOfObject:tableView] == 0){
        return self.dataSouce.count;
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        return self.cityDataSouce.count;
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        return self.districtDataSouce.count;
    }
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YWAddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YWAddressTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    YWAddressModel * item;
    //省级别
    if([self.tableViews indexOfObject:tableView] == 0){
        item = self.dataSouce[indexPath.row];
    //市级别
    } else if ([self.tableViews indexOfObject:tableView] == 1){
        item = self.cityDataSouce[indexPath.row];
    //县级别
    } else if ([self.tableViews indexOfObject:tableView] == 2){
        item = self.districtDataSouce[indexPath.row];
    }
    cell.item = item;
    return cell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.tableViews indexOfObject:tableView] == 0){///////////////////**选择省**///////////////////
        
        //保留当前选中的item数据，如果没有下级，则返回当前数据
        YWAddressModel *provinceItem = self.dataSouce[indexPath.row];
        self.selectProvince = provinceItem;
       
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        //第一次选择,获取市数据，否则不重新获取
        if ([indexPath0 compare:indexPath] != NSOrderedSame || !indexPath0){
            self.cityDataSouce = [self AccessToTheNextLevelDataSourceWithShengID:provinceItem.name cityID:nil];
        }
        
        if(self.cityDataSouce.count == 0) {//是否是直辖市
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self setUpAddress:provinceItem.name];
            self.selectCity = nil;
            self.selectDistrict = nil;
            return indexPath;
        }
        
        //选择的省跟上次选的不一样，必须移除最后的区
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
         
            return indexPath;
            
            //重新选相同的省，必须移除最后的区
        }else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
            for (int i = 0; i < self.tableViews.count && self.tableViews.count != 1 ; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:provinceItem.name];
     
            return indexPath;
        }

        //之前未选中省，第一次选择省
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem:provinceItem.name ];
        
    } else if ([self.tableViews indexOfObject:tableView] == 1) {///////////////////**选择市**///////////////////
        
        //保留当前选中的item数据，如果没有下级，则返回当前数据
        YWAddressModel *cityItem = self.cityDataSouce[indexPath.row];
        self.selectCity = cityItem;
        
        //第一次选择,获取区数据，否则不重新获取
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        if ([indexPath0 compare:indexPath] != NSOrderedSame || !indexPath0){
            self.districtDataSouce = [self AccessToTheNextLevelDataSourceWithShengID:self.selectProvince.name cityID:cityItem.name];
        }
        
        if(self.districtDataSouce.count == 0) {//是否是直辖市
            if (self.tableViews.count == 3) {
                [self removeLastItem];
            }
            [self setUpAddress:cityItem.name];
            self.selectDistrict = nil;
            return indexPath;
        }

        //选择的市跟上次选择的不相同
        if ([indexPath0 compare:indexPath] != NSOrderedSame && indexPath0) {
            for (int i = 0; i < self.tableViews.count - 1; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            [self scrollToNextItem:cityItem.name];
            return indexPath;

        } else if ([indexPath0 compare:indexPath] == NSOrderedSame && indexPath0) {
        
            [self scrollToNextItem:cityItem.name];
            return indexPath;
        }
        
        [self addTopBarItem];
        [self addTableView];
        [self scrollToNextItem:cityItem.name];
        
    } else if ([self.tableViews indexOfObject:tableView] == 2) {///////////////////**选择区**///////////////////
        
        YWAddressModel * item = self.districtDataSouce[indexPath.row];
        self.selectDistrict = item;
        [self setUpAddress:item.name];
    }
    return indexPath;
}

//获取下一级数据
-(NSMutableArray *)AccessToTheNextLevelDataSourceWithShengID:(NSString *)ShengID cityID:(NSString *)cityID{
    
    //获取省对应所有市数组
    if(ShengID && !cityID){
        [self.cityDataSouce removeAllObjects];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray * allP = [NSArray arrayWithArray:[data objectForKey:@"address"]];
        
        [allP enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if([obj[@"name"] isEqualToString:ShengID]){
                
                NSArray * subArr = obj[@"sub"];
                for (NSDictionary * dic in subArr) {
                    YWAddressModel * item = [[YWAddressModel alloc]init];
                    item.name = dic[@"name"];
                    [self.cityDataSouce addObject:item];
                }
                
                *stop = YES;
            }
        }];

        return self.cityDataSouce;
        
        //获取市对应的区数据
    }else if (ShengID && cityID){
        
        [self.districtDataSouce removeAllObjects];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray * allP = [NSArray arrayWithArray:[data objectForKey:@"address"]];
        
        [allP enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if([obj[@"name"] isEqualToString:ShengID]){
                
                NSArray * subArr = obj[@"sub"];
                [subArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if([obj[@"name"] isEqualToString:cityID]){
                        NSArray * quArr = obj[@"sub"];
                        for (NSString *name in quArr) {
                            YWAddressModel * item = [[YWAddressModel alloc]init];
                            item.name = name;
                            [self.districtDataSouce addObject:item];
                        }
                        
                        *stop = YES;
                    }
                    
                }];
                
             *stop = YES;
            }
        }];

        return self.districtDataSouce;
    }
    return nil;
}

//现在已经选中的cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YWAddressModel * item;
    if([self.tableViews indexOfObject:tableView] == 0) {
       item = self.dataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
       item = self.cityDataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
       item = self.districtDataSouce[indexPath.row];
    }
    item.isSelected = YES;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
}

//之前选中的cell,消除选中标志
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YWAddressModel * item;
    if([self.tableViews indexOfObject:tableView] == 0) {
        item = self.dataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 1) {
        item = self.cityDataSouce[indexPath.row];
    } else if ([self.tableViews indexOfObject:tableView] == 2) {
        item = self.districtDataSouce[indexPath.row];
    }
    item.isSelected = NO;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

}


#pragma mark - private
//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn {
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * MAIN_SCREEN_WIDTH, 0);
        [self changeUnderLineFrame:btn];
    }];
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton  *)btn {
    
    _selectedBtn.selected = NO;
    btn.selected = YES;
    _selectedBtn = btn;
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(NSString *)address {

    NSInteger index = self.contentView.contentOffset.x / MAIN_SCREEN_WIDTH;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
    NSMutableString * addressStr = [[NSMutableString alloc] init];
    for (UIButton * btn  in self.topTabbarItems) {
        if ([btn.currentTitle isEqualToString:@"县"] || [btn.currentTitle isEqualToString:@"市辖区"] ) {
            continue;
        }
        [addressStr appendString:btn.currentTitle];
        [addressStr appendString:@" "]; // 省市区地址间加空格或者其他间隔符号
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.chooseFinish) {
         self.chooseFinish(addressStr,self.selectProvince.name,self.selectCity.name,self.selectDistrict.name);
        }
        
        [self dismiss];
    });
}

//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem {

    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle {
    
    NSInteger index = self.contentView.contentOffset.x / MAIN_SCREEN_WIDTH;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.contentSize = (CGSize){self.tableViews.count * MAIN_SCREEN_WIDTH,0};
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + MAIN_SCREEN_WIDTH, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}


#pragma mark - <UIScrollView>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if(scrollView != self.contentView) return;
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        NSInteger index = scrollView.contentOffset.x / MAIN_SCREEN_WIDTH;
        UIButton * btn = weakSelf.topTabbarItems[index];
        [weakSelf changeUnderLineFrame:btn];
    }];
}

#pragma mark - 开始就有地址时.
//重新打开时，默认上次选中的省市区
-(void)upDataTableViewsProvince:(NSString *)province city:(NSString *)city district:(NSString *)district{

    if(kStringIsEmpty(city) || kStringIsEmpty(district))  return;
    
    self.selectProvince.name = province;
    self.selectCity.name = city;
    self.selectDistrict.name = district;
    
    //2.1 添加市级别,地区级别列表
    [self addTableView];
    [self addTableView];

    
    //获取市级数组
    self.cityDataSouce = [self AccessToTheNextLevelDataSourceWithShengID:province cityID:nil];
    //获取县级数组
    self.districtDataSouce = [self AccessToTheNextLevelDataSourceWithShengID:province cityID:city];
    
    //2.3 添加底部对应按钮
    [self addTopBarItem];
    [self addTopBarItem];
  
    UIButton * firstBtn = self.topTabbarItems.firstObject;
    [firstBtn setTitle:province forState:UIControlStateNormal];

    UIButton * midBtn = self.topTabbarItems[1];
    [midBtn setTitle:city forState:UIControlStateNormal];

    UIButton * lastBtn = self.topTabbarItems.lastObject;
    [lastBtn setTitle:district forState:UIControlStateNormal];
    [self.topTabbarItems makeObjectsPerformSelector:@selector(sizeToFit)];
    [_topTabbar layoutIfNeeded];
    
    
    [self changeUnderLineFrame:lastBtn];
    
    //2.4 设置偏移量
    self.contentView.contentSize = (CGSize){self.tableViews.count * MAIN_SCREEN_WIDTH,0};
    CGPoint offset = self.contentView.contentOffset;
    self.contentView.contentOffset = CGPointMake((self.tableViews.count - 1) * MAIN_SCREEN_WIDTH, offset.y);
    
    [self setSelectedProvince:province andCity:city andDistrict:district];
    
}


//初始化选中状态
- (void)setSelectedProvince:(NSString *)provinceName andCity:(NSString *)cityName andDistrict:(NSString *)districtName {
    
    for (YWAddressModel * item in self.dataSouce) {
        if ([item.name isEqualToString:provinceName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[self.dataSouce indexOfObject:item] inSection:0];
            UITableView * tableView  = self.tableViews.firstObject;
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i < self.cityDataSouce.count; i++) {
        YWAddressModel * item = self.cityDataSouce[i];
        
        if ([item.name isEqualToString:cityName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[1];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
    
    for (int i = 0; i <self.districtDataSouce.count; i++) {
        YWAddressModel * item = self.districtDataSouce[i];
        if ([item.name isEqualToString:districtName]) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            UITableView * tableView  = self.tableViews[2];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
            break;
        }
    }
}

#pragma mark - public

- (void)show
{
    if(_isShow) return;
    
    _isShow = YES;
    
    self.frame = CGRectMake(0, MAIN_SCREEN_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
      [[[[UIApplication sharedApplication] delegate] window] addSubview:_backView];
      [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
  
    [UIView animateWithDuration:.5f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{

        self.frame = CGRectMake(0, MAIN_SCREEN_HEIGHT-CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        _backView.alpha = 1.0;

    } completion:^(BOOL finished){

    }];
}


- (void)dismiss
{
    _isShow = NO;
    
    [UIView animateWithDuration:0.35f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
        
        _backView.alpha = 0.0;
        
        self.frame = CGRectMake(0, MAIN_SCREEN_HEIGHT, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_backView removeFromSuperview];

    }];
}

#pragma mark - getter 方法

//分割线
- (UIView *)separateLine {
    
    UIView * separateLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1 / [UIScreen mainScreen].scale)];
    separateLine.backgroundColor = YWCOLOR(222, 222, 222, 1);
    return separateLine;
}

- (NSMutableArray *)tableViews {
    
    if (!_tableViews) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems {
    if (!_topTabbarItems) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}


//省级别数据源
- (NSMutableArray *)dataSouce {
    
    if (!_dataSouce) {

        _dataSouce = [NSMutableArray new];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"address" ofType:@"plist"];
        NSDictionary *data = [NSDictionary dictionaryWithContentsOfFile:path];
        NSArray * allP = [NSArray arrayWithArray:[data objectForKey:@"address"]];
        
        for (NSDictionary * dic in allP) {
            YWAddressModel * item = [[YWAddressModel alloc]init];
            item.name = dic[@"name"];
            [_dataSouce addObject:item];
        }
        
    }
    return _dataSouce;
}

-(NSMutableArray *)cityDataSouce{
    if(!_cityDataSouce){
        _cityDataSouce = [NSMutableArray new];
    }
    return _cityDataSouce;
}

-(NSMutableArray *)districtDataSouce{
    if(!_districtDataSouce){
        _districtDataSouce = [NSMutableArray new];
    }
    return _districtDataSouce;
}

-(YWAddressModel *)selectProvince{
    if(!_selectProvince){
        _selectProvince = [[YWAddressModel alloc]init];
    }
    return _selectProvince;
}

-(YWAddressModel *)selectCity{
    if(!_selectCity){
        _selectCity = [[YWAddressModel alloc]init];
    }
    return _selectCity;
}

-(YWAddressModel *)selectDistrict{
    if(!_selectDistrict){
        _selectDistrict = [[YWAddressModel alloc]init];
    }
    return _selectDistrict;
}
@end

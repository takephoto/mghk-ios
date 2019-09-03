// MGC
//
// ChangeCountryIndexVC.m
// MGCEX
//
// Created by MGC on 2018/5/14.
// Copyright © 2018年 MGCion. All rights reserved.
//
// @ description <#描述#> 

#import "ChangeCountryIndexVC.h"
#import "ChangeCountryCell.h"
#import "PinYin4Objc.h"
#import "ChangeCountModel.h"
#import "MailRegisterVC.h"
@interface ChangeCountryIndexVC ()
@property (nonatomic, strong) UITextField * textField;
// 名字的所有首字母数组
@property (nonatomic,strong) NSArray *letterArr;
// 根据key存放同一名字下的所有数组
@property (nonatomic,strong) NSMutableDictionary *nameDict;
@property(nonatomic,strong)NSMutableArray * searchArr;
@property (nonatomic,strong) NSMutableArray *filterFirends;
@property (nonatomic,strong) NSMutableArray *filterData;
@property (nonatomic, strong) NSMutableArray * countryArray;

@end

@implementation ChangeCountryIndexVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = kLocalizedString(@"设置国际地区");
    self.view.backgroundColor = white_color;
    //搜索框
    UIView * searchBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(70))];
    searchBackView.backgroundColor = white_color;
    UIView * searachBar = [[UIView alloc]init];
    [searchBackView addSubview:searachBar];
    [searachBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(searchBackView);
        make.centerY.mas_equalTo(searchBackView);
        make.width.mas_equalTo(Adapted(MAIN_SCREEN_WIDTH-Adapted(30)));
        make.height.mas_equalTo(Adapted(35));
    }];
    searachBar.backgroundColor = kLineColor;
    searachBar.layer.cornerRadius = Adapted(17);
    
    _textField = [[UITextField alloc]init];
    [searachBar addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, Adapted(15),0, Adapted(15)));
    }];
    _textField.clearButtonMode=UITextFieldViewModeWhileEditing;
    _textField.textColor = kTextColor;
    _textField.tintColor = kTextColor;
    _textField.placeholder = kLocalizedString(@"搜索");
    _textField.placeholderColor = kAssistTextColor;
    @weakify(self);
    _textField.didChangeBlock = ^(NSString *text) {
        @strongify(self);
        [self filterTheData:text];
    };

    self.tableView.backgroundColor = kBackGroundColor;
    [self.tableView registerClass:[ChangeCountryCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.tableHeaderView = searchBackView;
    
 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray * arr = [self mg_jsonObjWithPathForResourceAndType:@"country" type:@"json"];
        
        for (NSDictionary * dic in arr) {
            ChangeCountModel * model = [[ChangeCountModel alloc]init];
            model.zh = dic[@"zh"];
            model.en = dic[@"en"];
            model.locale = dic[@"locale"];
            model.code = [NSString stringWithFormat:@"%@",dic[@"code"]];
            model.titleString = [NSString stringWithFormat:@"%@%@%@",model.zh,model.code,model.en];
            [self.dataArray addObject:model];
        }
        
        [self handleFirstLetterArray];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    });
    

    
    
    
}

#pragma mark -- tableviewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.textField.text.length>0)
    {
        return 1;
    }
    return self.letterArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.textField.text.length>0)
    {
        return _filterData.count;
    }
    NSArray *arr = [self.nameDict valueForKey:self.letterArr[section]];
    return arr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *backView;
    if(self.textField.text.length==0)
    {
        backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(25))];
        backView.backgroundColor = white_color;
        UILabel *letterlabel = [[UILabel alloc] init];
        letterlabel.text = self.letterArr[section];
        letterlabel.font = H14;
        letterlabel.textColor = kAssistColor;
        [backView addSubview:letterlabel];
        [letterlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(backView);
            make.left.equalTo(backView).with.offset(Adapted(15));
        }];
    }

    return backView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if(self.textField.text.length>0)
    {
        ChangeCountModel * model = _filterData[indexPath.row];
        ChangeCountryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.titleLabel.text = model.zh;
        cell.areaCode.text = model.code;
        cell.subLabel.text = model.en;
       
        if([model.code isEqualToString:@"86"]){
            cell.titleLabel.textColor = kGreenColor;
            cell.areaCode.textColor = kGreenColor;
            cell.subLabel.textColor = kGreenColor;
        }else{
            cell.titleLabel.textColor = kAssistColor;
            cell.areaCode.textColor = kAssistColor;
            cell.subLabel.textColor = kAssistColor;
        }
        
        return cell;
    }else
    {
        ChangeCountModel * model = [self.nameDict valueForKey:self.letterArr[indexPath.section]][indexPath.row];
        ChangeCountryCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.titleLabel.text = model.zh;
        cell.areaCode.text = model.code;
        cell.subLabel.text = model.en;
        
        if([model.code isEqualToString:@"86"] || [model.code isEqualToString:@"852"]){
            cell.titleLabel.textColor = kGreenColor;
            cell.areaCode.textColor = kGreenColor;
            cell.subLabel.textColor = kGreenColor;
        }else{
            cell.titleLabel.textColor = kAssistColor;
            cell.areaCode.textColor = kAssistColor;
            cell.subLabel.textColor = kAssistColor;
        }
        return cell;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return Adapted(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.textField.text.length>0)
    {
        return 0.1;
    }
    return 20;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChangeCountryCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegateSignal) {

        if([cell.areaCode.text isEqualToString:@"86"] || [cell.areaCode.text isEqualToString:@"852"]){
            
            [self.delegateSignal sendNext:cell.areaCode.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            MailRegisterVC * vc = [[MailRegisterVC alloc]init];
            vc.countryCode = cell.areaCode.text;
            [self.navigationController pushViewController:vc animated:YES];
     
            [TTWHUD showCustomMsg:kLocalizedString(@"手机号注册目前只支持中国使用")];
        }
 
    } else if(self.forgetPwdSignal) {//忘记密码
     
        if([cell.areaCode.text isEqualToString:@"86"] || [cell.areaCode.text isEqualToString:@"852"]){
            
            [self.forgetPwdSignal sendNext:cell.areaCode.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            [TTWHUD showCustomMsg:kLocalizedString(@"手机号注册目前只支持中国使用")];
        }
    }
}

#pragma mark-- textFiledDelegate
//过滤数据
-(void)filterTheData:(NSString *)text{
    if(self.textField.text.length==0)
    {
        [self.tableView reloadData];
    }
    
    [_searchArr removeAllObjects];
    
    NSString *searchString = text;
    if (self.filterFirends!= nil) {
        [self.filterFirends removeAllObjects];
    }
    
    for (ChangeCountModel * model in self.dataArray)
    {
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        outputFormat.vCharType = VCharTypeWithV;
        outputFormat.caseType = CaseTypeLowercase;
        outputFormat.toneType = ToneTypeWithoutTone;
        NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:model.titleString withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        for (NSString * str in self.letterArr) {
            
            if ([[[outputPinyin substringToIndex:1] uppercaseString] isEqualToString:str])
            {
                [_searchArr addObject:model];
            }
        }
        
    }
    
    if ([PinyinHelper isIncludeChineseInString:searchString])
    {
        for (ChangeCountModel * model in self.searchArr)
        {
            if ([model.titleString containsString:searchString])
            {
                [self.filterFirends addObject:model];
                
            }
        }
    }
    else
    {
        for (ChangeCountModel * model in self.searchArr)
        {
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            outputFormat.vCharType = VCharTypeWithV;
            outputFormat.caseType = CaseTypeLowercase;
            outputFormat.toneType = ToneTypeWithoutTone;
            NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:model.titleString withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            
            if ([[outputPinyin uppercaseString] containsString:[searchString uppercaseString]])
            {
                [self.filterFirends addObject:model];
            }
        }
    }
    //过滤数据
    self.filterData = self.filterFirends;
    
    //刷新表格
    [self.tableView reloadData];
    
}

// 处理英文首字母
- (void)handleFirstLetterArray
{
    // 拿到所有的key  字母
    NSMutableDictionary *letterDict = [[NSMutableDictionary alloc] init];
    for (ChangeCountModel * model in self.dataArray) {
        HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
        outputFormat.vCharType = VCharTypeWithV;
        outputFormat.caseType = CaseTypeLowercase;
        outputFormat.toneType = ToneTypeWithoutTone;
        NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:model.titleString withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        
        [letterDict setObject:model forKey:[[outputPinyin substringToIndex:1] uppercaseString]];
    }
    // 字母数组
    self.letterArr = letterDict.allKeys;
    
    // 让key进行排序  A  -  Z
    self.letterArr = [[NSMutableArray alloc] initWithArray:[self.letterArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        // 大于上升，小于下降
        return [obj1 characterAtIndex:0] > [obj2 characterAtIndex:0];
        
    }]];
    
    // 遍历所有的排序后的key  每个Key拿到对应的数组进行组装
    for (NSString *letter in self.letterArr)
    {
        
        NSMutableArray *nameArr = [[NSMutableArray alloc] init];
        for (ChangeCountModel * model in self.dataArray) {
            HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
            outputFormat.vCharType = VCharTypeWithV;
            outputFormat.caseType = CaseTypeUppercase;
            outputFormat.toneType = ToneTypeWithoutTone;
            NSString *outputPinyin=[PinyinHelper toHanyuPinyinStringWithNSString:model.titleString withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
            if ([letter isEqualToString:[[outputPinyin substringToIndex:1] uppercaseString]])
            {
                [nameArr addObject:model];
                
            }
        }
        // 根据key装大字典
        // A -- 一批通讯人
        // B -- 一批人
        // ...
        [self.nameDict setObject:nameArr forKey:letter];
        
    }
}

#pragma mark--懒加载



- (NSMutableDictionary *)nameDict
{
    if (_nameDict == nil) {
        _nameDict = [[NSMutableDictionary alloc] init];
    }
    return _nameDict;
}

- (NSMutableArray *)filterFirends
{
    if (_filterFirends == nil) {
        _filterFirends = [[NSMutableArray alloc] init];
    }
    return _filterFirends;
    
}

-(NSMutableArray *)searchArr{
    if(!_searchArr){
        _searchArr  = [NSMutableArray new];
    }
    return _searchArr;
}

-(NSMutableArray *)filterData{
    if(!_filterData){
        _filterData  = [NSMutableArray new];
    }
    return _filterData;
}

-(NSMutableArray *)countryArray{
    if(!_countryArray){
        _countryArray = [NSMutableArray new];
     
    }
    return _countryArray;
}

-(id)mg_jsonObjWithPathForResourceAndType:(NSString *)resource type:(NSString *)type{
    
    NSError *error = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:resource ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        
        return nil;
    }
    NSArray *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error){
        
        
    }
    return jsonObj;
}


@end

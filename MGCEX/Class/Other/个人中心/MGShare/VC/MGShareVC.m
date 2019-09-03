//
//  MGShareVC.m
//  MGCEX
//
//  Created by 汪跃山 on 2018/6/29.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGShareVC.h"
#import "MGShareLinkCell.h"
#import "MGShareQRCodeCell.h"

@interface MGShareVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) MGShareVM *viewModel;

@end

@implementation MGShareVC

- (id)initWithViewModel:(MGShareVM *)viewModel
{
    if (self = [super init]){
        _viewModel = viewModel;
    }
    return self;
}

#pragma mark -- Super Method

- (void)setupSubviews
{
    self.title = self.viewModel.navTitleText;
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    [self setupLayout];
}

- (void)setupLayout
{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
}


#pragma mark -- <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        MGShareLinkCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"MGShareLinkCell"];
        if (cell == nil) {
            cell = [[MGShareLinkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MGShareLinkCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configWithViewModel:self.viewModel];
        @weakify(self);
        [cell.copyButton mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            if(self.viewModel.copylinkUrlText.length == 0)  return;
            [TTWHUD showCustomMsg:kLocalizedString(@"复制成功")];
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = self.viewModel.copylinkUrlText;
        }];
        return cell;
    } else {
        MGShareQRCodeCell * cell =  [tableView dequeueReusableCellWithIdentifier:@"MGShareQRCodeCell"];
        if (cell == nil) {
            cell = [[MGShareQRCodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MGShareQRCodeCell"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configWithViewModel:self.viewModel];
        @weakify(self);
        [cell.qrCodeButton mg_addTapBlock:^(UIButton *button) {
            @strongify(self);
            [self saveQRCode:cell.qrCodeView];
        }];
        return cell;
    }
}

//保存相片
-(void)saveQRCode:(HGDQQRCodeView *)qrCodeView
{
    
    if(!qrCodeView.qrImage)  return;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImageWriteToSavedPhotosAlbum([UIImage mg_captureView:qrCodeView], self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        });
    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (!error) {
        [TTWHUD showCustomMsg:kLocalizedString(@"保存成功")];
    }
    else {
        [TTWHUD showCustomMsg:kLocalizedString(@"保存出错")];
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *defaultView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, Adapted(6))];
    defaultView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    return defaultView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Adapted(6);
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, 0) style:UITableViewStylePlain];
        _tableView.estimatedRowHeight = Adapted(142);
        _tableView.rowHeight =UITableViewAutomaticDimension;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

@end

//
//  MGComplainImageCell.m
//  MGCEX
//
//  Created by Joblee on 2018/6/5.
//  Copyright © 2018年 MGCion. All rights reserved.
//

#import "MGComplainImageCell.h"

@implementation MGComplainImageCell

-(void)bindModel
{
    @weakify(self);
    [RACObserve(self, imageArr)subscribeNext:^(id x) {
        @strongify(self);
        float space = 10;
        float itemSize = (kScreenW-3*space-Adapted(14)*2)/4;
        NSInteger rowNumber = 1+self.imageArr.count/4;
        for (int i = 0; i<rowNumber; i++) {
            for (int j = 0; j<4; j++) {
                int num = i*(rowNumber-1)+j;
                if (num>=self.imageArr.count) {
                    break;
                }
                UIImageView *imgView = [[UIImageView alloc]init];
                [self.contentView addSubview:imgView];
                NSString *url = self.imageArr[num];
                [imgView sd_setImageWithURL:[NSURL URLWithString:url]];
                imgView.backgroundColor = kBgGrayColor;
                imgView.layer.borderWidth = 0.5;
                imgView.layer.borderColor = UIColorFromRGB(0xf1f1f1).CGColor;
                [imgView.layer masksToBounds];
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset((space+itemSize)*i+space);
                    make.left.mas_equalTo(Adapted(14)+(space+itemSize)*j);
                    make.width.height.mas_equalTo(itemSize);
                    if (i == rowNumber-1) {
                        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-space);
                    }
                }];
            }

        }

    }];
}

-(void)setUpViews
{
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.text = kLocalizedString(@"交易凭证");   
    self.titleLabel.font = [UIFont systemFontOfSize:17];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(Adapted(8));
    }];
}

@end

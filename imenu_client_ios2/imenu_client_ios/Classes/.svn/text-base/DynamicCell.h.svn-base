//
//  DynamicCell.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DynamicCellDelegate;

@interface DynamicCell : UITableViewCell

- (void)setData:(NSDictionary *)data andMemberInfo:(NSDictionary *)memberInfo;

@property (nonatomic, strong) NSDictionary *data;

@property (nonatomic, assign) BOOL isPublic;
@property (nonatomic, weak) id<DynamicCellDelegate> delegate;

@end

@protocol DynamicCellDelegate <NSObject>

- (void)onClickUser:(NSDictionary *)data;

@end

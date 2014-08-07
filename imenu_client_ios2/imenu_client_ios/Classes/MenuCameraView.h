//
//  MenuCameraView.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCameraView : UIView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

- (void)setImage:(UIImage *)image;
- (void)setData:(NSArray *)data andIndex:(NSUInteger)index withImageList:(NSArray *)imageList;

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *albumButton;
@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *doneButton;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSMutableArray *menuImageViewList;
@property (nonatomic, strong) NSMutableSet *changedIndexs;

@end

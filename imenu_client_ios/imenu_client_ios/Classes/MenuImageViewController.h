//
//  MenuImageViewController.h
//  imenu_client_ios
//
//  Created by 李亮 on 14-2-21.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuImageViewController : UIViewController

- (void)setShopData:(NSDictionary *)data withMenuName:(NSString *)name andPrice:(NSString *)price andImageUrl:(NSString *)url;

- (void)setMenudata:(NSArray *)data ofIndex:(NSUInteger)index showDynamic:(BOOL)isShow;

@end

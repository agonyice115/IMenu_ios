//
//  Common.h
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-4.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#ifndef imenu_client_ios_Common_h
#define imenu_client_ios_Common_h

/**
 *  一级字号
 */
#define FIRST_FONT_SIZE 18.0f

/**
 *  二级字号
 */
#define SECOND_FONT_SIZE 15.0f

/**
 *  三级字号
 */
#define THIRD_FONT_SIZE 12.0f

/**
 *  页边距
 */
#define PAGE_MARGIN 15.0f

/**
 *  顶部BAR高度
 */
#define TOP_BAR_HEIGHT 65.0f

/**
 *  中部BAR高度
 */
#define MIDDLE_BAR_HEIGHT 45.0f

/**
 *  底部BAR高度
 */
#define BOTTOM_BAR_HEIGHT 45.0f

/**
 *  笔记行高
 */
#define NOTE_LINE_HEIGHT 30.0f

/**
 *  @brief 图像最小尺寸
 *
 *  用于动态用户、商家头像
 */
#define IMAGE_SIZE_TINY 40.0f

/**
 *  @brief 图像小尺寸
 *
 *  用于列表中缩略图显示
 */
#define IMAGE_SIZE_SMALL 50.0f

/**
 *  @brief 图像中尺寸
 *
 *  用于用户、商家头像，菜品缩略图
 */
#define IMAGE_SIZE_MIDDLE 100.0f

/**
 *  @brief 图像大尺寸
 *
 *  用于动态、商家大图
 */
#define IMAGE_SIZE_BIG 320.0f

/**
 *  加密附加字符串
 */
#define ENCODE_STRING @"siyo_imenu"

/**
 *  @brief 图片上传压缩质量
 */
#define JPEG_QUALITY 0.8f

/**
 *  应用id
 */
#define APPID @"850328595"

/**
 *  官网
 */
#define IMENU_GUAN_WANG @"http://www.imenu.so"

/**
 *  服务条款
 */
#define IMENU_FU_WU @"http://www.baidu.com"

/**
 *  官方微信
 */
#define IMENU_WEI_XIN @"http://weixin.qq.com/r/k3VfRwXEX1ggrUEk9yCB"

/**
 *  导航栏类型定义
 */
typedef enum
{
    IM_NAVIGATION_BAR_TYPE_UNLOGIN = 0,         // 未登录
    IM_NAVIGATION_BAR_TYPE_UNLOGIN_SECONDARY,   // 未登录二级
    IM_NAVIGATION_BAR_TYPE_SWITCH,              // 切换
    IM_NAVIGATION_BAR_TYPE_SHARE,               // 分享
    IM_NAVIGATION_BAR_TYPE_TITLE,               // 标题
    IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE,    // 标题+分享
    IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SEARCH,   // 标题+搜索
    
    IM_NAVIGATION_BAR_TYPE_SHOP = 100,      // 商家
    IM_NAVIGATION_BAR_TYPE_MINE = 200,      // 我的
    IM_NAVIGATION_BAR_TYPE_DYNIMIC = 300,   // 动态
    IM_NAVIGATION_BAR_TYPE_SERCH = 400,     // 搜索
    
    IM_NAVIGATION_BAR_TYPE_NONE
} IM_NAVIGATION_BAR_TYPE;

/**
 *  导航栏项ID定义
 */
typedef enum
{
    IM_NAVIGATION_ITEM_LOGIN = 1,           // 登录
    IM_NAVIGATION_ITEM_REGISTER,            // 注册
    
    IM_NAVIGATION_ITEM_SHOP,                // 商家
    IM_NAVIGATION_ITEM_MINE,                // 我的
    IM_NAVIGATION_ITEM_DYNIMIC,             // 动态
    IM_NAVIGATION_ITEM_SERCH,               // 搜索
    
    IM_NAVIGATION_ITEM_SWITCH,              // 切换
    IM_NAVIGATION_ITEM_SWITCH_SHOP,         // 切换到商家
    IM_NAVIGATION_ITEM_SWITCH_MINE,         // 切换到我的
    IM_NAVIGATION_ITEM_SWITCH_DYNIMIC,      // 切换到动态
    IM_NAVIGATION_ITEM_SWITCH_SERCH,        // 切换到搜索
    
    IM_NAVIGATION_ITEM_SHARE,               // 分享
    IM_NAVIGATION_ITEM_SHARE_WECHAT,        // 分享到微信
    IM_NAVIGATION_ITEM_SHARE_FRIENDS,       // 分享到微信朋友圈
    IM_NAVIGATION_ITEM_SHARE_SINA,          // 分享到新浪微博
    IM_NAVIGATION_ITEM_SHARE_RENREN,        // 分享到人人
    
    IM_NAVIGATION_ITEM_BACK,                // 返回
    IM_NAVIGATION_ITEM_CLOSE,               // 关闭
    IM_NAVIGATION_ITEM_MAP,                 // 地图
    IM_NAVIGATION_ITEM_TITLE,               // 标题
    IM_NAVIGATION_ITEM_SEARCH_MENU,         // 查找菜单
    
    IM_NAVIGATION_ITEM_NONE
} IM_NAVIGATION_ITEM_ID;

#endif

//
//  BannerView.h
//  JianKangTong
//
//  Created by 韩小东 on 15/11/10.
//  Copyright © 2015年 JKT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopImage.h"

typedef NS_ENUM(NSInteger, branchTag) {
    branchTag_yang = 1,
    branchTag_huang
};

@protocol LoopImgViewDelegate <NSObject>

-(void)clickBannerWithIndex:(LoopImage *)imgLoop;

@end




@interface LoopImgView : UIView
/**
 * 轮播时间间隔
 */
@property (nonatomic,assign)    int inactiveTime;

@property (nonatomic,assign)    id<LoopImgViewDelegate>delegate;

-(void)setBanners:(NSArray<LoopImage *> *)banners;
@property (nonatomic,assign)    branchTag   branchtag;

@end

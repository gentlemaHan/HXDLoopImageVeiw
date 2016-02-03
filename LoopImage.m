//
//  LoopImage.m
//  PalmHospitalShangHaiHongFangZi
//
//  Created by 韩小东 on 16/2/3.
//  Copyright © 2016年 lvxian. All rights reserved.
//

#import "LoopImage.h"

static NSString *   const articleTitle = @"title";
static NSString *   const imageUrl     = @"picture";
static NSString *   const articleUrl   = @"url";

@implementation LoopImage

-(id)initWithDict:(NSDictionary *)dict{
    if (self = [super init]) {
        if ([dict objectForKey:articleTitle]) {
            self.articleTitle = [dict objectForKey:articleTitle];
        }
        if ([dict objectForKey:imageUrl]) {
            self.imgUrl = [dict objectForKey:imageUrl];
        }
        if ([dict objectForKey:articleUrl]) {
            self.articleUrl = [dict objectForKey:articleUrl];
        }
    }
    return self;
}

@end

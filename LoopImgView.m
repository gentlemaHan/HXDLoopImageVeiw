//
//  BannerView.m
//  JianKangTong
//
//  Created by 韩小东 on 15/11/10.
//  Copyright © 2015年 JKT. All rights reserved.
//

#import "LoopImgView.h"
#import "UIImageView+AFNetworking.h"

@interface LoopImgView ()<UIScrollViewDelegate>

@property (nonatomic,strong)    UIScrollView    *scrollView;
@property (nonatomic,strong)    UIPageControl   *pagecontrol;
@property (nonatomic,strong)    NSTimer         *bannerTimer;
@property (nonatomic,strong)    NSArray         *bannerArr;
@property (nonatomic,strong)    UIView          *bottomView;

@end



@implementation LoopImgView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addNotification];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        [self addNotification];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotobackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(becomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

-(void)gotobackground{
    if (self.bannerTimer) {
        [self.bannerTimer invalidate];
        self.bannerTimer = nil;
    }
}

-(void)becomeActive{
    if (self.bannerArr && self.bannerArr.count > 1 && !self.bannerTimer) {
        self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:self.inactiveTime>1?self.inactiveTime:3 target:self selector:@selector(scrollBanner) userInfo:nil repeats:YES];
    }
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-21, self.frame.size.width, 21)];
        _bottomView.backgroundColor = [UIColor blackColor];
        _bottomView.alpha = 0.7;
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(UIPageControl *)pagecontrol{
    if (!_pagecontrol) {
        _pagecontrol = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bottomView.frame.size.width-110, 3, 100, 15)];
        _pagecontrol.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pagecontrol.currentPageIndicatorTintColor = [UIColor redColor];
        _pagecontrol.hidesForSinglePage = YES;
        [self.bottomView addSubview:_pagecontrol];
    }
    return _pagecontrol;
}

#pragma mark -

- (void)drawRect:(CGRect)rect{
    self.scrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.bottomView.frame = CGRectMake(0, rect.size.height-21, rect.size.width, 21);
}

-(void)setBanners:(NSArray<LoopImage *> *)banners{
    if (self.bannerTimer) {
        [self.bannerTimer invalidate];
        self.bannerTimer = nil;
    }
    if (!banners || ![banners isKindOfClass:[NSArray class]] || banners.count == 0) {
        UIImage *image = [UIImage imageNamed:@"banner.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleToFill;
        [self.scrollView addSubview:imageView];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height);
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.pagecontrol.numberOfPages = 1;
        CGSize size = [self.pagecontrol sizeForNumberOfPages:1];
        self.pagecontrol.frame = CGRectMake(self.bottomView.frame.size.width-size.width-10, 3, size.width, 15);
        return;
    }
    
    self.bannerArr = banners;
    if (banners.count>1) {
        //轮播
        NSMutableArray *tempArr = [NSMutableArray arrayWithArray:banners];
        LoopImage *first = banners.firstObject;
        LoopImage *last = banners.lastObject;
        [tempArr insertObject:last atIndex:0];
        [tempArr addObject:first];
        
        [self addBannerImageView:tempArr];
        self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
        self.pagecontrol.currentPage = 0;
        if (!self.bannerTimer) {
            self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:self.inactiveTime>1?self.inactiveTime:3 target:self selector:@selector(scrollBanner) userInfo:nil repeats:YES];
        }
    }else{
        //不轮播
        [self addBannerImageView:banners];
        self.scrollView.contentOffset = CGPointMake(0, 0);
    }
    self.pagecontrol.numberOfPages = banners.count;
    CGSize size = [self.pagecontrol sizeForNumberOfPages:banners.count];
    self.pagecontrol.frame = CGRectMake(self.bottomView.frame.size.width-size.width-10, 3, size.width, 15);
}

-(void)addBannerImageView:(NSArray *)banners;{
    for (int i=0;i<banners.count;i++) {
        LoopImage *banner = [banners objectAtIndex:i];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageview.contentMode = UIViewContentModeScaleAspectFill;
        [imageview setImageWithURL:[NSURL URLWithString:banner.imgUrl] placeholderImage:[UIImage imageNamed:@"banner"]];
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, imageview.frame.size.width, imageview.frame.size.height)];
        
        control.tag = i+100;
        control.backgroundColor = [UIColor clearColor];
        [control addTarget:self action:@selector(bannerClick:) forControlEvents:UIControlEventTouchUpInside];
        [imageview addSubview:control];
        imageview.userInteractionEnabled = YES;
        
        [self.scrollView addSubview:imageview];
    }
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*banners.count,self.scrollView.frame.size.height);
}

#pragma mark -

-(void)scrollBanner{
    if (self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isTracking) {
        return;
    }
    CGPoint currentContentOffset = self.scrollView.contentOffset;
    CGPoint contentOffset = CGPointMake(currentContentOffset.x+self.scrollView.frame.size.width, 0);
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

-(void)bannerClick:(UIControl *)control{
    if (self.scrollView.isDragging || self.scrollView.isDecelerating || self.scrollView.isTracking) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(clickBannerWithIndex:)]) {
        LoopImage *imgLoop = [self.bannerArr objectAtIndex:self.pagecontrol.currentPage];
        [self.delegate clickBannerWithIndex:imgLoop];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self doWithScrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self doWithScrollView];
}

-(void)doWithScrollView{
    CGPoint offset = self.scrollView.contentOffset;
    CGFloat x = offset.x;
    
    if (x < self.scrollView.frame.size.width) {
        x = self.scrollView.frame.size.width * (self.bannerArr.count);
        [self.scrollView setContentOffset:CGPointMake(x, offset.y) animated:NO];
        
    }else if (x > (self.bannerArr.count)*self.scrollView.frame.size.width){
        x = self.scrollView.frame.size.width;
        [self.scrollView setContentOffset:CGPointMake(x, offset.y) animated:NO];
    }else{
        int b = (int)x % (int)self.scrollView.frame.size.width;
        int c = (int)x / (int)self.scrollView.frame.size.width;
        if (b>(self.scrollView.frame.size.width/2)) {
            x = (c+1)*self.scrollView.frame.size.width;
        }else{
            x = c*self.scrollView.frame.size.width;
        }
        [self.scrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    }
    
    CGFloat wid = self.scrollView.frame.size.width;
    int d = x / wid;
    self.pagecontrol.currentPage = d-1;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    NSLog(@"+++++");
    if (self.bannerTimer) {
        [self.bannerTimer invalidate];
        self.bannerTimer = nil;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    NSLog(@"----");
    if (!self.bannerTimer) {
        self.bannerTimer = [NSTimer scheduledTimerWithTimeInterval:self.inactiveTime>1?self.inactiveTime:3 target:self selector:@selector(scrollBanner) userInfo:nil repeats:YES];
    }
}

@end

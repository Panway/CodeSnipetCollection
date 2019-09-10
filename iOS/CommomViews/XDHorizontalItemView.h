//
//  HorizontalItemView.h
//  QiYun
//
//  Created by Panway on 15/12/22.
//  Copyright © 2015年 Panway. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *kHorizontalItemView = @"kHorizontalItemView";
@class XDPWCollectionViewCell;
@protocol GBHorizontalItemViewDelegate<NSObject>
@optional
- (void)didSelectItemAtIndex:(NSInteger)index withData:(id)dataModel;

@end

/// 水平方向的一排View
@interface XDHorizontalItemView : UIView

@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, weak) id <GBHorizontalItemViewDelegate> delegate;
/// 数据源（里面放Model）
@property (nonatomic, strong) NSArray *dataSource;

/// 是否开启分页
@property(nonatomic) BOOL pagingEnabled;
/// 是否打开ScrollView的bounces属性
@property(nonatomic) BOOL bounces;
// 设置最大选择数量
@property(nonatomic) NSInteger maxSelectItemCount;
/// 屏幕中最多显示几个Item,默认是4
@property(nonatomic) NSInteger maxItemCountInScreen;
/// Item宽度（设置了这个就不用再设置maxItemCountInScreen了 ）
@property(nonatomic) NSInteger itemWidth;
/// 某个特殊Item单独设置宽度,比如最后一个Item（Cell）宽度设成100
@property(nonatomic) NSInteger specialItemWidth;
@property(nonatomic) NSInteger specialItemIndex;

/// Item高度（垂直方向排列时）
@property(nonatomic) NSInteger itemHeight;

/// collectionView宽度
@property(nonatomic) CGFloat collectionViewWidth;


/*!
 * @brief 为了自定义CollectionViewCell与自己解耦
 * @code [[self.itemsView setRegisterCellClass:^{
 [weakself.itemsView.collectionView registerClass:[GBXXXCollectionViewCell class] forCellWithReuseIdentifier:kHorizontalItemView];
 }];];
 */
@property (nonatomic, copy) void(^registerCellClass)(void);
/// 刷新
- (void)reloadDataSource;

/// 选中某Item的回调block
@property (nonatomic, copy) void(^didSelectItemAtIndexHandler)(NSInteger index);

/// 当达到maxSelectItemCount回调block
@property (nonatomic, copy) void(^showMaxmessage)(NSString *maxstring);

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)scrollDirection;
@end


@interface XDPWCollectionViewCell : UICollectionViewCell
- (void)initSubviews;
/// 根据model更新界面，留给子类实现
- (void)updateUIWithData:(id)model;
@end



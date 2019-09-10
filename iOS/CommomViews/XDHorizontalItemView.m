//
//  HorizontalItemView.m
//  QiYun
//
//  Created by Panway on 15/12/22.
//  Copyright © 2015年 Panway. All rights reserved.
//

#define PPScreenWidth [[UIScreen mainScreen] bounds].size.width
#define PPScreenHeight [[UIScreen mainScreen] bounds].size.height


#import "XDHorizontalItemView.h"

@interface XDHorizontalItemView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) BOOL cellDidRegister;

@end

@implementation XDHorizontalItemView
- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame scrollDirection:UICollectionViewScrollDirectionHorizontal];
}

- (instancetype)initWithFrame:(CGRect)frame scrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *titleFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.scrollDirection = scrollDirection;
        titleFlowLayout.scrollDirection = scrollDirection;
        titleFlowLayout.minimumLineSpacing = 0;
        titleFlowLayout.minimumInteritemSpacing = 0;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:titleFlowLayout];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.collectionView];
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.scrollsToTop = NO;
        
        self.itemWidth = 0;
        self.specialItemIndex = -1;
        _cellDidRegister = NO;
    }
    return self;
}

- (void)setPagingEnabled:(BOOL)pagingEnabled {
    _pagingEnabled = pagingEnabled;
    self.collectionView.pagingEnabled = pagingEnabled;
}

- (void)setBounces:(BOOL)bounces {
    self.collectionView.bounces = bounces;
}

- (void)reloadDataSource {
    NSAssert(self.registerCellClass != nil, @"Cell must be registered for identifier - %@", kHorizontalItemView);
    if (_registerCellClass && !_cellDidRegister) {
        _cellDidRegister = YES;
        _registerCellClass();
    }
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XDPWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kHorizontalItemView forIndexPath:indexPath];
    [cell updateUIWithData:self.dataSource[indexPath.item]];
    
    // 如果想与XDPWCollectionViewCell完全解耦可以使用_cellForItemAtIndexPath：
//    if (_cellForItemAtIndexPath) {
//        _cellForItemAtIndexPath(collectionView,cell,indexPath);
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /// 回调和Block选其一
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtIndex:withData:)]) {
        [self.delegate didSelectItemAtIndex:indexPath.item withData:[self.dataSource objectAtIndex:indexPath.item]];
    }
    else {
        if (_didSelectItemAtIndexHandler) {
            
            _didSelectItemAtIndexHandler(indexPath.item);
        }
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array =collectionView.indexPathsForSelectedItems;
    
    if (self.maxSelectItemCount==0&&array.count==0) {
        
        return YES;
    }else if(array.count==self.maxSelectItemCount){

        if (_showMaxmessage) {
                
            _showMaxmessage([NSString stringWithFormat:@"不能太贪心，最多只能选择%ld个哦",self.maxSelectItemCount]);
        }
//        }
        return NO;
     
    
    }else{
        
        return YES;
    }
}
#pragma mark - UICollectionViewDelegateFlowLayout
//每个Cell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.collectionViewWidth < 1) {
        self.collectionViewWidth = PPScreenWidth;
    }
    NSAssert((self.maxItemCountInScreen>0||self.itemWidth > 0), @"设置完maxItemCountInScreen或者itemWidth才能reloadDataSource");
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if (self.itemWidth > 0) {
            if(self.specialItemIndex == indexPath.item) {
                return CGSizeMake(self.specialItemWidth, self.frame.size.height);
            }
            return CGSizeMake(self.itemWidth, self.frame.size.height);
        }
        return CGSizeMake(self.collectionViewWidth/self.maxItemCountInScreen, self.frame.size.height);
    }
    return CGSizeMake(self.collectionViewWidth/self.maxItemCountInScreen, self.itemHeight);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    return 0;
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}
@end


@implementation XDPWCollectionViewCell
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews {
    
}
- (void)updateUIWithData:(id)model {
}
@end

//
//  GBPhotoGroupView.h
//  Taoguba App Client
//
//  Created by Panwei on 16/9/22.
//  Copyright © 2016年 taoguba. All rights reserved.
//

#import <UIKit/UIKit.h>






/// Single picture's info.
@interface GBPhotoGroupItem : NSObject
@property (nonatomic, strong) UIView *thumbView; ///< thumb image, used for animation position calculation
@property (nonatomic, assign) CGSize largeImageSize;
@property (nonatomic, strong) NSURL *largeImageURL;
@end

@class YYPhotoGroupCell;
@protocol PPPhotoGroupCellDelegate <NSObject>
@optional
- (void)loadImage:(NSString *)imageURL inCell:(YYPhotoGroupCell *) cell;


@end

@interface YYPhotoGroupCell : UIScrollView <UIScrollViewDelegate>
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) BOOL showProgress;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) GBPhotoGroupItem *item;
@property (nonatomic, readonly) BOOL itemDidLoad;
- (void)resizeSubviewSize;

@property (nonatomic, weak)id<PPPhotoGroupCellDelegate> _Nullable delegate;

@end





/// Used to show a group of images.
/// One-shot.
@interface GBPhotoGroupView : UIView

/**
 *  < thumb image, used for animation position calculation
 */
@property (nonatomic, readonly) NSArray *groupItems; ///< Array<YYPhotoGroupItem>
@property (nonatomic, readonly) NSInteger currentPage;
@property (nonatomic, assign) BOOL blurEffectBackground; ///< Default is YES


- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithGroupItems:(NSArray *)groupItems;
@property (nonatomic) NSInteger selectedIndex;///<自己新加的，为了方便取WebView传过来的点击index

- (void)presentFromImageView:(UIView *)fromView
                 toContainer:(UIView *)container
                    animated:(BOOL)animated
                  completion:(void (^)(void))completion;

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismiss;
- (YYPhotoGroupCell *)cellForPage:(NSInteger)page;
@property (nonatomic, weak)id<PPPhotoGroupCellDelegate> _Nullable delegate;

@end


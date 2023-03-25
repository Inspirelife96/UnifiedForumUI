//
//  UFUIPickedImageCell.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol UFUIPickedImageCellDelegate <NSObject>

- (void)deleteSelectedPhotoCell:(NSIndexPath *)indexPath;

@end

@interface UFUIPickedImageCell : UICollectionViewCell

//@property (nonatomic, strong) id asset;

@property (nonatomic, weak) id<UFUIPickedImageCellDelegate> delegate;

- (void)configWithImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END

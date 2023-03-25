//
//  UFUITagsCell.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import <UIKit/UIKit.h>

@class JCTagListView;

NS_ASSUME_NONNULL_BEGIN

@interface UFUITagsCell : UITableViewCell

@property (nonatomic, strong) JCTagListView *tagView;

- (void)configCellWithTags:(NSArray *)tags selectedTags:(NSArray *)selectedTags;

@end

NS_ASSUME_NONNULL_END

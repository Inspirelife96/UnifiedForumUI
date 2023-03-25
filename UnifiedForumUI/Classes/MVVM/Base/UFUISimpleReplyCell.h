//
//  UFUISimpleReplyCell.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class UFUISimpleReplyCellViewModel;

@interface UFUISimpleReplyCell : UITableViewCell

@property (nonatomic, strong) UILabel *replyLabel;

@property (nonatomic, strong) UFUISimpleReplyCellViewModel *simpleReplyCellVM;

- (void)configWithSimpleReplyCellViewModel:(UFUISimpleReplyCellViewModel *)simpleReplyCellVM;

@end

NS_ASSUME_NONNULL_END

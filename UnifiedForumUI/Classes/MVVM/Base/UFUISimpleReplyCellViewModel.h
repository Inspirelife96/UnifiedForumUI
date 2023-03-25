//
//  UFUISimpleReplyCellViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2022/2/25.
//

#import <Foundation/Foundation.h>

@class UFMReplyModel;

NS_ASSUME_NONNULL_BEGIN

@interface UFUISimpleReplyCellViewModel : NSObject

@property (nonatomic, strong) UFMReplyModel *replyModel;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, copy) NSAttributedString *attributedText;

- (instancetype)initWithReplyModel:(UFMReplyModel *)replyModel;

@end

NS_ASSUME_NONNULL_END

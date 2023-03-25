//
//  UFUITopicQueryViewModel.h
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/27.
//

#import "UFUIQueryViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UFUITopicQueryViewModel : UFUIQueryViewModel

- (instancetype)initQueryTopicWithOrderBy:(NSString *)orderBy;

- (instancetype)initQueryTopicWithCategory:(NSString *)category;

- (instancetype)initQueryTopicWithTag:(NSString *)tag;

- (instancetype)initQueryTopicWithFollowedByUser:(UFMUserModel *)userModel;

- (instancetype)initQueryTopicWithCreatedByUserModel:(UFMUserModel *)userModel;

@end

NS_ASSUME_NONNULL_END

//
//  UFUITimeLineLikeTopicCellViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/21.
//

#import "UFUITimeLineLikeTopicCellViewModel.h"

#import "UFUITimeLineLikeTopicCell.h"

#import "UFUIConstants.h"

@implementation UFUITimeLineLikeTopicCellViewModel

- (instancetype)initWithObjectModel:(UFMObjectModel *)objectModel {
    if (self = [super initWithObjectModel:objectModel]) {
        self.cellIdentifier = NSStringFromClass([UFUITimeLineLikeTopicCell class]);
        
        if ([objectModel isKindOfClass:[UFMTimeLineModel class]]) {
            self.timeLineModel = (UFMTimeLineModel *)objectModel;
            
            // 从数据模型中获取fromUserAvatarUrlString
            if (self.timeLineModel.fromUserModel.avatarImageModel) {
                self.fromUserAvatarUrlString = self.timeLineModel.fromUserModel.avatarImageModel.url;
            } else {
                self.fromUserAvatarUrlString = nil;
            }

            // XXX 赞了文章
            self.title = [NSString stringWithFormat:@"%@ %@", self.timeLineModel.fromUserModel.username, KUFUILocalization(@"赞了文章")];
            
            // 生成标准的发布时间
            self.timeInfo = [self.timeLineModel.createdAt jk_timeInfo];
            
            // Post的具体内容
            self.topicTitle = self.timeLineModel.topicModel.title;
            self.topicContent = self.timeLineModel.topicModel.content;
            self.topicFromUserName = self.timeLineModel.topicModel.fromUserModel.username;
            self.topicPostInfo = [NSString stringWithFormat:@"%ld", self.timeLineModel.topicModel.postCount];
            self.topicLikeInfo = [NSString stringWithFormat:@"%ld", self.timeLineModel.topicModel.likeCount];
        }
    }
    
    return self;
}

@end

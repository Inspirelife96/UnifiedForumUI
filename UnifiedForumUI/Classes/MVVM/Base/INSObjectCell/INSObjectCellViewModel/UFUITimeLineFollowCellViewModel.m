//
//  UFUITimeLineFollowCellViewModel.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/23.
//

#import "UFUITimeLineFollowCellViewModel.h"

#import "UFUITimeLineFollowCell.h"

#import "UFUITimeLineHeaderViewModel.h"

#import "UFUIConstants.h"

@implementation UFUITimeLineFollowCellViewModel

- (instancetype)initWithObjectModel:(UFMObjectModel *)objectModel {
    if (self = [super initWithObjectModel:objectModel]) {
        self.cellIdentifier = NSStringFromClass([UFUITimeLineFollowCell class]);
        
        if ([objectModel isKindOfClass:[UFMTimeLineModel class]]) {
            self.timeLineModel = (UFMTimeLineModel *)objectModel;
            
            // 从数据模型中获取fromUserAvatarUrlString
            if (self.timeLineModel.fromUserModel.avatarImageModel) {
                self.timeLineHeaderVM.avatarUrlString = self.timeLineModel.fromUserModel.avatarImageModel.url;
            } else {
                self.timeLineHeaderVM.avatarUrlString = nil;
            }

            // XXX 赞了文章
            self.timeLineHeaderVM.title = [NSString stringWithFormat:@"%@ %@", self.timeLineModel.fromUserModel.username, KUFUILocalization(@"关注了作者")];
            
            // 生成标准的发布时间
            self.timeLineHeaderVM.timeInfo = [self.timeLineModel.createdAt jk_timeInfo];
            
            // 具体关注的作者的信息
            UFMUserModel *followedUserModel = self.timeLineModel.toUserModel;
            self.avatarUrlString = followedUserModel.avatarImageModel.url;
            self.userName = followedUserModel.username;
            self.userInfo = [NSString stringWithFormat:@"发布了%ld文章， 收获了%ld个赞", followedUserModel.topicCount, followedUserModel.likedCount];;
            self.userBio = followedUserModel.bio;
            
            if ([UFMService currentUserModel] && [followedUserModel isFollowedByUserModel:[UFMService currentUserModel]]) {
                self.followStatusButtonTitle = @"已关注";
            } else {
                self.followStatusButtonTitle = @"关注";
            }
        }
    }
    
    return self;
}

@end

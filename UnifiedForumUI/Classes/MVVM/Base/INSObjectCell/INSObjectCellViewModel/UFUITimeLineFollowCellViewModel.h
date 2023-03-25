//
//  UFUITimeLineFollowCellViewModel.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/23.
//

#import "UFUITimeLineCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UFUITimeLineFollowCellViewModel : UFUITimeLineCellViewModel

@property (nonatomic, strong) NSString *avatarUrlString;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userInfo;
@property (nonatomic, strong) NSString *userBio;
@property (nonatomic, strong) NSString *followStatusButtonTitle;

@end

NS_ASSUME_NONNULL_END

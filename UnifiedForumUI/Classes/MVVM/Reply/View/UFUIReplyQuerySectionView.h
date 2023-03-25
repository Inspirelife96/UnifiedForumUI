//
//  UFUIReplyQuerySectionView.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UFUIReplyQuerySectionView : UIView

@property (nonatomic, strong) UILabel *sectionDescriptionLabel;

// 展示类似“XXX条评论”的内容
// 比较简单就不再由ViewModel来配置了
- (void)configWithSectionDescription:(NSString *)sectionDescription;

@end

NS_ASSUME_NONNULL_END

//
//  UFUIUserProfileEditDetailBioCell.h
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2021/10/25.
//

#import <UIKit/UIKit.h>

@class UFUIUserProfileEditDetailBioCell;
@class UFUIAutoHeightTextView;
@class UFUIUserProfileEditViewModel;

NS_ASSUME_NONNULL_BEGIN


@protocol UFUIUserProfileEditDetailBioCellDelegate <NSObject>

@optional

/*
 如果外部实现了textView.heightDidChangeBlock，那么这个协议是不会执行的(因为这个block是在cell创建时候赋值的)，textView的block就不要在外部调用了，切记……
 不管外部实现 textView.heightDidChangeBlock 还是调用了这个协议方法，都需要调用tableview的如下两个方法，连着调用即可
    [tableView beginUpdates];
    [tableView endUpdates];
*/
-(void)textViewCell:(UFUIUserProfileEditDetailBioCell*)cell textHeightChange:(CGFloat)texHeight;

-(void)textViewCell:(UFUIUserProfileEditDetailBioCell*)cell textChange:(NSString*)text;

@end

@interface UFUIUserProfileEditDetailBioCell : UITableViewCell <UITextViewDelegate>

/** 代理 */
@property (nonatomic, weak) id<UFUIUserProfileEditDetailBioCellDelegate> delegate;

/** 输入状态下  最大字符数限制 */
@property (nonatomic) NSInteger maxNumberWords;

@property (strong, nonatomic) UFUIAutoHeightTextView *bioTextView;
@property (strong, nonatomic) UILabel *textNumberLabel;

- (void)configWithUserProfileEditViewModel:(UFUIUserProfileEditViewModel *)userProfileEditVM;

@end

NS_ASSUME_NONNULL_END

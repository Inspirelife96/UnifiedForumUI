//
//  UFUISettingViewController.m
//  Bolts
//
//  Created by XueFeng Chen on 2021/10/29.
//

#import "UFUISettingViewController.h"

#import "UFUIConstants.h"

#import "UFUISettingTextCell.h"
#import "UFUISettingLogoutCell.h"
#import "UFUISettingTextSwitchCell.h"

#import "UFMUserModel.h"

@interface UFUISettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//@property (nonatomic, strong) UFUISettingTextCell *userInfoCell; // section 1

@property (nonatomic, strong) UFUISettingTextSwitchCell *darkModeCell; // section 0

@property (nonatomic, strong) UFUISettingTextCell *IAPCell; // section 1

@property (nonatomic, strong) UFUISettingTextCell *helpCell; // section 2
@property (nonatomic, strong) UFUISettingTextCell *topicbackCell;
@property (nonatomic, strong) UFUISettingTextCell *shareCell;

@property (nonatomic, strong) UFUISettingTextCell *aboutCell; // section 3

@property (nonatomic, strong) UFUISettingLogoutCell *logoutCell; // section 4

@property (nonatomic, strong) NSArray *cellArray;

@property (nonatomic, strong) UFMUserModel *userModel;

@end

@implementation UFUISettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
//    [self updateUserInfo];
}

- (UIScrollView *)tabContentScrollView {
   return self.tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.cellArray[section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellArray[indexPath.section][indexPath.row];
}

- (NSArray *)cellArray {
    if ([UFMService currentUserModel]) {
        return @[
//            @[self.darkModeCell],
            @[self.IAPCell],
            @[self.helpCell, self.topicbackCell, self.shareCell],
            @[self.aboutCell],
            @[self.logoutCell]
        ];
    } else {
        return @[
//            @[self.darkModeCell],
            @[self.IAPCell],
            @[self.helpCell, self.topicbackCell, self.shareCell],
            @[self.aboutCell]
        ];
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 100;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        //_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        
//        _tableView.theme_backgroundColor = [ThemeColorPicker pickerWithKeyPath:@"UITableView.backgroundColor"];
    }
    
    return _tableView;
}

//- (void)updateUserInfo {
//    UIImage *defaultProfileImage = [INSParseUIBundle imageNamed:@"user_profile_icon_default"];
//    if ([PFUser currentUser]) {
//        self.userInfoCell.textLabel.text = [PFUser currentUser].username;
//
//        NSString *signatureString = [[PFUser currentUser] objectForKey:@"signature"];
//
//        if (signatureString && ![signatureString isEqualToString:@""]) {
//            self.userInfoCell.detailTextLabel.text = signatureString;
//        } else {
//            self.userInfoCell.detailTextLabel.text = KINSParseLanguage(@"UFUISettingViewController.userInfoCell.subtitle.default");
//        }
//
//        PFFileObject *profileImageFile = [[PFUser currentUser] objectForKey:@"profileImage"];
//        if (profileImageFile) {
//            NSURL *profileImageUrl = [NSURL URLWithString:profileImageFile.url];
//            [self.userInfoCell.imageView sd_setImageWithURL:profileImageUrl placeholderImage:defaultProfileImage];
//        } else {
//            self.userInfoCell.imageView.image = defaultProfileImage;
//        }
//    } else {
//        self.userInfoCell.textLabel.text = KINSParseLanguage(@"UFUISettingViewController.userInfoCell.title.for.not.login");
//        self.userInfoCell.detailTextLabel.text = KINSParseLanguage(@"UFUISettingViewController.userInfoCell.subtitle.for.not.login");
//        self.userInfoCell.imageView.image = defaultProfileImage;
//    }
//}

//- (UFUISettingTextCell *)userInfoCell {
//    if (!_userInfoCell) {
//        _userInfoCell = [[UFUISettingTextCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UFUISettingTextCell"];
//        _userInfoCell.imageView.layer.cornerRadius = 22.0f;
//        _userInfoCell.imageView.layer.masksToBounds = YES;
//    }
//    
//    return _userInfoCell;
//}

//- (UFUISettingTextSwitchCell *)darkModeCell {
//    if (!_darkModeCell) {
//        _darkModeCell = [[UFUISettingTextSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UFUISettingTextSwitchCell"];
//        _darkModeCell.textLabel.text = KINSParseLanguage(@"Dark Mode");
//        _darkModeCell.delegate = self;
//    }
//
//    return _darkModeCell;
//}

- (UFUISettingTextCell *)IAPCell {
    if (!_IAPCell) {
        _IAPCell = [[UFUISettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UFUISettingTextCell"];
        _IAPCell.textLabel.text = KUFUILocalization(@"IAP");
    }
    
    return _IAPCell;
}

- (UFUISettingTextCell *)helpCell {
    if (!_helpCell) {
        _helpCell = [[UFUISettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UFUISettingTextCell"];
        _helpCell.textLabel.text = KUFUILocalization(@"Help");
    }
    
    return _helpCell;
}

- (UFUISettingTextCell *)topicbackCell {
    if (!_topicbackCell) {
        _topicbackCell = [[UFUISettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UFUISettingTextCell"];
        _topicbackCell.textLabel.text = KUFUILocalization(@"Topicback");
    }
    
    return _topicbackCell;
}

- (UFUISettingTextCell *)shareCell {
    if (!_shareCell) {
        _shareCell = [[UFUISettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UFUISettingTextCell"];
        _shareCell.textLabel.text = KUFUILocalization(@"Share");
    }
    
    return _shareCell;
}

- (UFUISettingTextCell *)aboutCell {
    if (!_aboutCell) {
        _aboutCell = [[UFUISettingTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UFUISettingTextCell"];
        _aboutCell.textLabel.text = KUFUILocalization(@"About");
    }
    
    return _aboutCell;
}

- (UFUISettingLogoutCell *)logoutCell {
    if (!_logoutCell) {
        _logoutCell = [[UFUISettingLogoutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UFUISettingLogoutCell"];
        _logoutCell.textLabel.text = KUFUILocalization(@"Logout");
    }
    
    return _logoutCell;
}


@end

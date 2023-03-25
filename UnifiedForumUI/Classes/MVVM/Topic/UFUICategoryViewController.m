//
//  UFUICategoryViewController.m
//  UnifiedForumUI
//
//  Created by XueFeng Chen on 2023/3/4.
//

#import "UFUICategoryViewController.h"

#import "UFUIConstants.h"

@interface UFUICategoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *categoryArray;

@property (nonatomic, strong) NSString *selectedCategory;

@property (nonatomic, copy) FinishSelectingCategoryHandle handle;

@end

@implementation UFUICategoryViewController

- (instancetype)initWithSelectedCategory:(NSString *)selectedCategory didFinishSelectingCategoryHandle:(FinishSelectingCategoryHandle)handle {
    if (self = [super init]) {
        self.selectedCategory = selectedCategory;
        self.handle = handle;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.confirmButton];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryCell" forIndexPath:indexPath];

    NSString *currentCategory = self.categoryArray[indexPath.row];
    
    cell.textLabel.text = currentCategory;

    if ([self.selectedCategory isEqualToString:currentCategory]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedCategory = self.categoryArray[indexPath.row];
    self.handle(self.selectedCategory);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIAction

//- (void)clickCloseButton:(UIButton *)sender {
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)clickConfirmButton:(UIButton *)sender {
//    self.handle(self.selectedCategory);
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark Getter/Setter

//- (UIButton *)closeButton {
//    if (!_closeButton) {
//        _closeButton = [[UIButton alloc] init];
//        [_closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
//        [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//    return _closeButton;
//}
//
//- (UIButton *)confirmButton {
//    if (!_confirmButton) {
//        _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 24.0f)];
//        _confirmButton.backgroundColor = [UIColor linkColor];
//
//        [_confirmButton setTitleColor:[UIColor systemBackgroundColor] forState:UIControlStateNormal];
//        [_confirmButton setTitleColor:[UIColor secondarySystemBackgroundColor] forState:UIControlStateDisabled];
//        [_confirmButton setEnabled:NO];
//
//        [_confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
//
//        _confirmButton.layer.cornerRadius = 12.0f;
//        _confirmButton.layer.masksToBounds = YES;
//        [_confirmButton setTitle:KUFUILocalization(@"UFUICategoryViewController.confirmButton.title") forState:UIControlStateNormal];
//        _confirmButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
//    }
//
//    return _confirmButton;
//}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.backgroundColor = [UIColor systemBackgroundColor];
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CategoryCell"];
    }

    return _tableView;
}

- (NSArray *)categoryArray {
    if (!_categoryArray) {
        _categoryArray = @[@"练习", @"品画交流"];
    }
    
    return _categoryArray;
}

@end


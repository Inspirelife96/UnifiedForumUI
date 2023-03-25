//
//  UFUITagsViewController.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/2.
//

#import "UFUITagsViewController.h"

#import "UFUITagsCell.h"
#import "JCTagListView.h"

#import "UFUITagManager.h"

#import "UFUIConstants.h"

@interface UFUITagsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *okButton;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <UFUITagsCell *> *tagsCellArray;

@property (nonatomic, strong) NSArray <NSNumber *> *tagsCellHeightArray;

@property (nonatomic, copy) NSArray *selectedTagArray;

@property (nonatomic, strong) JCTagListView *tagListView;

@end

@implementation UFUITagsViewController

#pragma mark UIViewcontroller LifeCycle

- (instancetype)initWithSelectedTagArray:(NSArray *)selectedTagArray {
    if (self = [super init]) {
        _selectedTagArray = selectedTagArray;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = KUFUILocalization(@"UFUITagsViewController.navigationBar.title");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.okButton];
    
    [self.view addSubview:self.tableView];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
//    [self.selectedTagArray removeAllObjects];
//
//    [self.tagsCellArray enumerateObjectsUsingBlock:^(UFUITagsCell * _Nonnull tagsCell, NSUInteger idx, BOOL * _Nonnull stop) {
//        [self.selectedTagArray addObjectsFromArray:tagsCell.tagView.selectedTags];
//    }];
//}

#pragma mark UITableViewDelegate, UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [UFUITagManager tagsGroupNameArray][section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[UFUITagManager tagsGroupNameArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UFUITagsCell *cell = self.tagsCellArray[indexPath.section];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tagsCellHeightArray[indexPath.section] floatValue];
}

#pragma mark UI Actions

- (void)clickCloseButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickOKButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        NSMutableArray *newTagArray = [[NSMutableArray alloc] init];

        [self.tagsCellArray enumerateObjectsUsingBlock:^(UFUITagsCell * _Nonnull tagsCell, NSUInteger idx, BOOL * _Nonnull stop) {
            [newTagArray addObjectsFromArray:tagsCell.tagView.selectedTags];
        }];
        
        self.didFinishSelectingTagsHandle([newTagArray copy]);
    }];
}

#pragma mark Getter/Setter

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [[UIButton alloc] init];
        [_closeButton setImage:[UIImage systemImageNamed:@"xmark"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(clickCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeButton;
}

- (UIButton *)okButton {
    if (!_okButton) {
        _okButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 24.0f)];
        _okButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _okButton.backgroundColor = [UIColor linkColor];
        _okButton.layer.cornerRadius = 12.0f;
        _okButton.layer.masksToBounds = YES;

        [_okButton setTitleColor:[UIColor systemBackgroundColor] forState:UIControlStateNormal];
        [_okButton setTitle:KUFUILocalization(@"UFUITagsViewController.navigationBar.okButton.title") forState:UIControlStateNormal];
        [_okButton addTarget:self action:@selector(clickOKButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _okButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen jk_width], [UIScreen jk_height]) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor systemBackgroundColor];
        
        [_tableView registerClass:[UFUITagsCell class] forCellReuseIdentifier:NSStringFromClass([UFUITagsCell class])];
    }
    
    return _tableView;
}

- (NSArray <UFUITagsCell *> *)tagsCellArray {
    if (!_tagsCellArray) {
        NSArray *tagsNameArray = [UFUITagManager tagsNameArray];
        
        NSMutableArray *tempTagsCellArray = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < tagsNameArray.count; i++) {
            UFUITagsCell *tagsCell = [[UFUITagsCell alloc] init];
            
            // 获得这个Cell需要展示的tags
            NSArray *tags = tagsNameArray[i];
            
            // 和已经选择的标签做交，获得这个Cell中被选中的tags
            NSMutableSet *set1 = [NSMutableSet setWithArray:tags];
            NSMutableSet *set2 = [NSMutableSet setWithArray:self.selectedTagArray];
            [set2 intersectSet:set1];
            NSArray *selectedTags = [set2 allObjects];
            
            [tagsCell configCellWithTags:tags selectedTags:[selectedTags mutableCopy]];
            
            [tempTagsCellArray addObject:tagsCell];
        }
        
        _tagsCellArray = [tempTagsCellArray copy];
    }
    
    return _tagsCellArray;
}

- (NSArray <NSNumber *> *)tagsCellHeightArray {
    if (!_tagsCellHeightArray) {
        CGFloat cellPadding = 10.0f;

        NSArray *tagsNameArray = [UFUITagManager tagsNameArray];
        
        NSMutableArray *tempTagsCellHeightArray = [[NSMutableArray alloc] init];
                
        for (NSInteger i = 0; i < tagsNameArray.count; i++) {
            NSArray *tags = tagsNameArray[i];
            self.tagListView.tags = tags;
            [tempTagsCellHeightArray addObject:@(self.tagListView.contentHeight + cellPadding * 2)];
        }
        
        _tagsCellHeightArray = [tempTagsCellHeightArray copy];
    }
    
    return _tagsCellHeightArray;
}

- (JCTagListView *)tagListView {
    if (!_tagListView) {
        _tagListView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 24.0f, 0)];
    }
    
    return _tagListView;
}

@end

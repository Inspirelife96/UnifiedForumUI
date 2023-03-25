//
//  UFUIPickedImageCell.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/7/1.
//

#import "UFUIPickedImageCell.h"

@interface UFUIPickedImageCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation UFUIPickedImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor secondarySystemBackgroundColor];
        self.clipsToBounds = YES;
        
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];

        [self addSubview:self.deleteButton];
        [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView);
            make.right.equalTo(self.imageView);
            make.width.mas_equalTo(20.0f);
            make.height.mas_equalTo(20.0f);
        }];
    }
    
    return self;
}

- (void)clickDeleteButton:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteSelectedPhotoCell:)]) {
        [self.delegate deleteSelectedPhotoCell:self.indexPath];
    }
}

- (void)configWithImage:(UIImage *)image indexPath:(NSIndexPath *)indexPath {
    self.imageView.image = image;
    self.indexPath = indexPath;
}

#pragma mark Getter/Setter

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _imageView;
}

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage systemImageNamed:@"xmark.square.fill"] forState:UIControlStateNormal];
        _deleteButton.tintColor = [UIColor systemBackgroundColor];
        _deleteButton.alpha = 0.6;
        
        [_deleteButton addTarget:self action:@selector(clickDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteButton;
}

@end

//
//  UFUIObjectCell.m
//  INSParseUI
//
//  Created by XueFeng Chen on 2021/6/27.
//

#import "UFUIObjectCell.h"

@implementation UFUIObjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

- (void)configWithObjectCellViewModel:(UFUIObjectCellViewModel *)objectCellVM {
    self.objectCellVM = objectCellVM;
}

@end

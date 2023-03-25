//
//  UFPFService+Category.m
//  UFPFParse
//
//  Created by XueFeng Chen on 2022/7/25.
//

#import "UFPFService+Category.h"

#import "UFPFCategory.h"

#import "UFPFDefines.h"

@implementation UFPFService (Category)

+ (UFPFCategory *)addCategoryWithName:(NSString *)name
                             summary:(NSString *)summary
                 iconImageFileObject:(PFFileObject *)iconImageFileObject
           backgroundImageFileObject:(PFFileObject *)backgroundImageFileObject
                               error:(NSError **)error {
    UFPFCategory *category = [[UFPFCategory alloc] init];
    category.name = name;
    category.summary = summary;
    category.iconImageFileObject = iconImageFileObject;
    category.backgroundImageFileObject = iconImageFileObject;
    
    BOOL succeeded = [category save:error];
    
    if (succeeded) {
        return category;
    } else {
        return nil;
    }
}

+ (UFPFCategory *)findCategoryWithName:(NSString *)name error:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFCategoryKeyClass];
    [query whereKey:UFPFCategoryKeyName equalTo:name];
    
    NSArray<UFPFCategory *> *categories = [query findObjects:error];
    
    if (*error) {
        return nil;
    } else {
        if (categories.count > 0) {
            return categories[0];
        } else {
            return nil;
        }
    }
}

+ (NSArray<UFPFCategory *> *)findAllCategories:(NSError **)error {
    PFQuery *query = [PFQuery queryWithClassName:UFPFCategoryKeyClass];
    return [query findObjects:error];
}

@end

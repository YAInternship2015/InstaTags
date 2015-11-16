//
//  DDTagsDataSource.m
//  InstaTags
//
//  Created by Dmitriy Demchenko on 10/12/15.
//  Copyright (c) 2015 Dmitriy Demchenko. All rights reserved.
//

#import "DDTagsDataSource.h"
#import "DDDataManager.h"

@interface DDTagsDataSource () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) NSArray *tagsArray;

@end

@implementation DDTagsDataSource

#pragma mark - Public methods

- (void)requestTagsListWithName:(NSString *)name {
    __weak typeof(self) weakSelf = self;
    [[DDDataManager sharedManager] tagsByName:name completion:^(BOOL success, id responseObject, NSError *error) {
        if (success) {
            weakSelf.tagsArray = [[NSArray alloc] initWithArray:responseObject];
            [weakSelf.delegate dataSourceDidUpdateContent:self];
        }
    }];
}

- (NSUInteger)objectsCount {
    return [self.tagsArray count];
}

- (NSString *)tagAtIndex:(NSInteger)index {
    return self.tagsArray[index];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.tagsArray count];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont appFontProximanovaRegularWithSize:16.f],
                                 NSForegroundColorAttributeName :[UIColor appSearchFieldColor]};
    return [[NSAttributedString alloc] initWithString:self.tagsArray[row] attributes:attributes];
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dataSource:didSelectRowAtIndex:)])
    [self.delegate dataSource:self didSelectRowAtIndex:row];
}

@end
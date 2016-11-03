//
//  ViewController.m
//  Password
//
//  Created by ervinchen on 16/11/2.
//  Copyright © 2016年 ccnyou. All rights reserved.
//

#import "ViewController.h"
#import "NSArray+Yoyo.h"
#import "UIView+Toast.h"
#import "PasswordRecord.h"
#import "NSDictionary+Yoyo.h"

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *resultTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray* historyRecords;
@property (nonatomic, strong) NSDictionary* groupedRecords;
@property (nonatomic, strong) NSArray* domains;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_reloadData {
    [self _reloadHistoryRecords];
    [self _fillTextFields];
    [self.pickerView reloadAllComponents];
}

- (void)_reloadHistoryRecords {
    self.historyRecords = [PasswordRecord objectsWhere:@"order by lastUsed desc" arguments:nil];
    self.groupedRecords = [self.historyRecords yoyo_dictionaryGroupByKey:^id(PasswordRecord* record) {
        return record.domain;
    }];
    
    NSString* search = nil; // disable search feature
    self.domains = [self.historyRecords yoyo_copyElements:^id(PasswordRecord* record) {
        NSString* result = record.domain;
        if (search.length > 0) {
            if ([record.domain containsString:search]) {
                return result;
            }
            
            if ([record.account containsString:search]) {
                return result;
            }
            
            return nil;
        }
        
        return result;
    }];
    NSMutableOrderedSet* set = [[NSMutableOrderedSet alloc] initWithArray:self.domains];
    self.domains = [set array];
}

- (void)_fillTextFields {
    NSString* domain = [self.domains firstObject];
    NSArray* records = [self.groupedRecords yoyo_arrayForKey:domain];
    PasswordRecord* record = [records firstObject];
    if (record) {
        self.domainTextField.text = record.domain;
        self.accountTextField.text = record.account;
        self.keyTextField.text = record.key;
    }
}

- (NSString *)_domainWithUrl:(NSURL *)url {
    NSString* result = url.host;
    NSArray* components = [url.host componentsSeparatedByString:@"."];
    NSInteger count = components.count;
    if (components.count > 2) {
        NSString* left = [components objectAtIndex:count - 2];
        NSString* right = [components lastObject];
        result = [NSString stringWithFormat:@"%@.%@", left, right];
    }
    
    return result;
}

- (void)_generatePassword {
    const NSInteger kMaxKeyLength = 5;
    NSString* domain = self.domainTextField.text;
    domain = [domain uppercaseString]; // make first letter uppercase
    
    NSString* key = self.keyTextField.text;
    NSData* data = [key dataUsingEncoding:NSUTF8StringEncoding];
    data = [data base64EncodedDataWithOptions:0];
    NSString* upperString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    upperString = [upperString uppercaseString];
    NSCharacterSet* keepSet = [NSCharacterSet alphanumericCharacterSet];
    NSCharacterSet* removeSet = [keepSet invertedSet];
    key = [[upperString componentsSeparatedByCharactersInSet:removeSet] componentsJoinedByString:@""];
    if (key.length > kMaxKeyLength) {
        // max key length
        key = [key substringToIndex:kMaxKeyLength];
    }
    
    NSString* password = [NSString stringWithFormat:@"%@.%@", domain, key];
    self.resultTextField.text = password;
}

- (void)_copyPassword {
    NSString* text = self.resultTextField.text;
    UIPasteboard* paseboard = [UIPasteboard generalPasteboard];
    [paseboard setString:text];
}

- (void)_saveRecord {
    PasswordRecord* record = [self _selectedReocrd];
    if (!record) {
        record = [[PasswordRecord alloc] init];
        record.domain = self.domainTextField.text;
        record.account = self.accountTextField.text;
    }
    
    record.key = self.keyTextField.text;
    record.lastUsed = [NSDate date];
    [record save];
}

- (PasswordRecord *)_selectedReocrd {
    PasswordRecord* record = nil;
    NSString* domain = self.domainTextField.text;
    NSString* account = self.accountTextField.text;
    NSArray* records = [self.groupedRecords yoyo_arrayForKey:domain];
    for (PasswordRecord* indexRecord in records) {
        if ([indexRecord.account isEqualToString:account]) {
            record = indexRecord;
            break;
        }
    }
    
    return record;
}

#pragma mark - Event

- (IBAction)_onEndEditing:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)_onDomainEndEditing:(id)sender {
    NSString* text = self.domainTextField.text;
    NSURL* url = [NSURL URLWithString:text];
    if (url.host.length > 0) {
        text = [self _domainWithUrl:url];
    }
    
    self.domainTextField.text = text;
    self.resultTextField.text = @"";    // 清空上次结果
}

- (IBAction)_onDomainChanged:(id)sender {
    [self _reloadHistoryRecords];
    [self.pickerView reloadAllComponents];
}

- (IBAction)_onGenerateTouched:(id)sender {
    [self _generatePassword];
    [self _saveRecord];
    [self _reloadData];
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
}

- (IBAction)_onGenerateCopyTouched:(id)sender {
    [self _generatePassword];
    [self _copyPassword];
    [self _saveRecord];
    [self _reloadData];
    
    [self.pickerView selectRow:0 inComponent:0 animated:YES];
    [self.pickerView selectRow:0 inComponent:1 animated:YES];
    
    [self.view makeToast:@"复制成功"];
}

- (IBAction)_onDeleteRecordTouched:(id)sender {
    PasswordRecord* record = [self _selectedReocrd];
    if (!record) {
        return;
    }
    
    [record deleteObject];
    [self _reloadData];
    
    [self.view makeToast:@"删除成功"];
}

#pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2; // domain + account
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = 0;
    if (component == 0) {
        count = self.domains.count;
    } else {
        NSInteger index = [pickerView selectedRowInComponent:0];
        NSString* domain = [self.domains yoyo_stringAtIndex:index];
        NSArray* records = [self.groupedRecords yoyo_arrayForKey:domain];
        count = records.count;
    }
    
    if (count == 0) {
        count = 1;
    }
    
    return count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    PasswordRecord* record = nil;
    if (component == 0) {
        NSString* domain = [self.domains yoyo_stringAtIndex:row];
        NSArray* records = [self.groupedRecords yoyo_arrayForKey:domain];
        record = [records firstObject];
        [pickerView reloadComponent:1];
    } else {
        NSInteger index = [pickerView selectedRowInComponent:0];
        NSString* domain = [self.domains yoyo_stringAtIndex:index];
        NSArray* records = [self.groupedRecords yoyo_arrayForKey:domain];
        record = [records yoyo_objectAtIndex:row];
    }
    
    if (record.account.length > 0) {
        self.domainTextField.text = record.domain;
        self.accountTextField.text = record.account;
        self.keyTextField.text = record.key;
        self.resultTextField.text = @"";
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString* title = nil;
    if (component == 0) {
        NSString* domain = [self.domains yoyo_stringAtIndex:row];
        title = domain;
    } else {
        NSInteger index = [pickerView selectedRowInComponent:0];
        NSString* domain = [self.domains yoyo_stringAtIndex:index];
        NSArray* records = [self.groupedRecords yoyo_arrayForKey:domain];
        PasswordRecord* record = [records yoyo_objectAtIndex:row];
        title = record.account;
    }
    
    if (title.length <= 0) {
        title = @"--";
    }
    
    return title;
}

@end

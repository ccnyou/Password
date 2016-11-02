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

@interface ViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *domainTextField;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (weak, nonatomic) IBOutlet UITextField *resultTextField;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, strong) NSArray* historyRecords;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self _loadHistoryRecords];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)_loadHistoryRecords {
    self.historyRecords = [PasswordRecord objectsWhere:@"order by lastUsed desc" arguments:nil];
    PasswordRecord* record = [self.historyRecords firstObject];
    if (record) {
        self.domainTextField.text = record.domain;
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
        key = [key substringToIndex:kMaxKeyLength - 1];
    }
    
    NSString* password = [NSString stringWithFormat:@"%@_%@", domain, key];
    self.resultTextField.text = password;
}

- (void)_copyPassword {
    NSString* text = self.resultTextField.text;
    UIPasteboard* paseboard = [UIPasteboard generalPasteboard];
    [paseboard setString:text];
}

- (void)_saveRecord {
    PasswordRecord* record = [[PasswordRecord alloc] init];
    record.domain = self.domainTextField.text;
    record.key = self.keyTextField.text;
    record.lastUsed = [NSDate date];
    [record save];
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

- (IBAction)_onGenerateTouched:(id)sender {
    [self _generatePassword];
    [self _saveRecord];
    [self _loadHistoryRecords];
    [self.pickerView reloadAllComponents];
}

- (IBAction)_onGenerateCopyTouched:(id)sender {
    [self _generatePassword];
    [self _copyPassword];
    [self _saveRecord];
    [self _loadHistoryRecords];
    [self.pickerView reloadAllComponents];
    [self.view makeToast:@"复制成功"];
}

#pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger count = self.historyRecords.count;
    if (count == 0) {
        count = 1;
    }
    
    return count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    PasswordRecord* record = [self.historyRecords yoyo_objectAtIndex:row];
    if (record.domain) {
        self.domainTextField.text = record.domain;
        self.keyTextField.text = record.key;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PasswordRecord* record = [self.historyRecords yoyo_objectAtIndex:row];
    NSString* title = @"无记录";
    if (record.domain.length > 0) {
        title = record.domain;
    }
    
    return title;
}

@end

//
//  QiKeychainLoginViewController.m
//  QiKeychain
//
//  Created by wangyongwang on 2019/1/29.
//  Copyright © 2019年 QiShare. All rights reserved.
//

#import "QiKeychainViewController.h"
#import "QiKeychainItem.h"


@interface QiKeychainViewController ()

@property (nonatomic, strong) UITextField *accountTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@end

@implementation QiKeychainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"钥匙串的基本使用";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupUI];
}

- (void)setupUI{
    
    CGFloat horMargin = 20.0;
    CGFloat verMargin = 40.0;
    CGFloat textFieldW = CGRectGetWidth(self.view.frame) - horMargin * 2;
    CGFloat textFieldH = 40.0;
    
    UITextField *accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(horMargin, verMargin, textFieldW, textFieldH)];
    accountTextField.placeholder = @"请输入用户名";
    _accountTextField = accountTextField;
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:accountTextField];
    accountTextField.borderStyle = UITextBorderStyleRoundedRect;
    
    UITextField *passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(horMargin, CGRectGetMaxY(accountTextField.frame) + verMargin, textFieldW, textFieldH)];
    passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
    passwordTextField.placeholder = @"请输入密码";
    _passwordTextField = passwordTextField;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:passwordTextField];
    
    UIButton *saveBtn = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame) - textFieldW * 0.5, CGRectGetMaxY(passwordTextField.frame) + verMargin, textFieldW, textFieldH)];
    saveBtn.backgroundColor = [UIColor blueColor];
    [saveBtn setTitle:@"保存用户名密码" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    UIButton *queryBtn = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame) - textFieldW * 0.5, CGRectGetMaxY(saveBtn.frame) + verMargin, textFieldW, textFieldH)];
    queryBtn.backgroundColor = [UIColor blueColor];
    [queryBtn setTitle:@"查询密码" forState:UIControlStateNormal];
    [queryBtn addTarget:self action:@selector(queryButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:queryBtn];
    
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame) - textFieldW * 0.5, CGRectGetMaxY(queryBtn.frame) + verMargin, textFieldW, textFieldH)];
    deleteBtn.backgroundColor = [UIColor blueColor];
    [deleteBtn setTitle:@"删除该item" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteBtn];
    
    UIButton *updateBtn = [[UIButton alloc] initWithFrame: CGRectMake(CGRectGetMidX(self.view.frame) - textFieldW * 0.5, CGRectGetMaxY(deleteBtn.frame) + verMargin, textFieldW, textFieldH)];
    updateBtn.backgroundColor = [UIColor blueColor];
    [updateBtn setTitle:@"更新该item" forState:UIControlStateNormal];
    [updateBtn addTarget:self action:@selector(updateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateBtn];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [self.view addGestureRecognizer:tapGes];
}

- (void)tapGes:(UITapGestureRecognizer*)tapGes {
    
    [self.view endEditing:YES];
}

- (void)saveButtonClicked:(UIButton *)sender {
    
    if (_accountTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        [QiKeychainItem saveKeychainWithService:QikeychainService account:_accountTextField.text password:_passwordTextField.text];
    } else {
        NSLog(@"用户名或者密码不能为空");
    }
}

- (void)queryButtonClicked:(UIButton *)sender {
    
    if (_accountTextField.text.length > 0) {
        NSError *keychainError = [QiKeychainItem queryKeychainWithService:QikeychainService account:_accountTextField.text];
        if (keychainError.code == errSecSuccess) {
            _passwordTextField.text = [keychainError.userInfo valueForKey:NSLocalizedDescriptionKey];
        }
    } else {
        NSLog(@"用户名不能为空");
    }
}

- (void)deleteButtonClicked:(UIButton *)sender {
    
    if (_accountTextField.text.length > 0) {
        NSError *error = [QiKeychainItem deleteWithService:QikeychainService account:_accountTextField.text];
        if (!error) {
            NSLog(@"删除成功");
        } else {
            NSLog(@"删除失败");
        }
    } else {
        NSLog(@"用户名不能为空");
    }
}

- (void)updateButtonClicked:(UIButton *)sender {
    
    if (_accountTextField.text.length > 0 && _passwordTextField.text.length > 0) {
        [QiKeychainItem updateKeychainWithService:QikeychainService account:_accountTextField.text password:_passwordTextField.text];
    } else {
        NSLog(@"用户名或者密码不能为空");
    }
}

@end

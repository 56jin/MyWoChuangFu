//
//  OrderSearchConditionView.m
//  WoChuangFu
//
//  Created by wuhui on 15/6/11.
//  Copyright (c) 2015年 asiainfo-linkage. All rights reserved.
//

#import "OrderSearchConditionView.h"

#define CONDITION_VIEW_TAG      111
#define CONSIGN_FIELD_TAG       112
#define ORDER_ID_FIELD_TAG      113
#define CERT_ID_FIELD_TAG       114
#define APP_ACCOUNT_ID_TAG      115


@implementation OrderSearchConditionView

@synthesize delegate;

- (void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self layoutContentView];
        
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleFromTap:)];
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
        [tapRecognizer release];

    }
    return self;
}

- (void)layoutContentView
{
    UIView *conditionView = [[UIView alloc] initWithFrame:CGRectMake(27/2.0f, 25/2.0f, self.frame.size.width-27.0f, 400/2.0f)];
    conditionView.tag = CONDITION_VIEW_TAG;
    conditionView.backgroundColor = [UIColor clearColor];
    conditionView.layer.cornerRadius = 5;
    conditionView.layer.borderWidth = 1;
    conditionView.layer.borderColor = [[ComponentsFactory createColorByHex:@"#959595"] CGColor];
    
    NSInteger cnt = 0;
    CGFloat rowHei = 60/2.0f;
    CGFloat rowY = 22/2.0f;
    
    NSDictionary *attributeDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [ComponentsFactory createColorByHex:@"#959595"],NSForegroundColorAttributeName, nil];
    
    //布局订单号
    CGFloat fieldWidth = conditionView.frame.size.width - rowY*2;
    UITextField *orderIDField = [[UITextField alloc] initWithFrame:CGRectMake(rowY, rowHei*cnt, fieldWidth, rowHei)];
    orderIDField.backgroundColor = [UIColor clearColor];
    orderIDField.clearButtonMode = UITextFieldViewModeWhileEditing;
    orderIDField.tag = ORDER_ID_FIELD_TAG;
    NSAttributedString *orderID = [[NSAttributedString alloc] initWithString:@"订单号"
                                                                  attributes:attributeDic];
    orderIDField.attributedPlaceholder = orderID;
    [orderID release];
    orderIDField.textAlignment = NSTextAlignmentLeft;
    orderIDField.delegate = self;
    orderIDField.textColor = [ComponentsFactory createColorByHex:@"#333333"];
    orderIDField.font = [UIFont systemFontOfSize:13.0f];
    orderIDField.returnKeyType = UIReturnKeyDone;
    [conditionView addSubview:orderIDField];
    [orderIDField release];
    
    [self insertSeperViewToSuperView:conditionView withSeperY:rowHei*(cnt+1)];
    
    //布局收货人手机号码
    cnt++;
    UITextField *consigenPhoneField = [[UITextField alloc] initWithFrame:CGRectMake(rowY, rowHei*cnt, fieldWidth, rowHei)];
    consigenPhoneField.backgroundColor = [UIColor clearColor];
    consigenPhoneField.tag = CONSIGN_FIELD_TAG;
    consigenPhoneField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSAttributedString *consignPhone = [[NSAttributedString alloc] initWithString:@"收货人手机号码"
                                                                  attributes:attributeDic];
    consigenPhoneField.attributedPlaceholder = consignPhone;
    [consignPhone release];
    consigenPhoneField.delegate = self;
    consigenPhoneField.textAlignment = NSTextAlignmentLeft;
    consigenPhoneField.textColor = [ComponentsFactory createColorByHex:@"#333333"];
    consigenPhoneField.font = [UIFont systemFontOfSize:13.0f];
    consigenPhoneField.returnKeyType = UIReturnKeyDone;
    [conditionView addSubview:consigenPhoneField];
    [consigenPhoneField release];
    
    [self insertSeperViewToSuperView:conditionView withSeperY:rowHei*(cnt+1)];
    
    //布局入网人证件号码
    cnt++;
    UITextField *certIDField = [[UITextField alloc] initWithFrame:CGRectMake(rowY, rowHei*cnt, fieldWidth, rowHei)];
    certIDField.backgroundColor = [UIColor clearColor];
    certIDField.textAlignment = NSTextAlignmentLeft;
    certIDField.tag = CERT_ID_FIELD_TAG;
    certIDField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSAttributedString *certID = [[NSAttributedString alloc] initWithString:@"入网人证件号码"
                                                                       attributes:attributeDic];
    certIDField.attributedPlaceholder = certID;
    [certID release];
    certIDField.delegate = self;
    certIDField.textColor = [ComponentsFactory createColorByHex:@"#333333"];
    certIDField.font = [UIFont systemFontOfSize:13.0f];
    certIDField.returnKeyType = UIReturnKeyDone;
    [conditionView addSubview:certIDField];
    [certIDField release];
    
    [self insertSeperViewToSuperView:conditionView withSeperY:rowHei*(cnt+1)];
    
    //布局创富者ID
    cnt++;
    UITextField *accountIDField = [[UITextField alloc] initWithFrame:CGRectMake(rowY, rowHei*cnt, fieldWidth, rowHei)];
    accountIDField.backgroundColor = [UIColor clearColor];
    accountIDField.textAlignment = NSTextAlignmentLeft;
    accountIDField.tag = APP_ACCOUNT_ID_TAG;
    accountIDField.clearButtonMode = UITextFieldViewModeWhileEditing;
    NSAttributedString *accountID = [[NSAttributedString alloc] initWithString:@"创富者ID"
                                                                 attributes:attributeDic];
    accountIDField.attributedPlaceholder = accountID;
    [accountID release];
    accountIDField.delegate = self;
    accountIDField.textColor = [ComponentsFactory createColorByHex:@"#333333"];
       NSString *qq =  [[NSUserDefaults standardUserDefaults]objectForKey:@"qq"];
    if (qq!=nil&&[qq length]>0) {
        accountIDField.text = qq;
    }
    
    accountIDField.font = [UIFont systemFontOfSize:13.0f];
    accountIDField.returnKeyType = UIReturnKeyDone;
    [conditionView addSubview:accountIDField];
    [accountIDField release];
    

    
    [self insertSeperViewToSuperView:conditionView withSeperY:rowHei*(cnt+1)];
    
    [attributeDic release];
    

    //布局开户状态
    cnt++;
    UILabel *openStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(rowY, rowHei*cnt, 120/2.0f, rowHei)];
    openStatusLabel.backgroundColor = [UIColor clearColor];
    openStatusLabel.textAlignment = NSTextAlignmentLeft;
    openStatusLabel.text = @"开户状态:";
    openStatusLabel.textColor = [ComponentsFactory createColorByHex:@"#333333"];
    openStatusLabel.font = [UIFont systemFontOfSize:13.0f];
    [conditionView addSubview:openStatusLabel];
    [openStatusLabel release];
    
    SingleSelectView *statusSelectView = [[SingleSelectView alloc] initWithFrame:CGRectMake(rowY+120/2.0f+2, rowHei*cnt, fieldWidth-120/2.0f-2, rowHei) withOrderType:NO];
    statusSelectView.delegate = self;
    [conditionView addSubview:statusSelectView];
    [statusSelectView release];
    
    selectOpenStatus = All;
    
    [self insertSeperViewToSuperView:conditionView withSeperY:rowHei*(cnt+1)];
    
    //布局订单类型
    cnt++;
    UILabel *orderTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(rowY, rowHei*cnt, 120/2.0f, rowHei)];
    orderTypeLabel.backgroundColor = [UIColor clearColor];
    orderTypeLabel.textAlignment = NSTextAlignmentLeft;
    orderTypeLabel.text = @"订单类型:";
    orderTypeLabel.textColor = [ComponentsFactory createColorByHex:@"#333333"];
    orderTypeLabel.font = [UIFont systemFontOfSize:13.0f];
    [conditionView addSubview:orderTypeLabel];
    [orderTypeLabel release];
    
    SingleSelectView *typeSelctView = [[SingleSelectView alloc] initWithFrame:CGRectMake(rowY+120/2.0f+2, rowHei*cnt, fieldWidth-120/2.0f-2, 100/2.0f) withOrderType:YES];
    typeSelctView.delegate = self;
    [conditionView addSubview:typeSelctView];
    [typeSelctView release];
    
    selectOrderType = chuangFuOrder;
    
    [self addSubview:conditionView];
    [conditionView release];
    
    //布局重置，查询按钮
    UIButton *resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetBtn.backgroundColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    resetBtn.frame = CGRectMake(27/2.0f, 25/2.0f+400/2.0f+25/2.0f, (self.frame.size.width-27-5)/2.0f, 74/2.0f);
    [resetBtn addTarget:self
                 action:@selector(reset:)
       forControlEvents:UIControlEventTouchUpInside];
    resetBtn.layer.cornerRadius = 5;
    resetBtn.layer.borderWidth = 1;
    resetBtn.layer.borderColor = [[ComponentsFactory createColorByHex:@"#F96C00"] CGColor];

    [self addSubview:resetBtn];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.backgroundColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    searchBtn.frame = CGRectMake(27/2.0f+(self.frame.size.width-27-5)/2.0f+5, 25/2.0f+400/2.0f+25/2.0f, (self.frame.size.width-27-5)/2.0f, 74/2.0f);
    
    CGFloat width = (self.frame.size.width-27-5)/2.0f;
    CGFloat hei = 74/2.0f;
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake((hei-30/2.0f)/2.0f, width/2.0f-30, (hei-30/2.0f)/2.0f, width/2.0f+15);
    [searchBtn setImage:[UIImage imageNamed:@"iconSearch.png"] forState:UIControlStateNormal];
    [searchBtn setTitle:@"查询" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [searchBtn addTarget:self
                  action:@selector(search:)
        forControlEvents:UIControlEventTouchUpInside];
    searchBtn.layer.cornerRadius = 5;
    searchBtn.layer.borderWidth = 1;
    searchBtn.layer.borderColor = [[ComponentsFactory createColorByHex:@"#F96C00"] CGColor];
    [self addSubview:searchBtn];

    //布局进入稽核页面按钮
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    checkBtn.backgroundColor = [ComponentsFactory createColorByHex:@"#F96C00"];
    [checkBtn setTitle:@"进入稽核页面" forState:UIControlStateNormal];
    [checkBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    checkBtn.frame = CGRectMake(27/2.0f, 25+400/2.0f+18/2.0f+74/2.0f, self.frame.size.width-27, 74/2.0f);
    [checkBtn addTarget:self
                 action:@selector(gotoCheckView:)
       forControlEvents:UIControlEventTouchUpInside];
    checkBtn.layer.cornerRadius = 5;
    checkBtn.layer.borderWidth = 1;
    checkBtn.layer.borderColor = [[ComponentsFactory createColorByHex:@"#F96C00"] CGColor];
    [self addSubview:checkBtn];

}

- (void)insertSeperViewToSuperView:(UIView *)superView withSeperY:(CGFloat)seperY
{
    UIView *seperView = [[UIView alloc] initWithFrame:CGRectMake(0, seperY, superView.frame.size.width, 1)];
    seperView.backgroundColor = [ComponentsFactory createColorByHex:@"#959595"];
    [superView addSubview:seperView];
    [seperView release];
}

#pragma mark
#pragma mark - UIAction
- (void)reset:(id)sender
{
    [self hiddenkeyWindows];
    UIView  *conditionView = [self viewWithTag:CONDITION_VIEW_TAG];
    UITextField  *consignField = (UITextField *)[conditionView viewWithTag:CONSIGN_FIELD_TAG];
    UITextField  *orderIdField = (UITextField *)[conditionView viewWithTag:ORDER_ID_FIELD_TAG];
    UITextField  *certIdField = (UITextField *)[conditionView viewWithTag:CERT_ID_FIELD_TAG];
    UITextField *acountIDField = (UITextField *)[conditionView viewWithTag:APP_ACCOUNT_ID_TAG];

    consignField.text = @"";
    orderIdField.text = @"";
    certIdField.text = @"";
    acountIDField.text = @"";
}

- (void)search:(id)sender
{
    [self hiddenkeyWindows];
    NSLog(@"search");
    UIView  *conditionView = [self viewWithTag:CONDITION_VIEW_TAG];
    UITextField  *consignField = (UITextField *)[conditionView viewWithTag:CONSIGN_FIELD_TAG];
    UITextField  *orderIdField = (UITextField *)[conditionView viewWithTag:ORDER_ID_FIELD_TAG];
    UITextField  *certIdField = (UITextField *)[conditionView viewWithTag:CERT_ID_FIELD_TAG];
    UITextField *acountIDField = (UITextField *)[conditionView viewWithTag:APP_ACCOUNT_ID_TAG];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (consignField.text == nil) {
        [data setObject:@"" forKey:@"phone"];
    }else{
        [data setObject:consignField.text forKey:@"phone"];
    }
    
    if (orderIdField.text == nil) {
        [data setObject:@"" forKey:@"orderCode"];
    }else{
        [data setObject:orderIdField.text forKey:@"orderCode"];
    }
    
    if (certIdField.text == nil) {
        [data setObject:@"" forKey:@"certNum"];
    }else{
        [data setObject:certIdField.text forKey:@"certNum"];
    }
    
    NSString *accountID = nil;
    if (acountIDField.text == nil) {
        accountID = @"";
    }else{
        accountID = acountIDField.text;
    }
    
    switch (selectOrderType) {
        case chuangFuOrder:{
            [data setObject:@"0" forKey:@"orderTypeResult"];
            [data setObject:accountID forKey:@"developCode"];
            [data setObject:@"" forKey:@"telePhoneOrderId"];
            [data setObject:@"" forKey:@"enterWorker"];
        }
            break;
        case chuangFuOrder2:
        {
            [data setObject:@"0" forKey:@"orderTypeResult"];
            [data setObject:accountID forKey:@"developCode"];
            [data setObject:@"" forKey:@"telePhoneOrderId"];
            [data setObject:@"" forKey:@"enterWorker"];
        }
            break;
        case phoneSaleOrder:
        {
            [data setObject:@"1" forKey:@"orderTypeResult"];
            [data setObject:accountID forKey:@"telePhoneOrderId"];
            [data setObject:@"" forKey:@"developCode"];
            [data setObject:@"" forKey:@"enterWorker"];
        }
            break;
        case FocusOrder:
        {
            [data setObject:@"2" forKey:@"orderTypeResult"];
            [data setObject:accountID forKey:@"enterWorker"];
            [data setObject:@"" forKey:@"telePhoneOrderId"];
            [data setObject:@"" forKey:@"developCode"];
        }
            break;
        default:
            break;
    }
    
    switch (selectOpenStatus) {
        case All:
        {
            [data setObject:@"" forKey:@"orderResult"];
        }
            break;
        case isOpen:
        {
            [data setObject:@"0" forKey:@"orderResult"];
        }
            break;
        case noOpen:
        {
            [data setObject:@"1" forKey:@"orderResult"];
        }
            break;
        default:
            break;
    }
    [data setObject:@"0" forKey:@"start"];
    [data setObject:@"5" forKey:@"count"];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(didOrderConditionSearch:)]) {
        [self.delegate didOrderConditionSearch:data];
    }
}

- (void)gotoCheckView:(id)sender
{
    [self hiddenkeyWindows];
    NSLog(@"check");
}


- (void)handleFromTap:(UIGestureRecognizer *)tapSender
{
    [self hiddenkeyWindows];
}

- (void)hiddenkeyWindows
{
    UIView  *conditionView = [self viewWithTag:CONDITION_VIEW_TAG];
    UITextField  *consignField = (UITextField *)[conditionView viewWithTag:CONSIGN_FIELD_TAG];
    UITextField  *orderIdField = (UITextField *)[conditionView viewWithTag:ORDER_ID_FIELD_TAG];
    UITextField  *certIdField = (UITextField *)[conditionView viewWithTag:CERT_ID_FIELD_TAG];
    UITextField *acountIDField = (UITextField *)[conditionView viewWithTag:APP_ACCOUNT_ID_TAG];
    if ([consignField isFirstResponder]) {
        [consignField resignFirstResponder];
    }
    if ([certIdField isFirstResponder]) {
        [certIdField resignFirstResponder];
    }
    if ([orderIdField isFirstResponder]) {
        [orderIdField resignFirstResponder];
    }
    if ([acountIDField isFirstResponder]) {
        [acountIDField resignFirstResponder];
    }
}

#pragma mark
#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([[touch view] isKindOfClass:[UIButton class]] || [[touch view] isKindOfClass:[UITextField class]]) {
        return NO;
    }
    return YES;
}

#pragma mark
#pragma mark - SingleSelectViewDelegate
- (void)singleSelectViewdidSelectValue:(SingleSelectView *)singleView
{
    
//    UIView  *conditionView = [self viewWithTag:CONDITION_VIEW_TAG];
//    UITextField *acountIDField = (UITextField *)[conditionView viewWithTag:APP_ACCOUNT_ID_TAG];
    
    
    
      NSLog(@"------选择的  模式%u",selectOrderType);
    [self hiddenkeyWindows];
    if (singleView.orderType) {
        selectOrderType = singleView.orderType;
        UIView  *conditionView = [self viewWithTag:CONDITION_VIEW_TAG];
        UITextField *acountIDField = (UITextField *)[conditionView viewWithTag:APP_ACCOUNT_ID_TAG];
        NSDictionary *attributeDic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [ComponentsFactory createColorByHex:@"#959595"],NSForegroundColorAttributeName, nil];
        NSAttributedString *accountID = nil;
        
        
      
        switch (selectOrderType) {
                
            
                
            case chuangFuOrder2:
            {
                accountID = [[NSAttributedString alloc] initWithString:@"创富者ID"
                                                            attributes:attributeDic];
                [self clearMessage];
            }
                break;
            case FocusOrder:
            {
                accountID = [[NSAttributedString alloc] initWithString:@"工号"
                                                            attributes:attributeDic];
                 [self clearMessage];
            }
                break;
            case phoneSaleOrder:
            {
                accountID = [[NSAttributedString alloc] initWithString:@"电话营销ID"
                                                            attributes:attributeDic];
                 [self clearMessage];
            }
                break;
            default:
                break;
        }
        acountIDField.attributedPlaceholder = accountID;
        [accountID release];
        [attributeDic release];
        
    }else{
        selectOpenStatus = singleView.openStatus;
    }
}

-(void)clearMessage{
    UITextField *tf = (UITextField*)[self viewWithTag:CERT_ID_FIELD_TAG];
    UITextField *tf1 = (UITextField*)[self viewWithTag:ORDER_ID_FIELD_TAG];
    UITextField *tf2 = (UITextField*)[self viewWithTag:CONSIGN_FIELD_TAG];
    UITextField *tf3 = (UITextField*)[self viewWithTag:APP_ACCOUNT_ID_TAG];
    tf.text = nil;
    tf2.text = nil;
    tf3.text = nil;
    tf1.text = nil;
}

#pragma mark
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end

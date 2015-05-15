#import "OrderCell.h"

@interface OrderCell()

@end

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubviews];
    }
    
    return self;
}

- (void)addSubviews
{
    UILabel* price = [[UILabel alloc] init];
    price.frame = CGRectMake(28, 33, 100,33);
    price.font = [UIFont systemFontOfSize:14.0];
//    price.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    price.text = @"订单金额";
    [self.contentView addSubview:price];
//    [price release];
    
    UILabel * payType = [[UILabel alloc] init];
    payType.frame = CGRectMake(28, 66, 100,33);
    payType.font = [UIFont systemFontOfSize:14.0];
//    payType.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    payType.numberOfLines = 0;
    price.text = @"支付方式";
    [self.contentView addSubview:payType];
//    [payType release];
    
    UILabel * orderStatus = [[UILabel alloc] init];
    orderStatus.frame = CGRectMake(28, 99, 100,33);
    orderStatus.font = [UIFont systemFontOfSize:14.0];
//    orderStatus.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    orderStatus.text = @"订单状态";
    [self.contentView addSubview:orderStatus];
//    [orderStatus release];
    
    UILabel *time = [[UILabel alloc] init];
    time.frame = CGRectMake(28, 132,100,33);
    time.font = [UIFont systemFontOfSize:14.0];
    time.text = @"下单日期";
//    time.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    [self.contentView addSubview:time];
//    [time release];
    
    UILabel *sendId = [[UILabel alloc] init];
    sendId.frame = CGRectMake(28, 165,100,33);
    sendId.text = @"物流编号";
    sendId.font = [UIFont systemFontOfSize:17.0];
//    sendId.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    [self.contentView addSubview:sendId];
//    [sendId release];
    
    UILabel *sendType = [[UILabel alloc] init];
    sendType.frame = CGRectMake(28, 198,100,33);
    sendType.text = @"快递方式";
    sendType.font = [UIFont systemFontOfSize:17.0];
//    sendType.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    [self.contentView addSubview:sendType];
//    [sendType release];
    
    _orderPrice = [[UILabel alloc] init];
    _orderPrice.frame = CGRectMake(128, 33,100,33);
    _orderPrice.text = @"Y0";
    _orderPrice.font = [UIFont systemFontOfSize:17.0];
//    _orderPrice.textColor = [ComponentsFactory createColorByHex:@"#4a4a4a"];
    [self.contentView addSubview:_orderPrice];
//    [_orderPrice release];
    
    _orderPayType = [[UILabel alloc] init];
    _orderPayType.frame = CGRectMake(128, 66,100,33);
    _orderPayType.text = @"货到付款";
    _orderPayType.font = [UIFont systemFontOfSize:17.0];
//    _orderPayType.textColor = [ComponentsFactory createColorByHex:@"#4a4a4a"];
    [self.contentView addSubview:_orderPayType];
//    [_orderPayType release];
    
    _orderStatus = [[UILabel alloc] init];
    _orderStatus.frame = CGRectMake(128, 99,100,33);
    _orderStatus.text = @"未支付";
    _orderStatus.font = [UIFont systemFontOfSize:17.0];
//    _orderStatus.textColor = [ComponentsFactory createColorByHex:@"#4a4a4a"];
    [self.contentView addSubview:_orderStatus];
//    [_orderStatus release];
    
    _orderTime = [[UILabel alloc] init];
    _orderTime.frame = CGRectMake(128, 132,100,33);
    _orderTime.text = @"2014-11-18 10:38";
    _orderTime.font = [UIFont systemFontOfSize:17.0];
//    _orderTime.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    [self.contentView addSubview:_orderTime];
//    [_orderTime release];
    
    _sendNum = [[UILabel alloc] init];
    _sendNum.frame = CGRectMake(128, 165,100,33);
    _sendNum.text = @"889988778";
    _sendNum.font = [UIFont systemFontOfSize:17.0];
//    _sendNum.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    [self.contentView addSubview:_sendNum];
//    [_sendNum release];
    
    _sendType = [[UILabel alloc] init];
    _sendType.frame = CGRectMake(128, 198,100,33);
    _sendType.text = @"顺丰快递";
    _sendType.font = [UIFont systemFontOfSize:17.0];
//    _sendType.textColor = [ComponentsFactory createColorByHex:@"#8f8f8f"];
    [self.contentView addSubview:_sendType];
//    [_sendType release];
    
    
    
}

@end

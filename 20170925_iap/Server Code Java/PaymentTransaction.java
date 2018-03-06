
public class PaymentTransactionDTO {

    // id
    private String id;

    // 创建时间
    private Date createDate = new Date();

    // 根据真实的充值金额兑换后的金币的金额
    private Double exchangeGold;

    // 真实的充值金额
    private Double realmoney;

    // 兑换金币的类型
    private Integer exchangeGoldType;

    // 应用内购买产品Id
    private String productId;

    // 应用内购买收据
    private String receipt;

    // 交易Id
    private String transactionId;

    // 交易状态
    private String transactionState;

    //平台  1 android 2 ios
    private String platform;

    //平台 0 ios商店充值 1 支付宝  2 微信 3 paypal
    private String payPlatform;

    //货币类型 1人民币 2 美元
    private String coinType;

    // Getters and setters
    // ......
}

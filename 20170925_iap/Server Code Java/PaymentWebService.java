
@Component
@Path("/paytran")
public class PaymentWebService {

    private static Logger logger = LoggerFactory.getLogger(UserGoldPayService.class);

    @Autowired
    private UserGoldPayManager userGoldPayManager;

    @Autowired
    private RechargeRatioManager rechargeRatioManager;

    @Autowired
    private SessionManager sessionManager;

    @Autowired
    private AccountManager accountManager;

    @POST
    @Path("/doPayment")
    @Consumes({ MediaType.APPLICATION_JSON })
    @Produces({ MediaType.APPLICATION_JSON })
    public Map<String, Object> doPayment(PaymentTransactionDTO tran) {
        Map<String, Object> map = new HashMap<String, Object>();

        try {
            if (tran != null) {
                String userId = tran.getUserId();
                String sessionId = tran.getSessionId();
                Session session = sessionManager.findByUserIdAndSessionId(userId, sessionId);
                if (session != null) {
                    User user = accountManager.getUser(userId);
                    RechargeRatio ratio = rechargeRatioManager.findByProductId(tran.getProductId());
                    if (ratio != null) {
                        String tranState = tran.getTransactionState();
                        String receipt = tran.getReceipt();

                        if (validateTransaction(tranState, receipt)) {
                            user.setUserGoldMoneyPay(user.getUserGoldMoneyPay() + ratio.getExchangeGold());
                            accountManager.updateUser(user);
                        }

                        // 充值记录表中增加一条充值记录
                        UserGoldPay goldpay = new UserGoldPay();
                        goldpay.setUserId(.getUserId());
                        goldpay.setCreateDate(new Date());
                        goldpay.setExchangeGold(ratio.getExchangeGold());
                        goldpay.setRealmoney(ratio.getRealmoney());
                        goldpay.setExchangeGoldType(UserGoldPayUtil.RECHARE);
                        goldpay.setProductId(tran.getProductId());
                        goldpay.setReceipt(receipt);
                        goldpay.setTransactionId(tran.getTransactionId());
                        goldpay.setTransactionState(tranState);
                        goldpay.setPayPlatform(tran.getPayPlatform());
                        goldpay.setPlatform(tran.getPlatform());

                        userGoldPayManager.save(goldpay);

                        map.put("errorCode", ErrorCode.SUCCESS);
                        map.put("userGoldPay", ObjectMapper.map(goldpay, PaymentTransactionDTO.class));
                        map.put("currentGold", user.getUserGoldMoneyPay());
                    } else {
                        map.put("errorCode", ErrorCode.NO_RECHARGE_RATIO_FOUND);
                    }
                } else {
                    map.put("errorCode", ErrorCode.INVALID_SESSION);
                }
            } else {
                map.put("errorCode", ErrorCode.INVALID_PARAMS);
            }
        } catch (Exception e) {
            map.put("errorCode", ErrorCode.UNKNOWN_ERROR);
            logger.error("Failed to insertUserGoldPay", e);
        }

        return map;
    }

    // Should validate the receipt against Apple's Server later
    private boolean validateTransaction(String tranState, String receipt) {
        boolean isValid = false;
        if (tranState != null && tranState.equals(TransactionStates.Purchased) && receipt != null && receipt.length() > 0) {
            // 在sandbox中验证receipt
            // https://sandbox.itunes.apple.com/verifyReceipt

            // 在生产环境中验证receipt
            // https://buy.itunes.apple.com/verifyReceipt

            JSONObject result = verifyReceipt("https://buy.itunes.apple.com/verifyReceipt", recepit);
            if (result != null) {
                int status = Integer.parseInt(result.get("statsu"));
                if (status == 0) {
                    isValid = true;
                } else {
                    logger.error("Verify receipt status code: " + status);
                }
            }
        }

        return isValid;
    }

    public static JSONObject verifyReceipt(String url, String receipt) {
        try {
            HttpsURLConnection connection = (HttpsURLConnection) new URL(url).openConnection();
            connection.setRequestMethod("POST");
            connection.setDoOutput(true);
            connection.setAllowUserInteraction(false);
            PrintStream ps = new PrintStream(connection.getOutputStream());
            ps.print("{\"receipt-data\": \"" + receipt + "\"}");
            ps.close();
            BufferedReader br = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            String str;
            StringBuffer sb = new StringBuffer();
            while ((str = br.readLine()) != null) {
                sb.append(str);
            }
            br.close();
            String resultStr = sb.toString();
            JSONObject result = JSONObject.parseObject(resultStr);
            if (result != null && result.getInteger("status") == 21007) {
                return verifyReceipt1("https://sandbox.itunes.apple.com/verifyReceipt", receipt);
            }

            return result;
        } catch (Exception e) {
            logger.error("Failed to verify receipt", e);
        }

        return null;
    }

}

import com.zhuo.utils.DateTimeUtil;

/**
 * @作者：zhuojunyu
 * @时间：2022/2/24 - 13:41
 */
public class DateTest {
    public static void main(String[] args) {
        //String expireTime = "2021-02-25 00:00:00"; -1 无效为-1
        String expireTime = "2022-02-25 00:00:00"; // 1 有效为1
        String currentTime = DateTimeUtil.getSysTime();
        System.out.println(expireTime.compareTo(expireTime)); // 相等为0
    }
}

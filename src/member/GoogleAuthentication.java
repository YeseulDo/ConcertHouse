package member;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class GoogleAuthentication extends Authenticator {
	PasswordAuthentication passAuth = new PasswordAuthentication("mailAuthTest2019", "test2019*");

	public PasswordAuthentication getPasswordAuthentication() {
		return this.passAuth;
	}
}
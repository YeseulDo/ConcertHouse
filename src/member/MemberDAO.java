package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.Properties;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.Message.RecipientType;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class MemberDAO {
	private DataSource pool;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public MemberDAO() {
		try {
			Context init = new InitialContext();
			this.pool = (DataSource) init.lookup("java:comp/env/jdbc/jspbeginner");
		} catch (Exception var2) {
			System.out.println("Error in Connection Pool");
			var2.printStackTrace();
		}

	}
	
	/* 자원해제 메서드 */
	public void closeRes() {
		if (this.conn != null) {
			try {
				this.conn.close();
			} catch (Exception var4) {
				var4.printStackTrace();
			}
		}

		if (this.rs != null) {
			try {
				this.rs.close();
			} catch (Exception var3) {
				var3.printStackTrace();
			}
		}

		if (this.pstmt != null) {
			try {
				this.pstmt.close();
			} catch (Exception var2) {
				var2.printStackTrace();
			}
		}

	}
	
	/* 회원가입 메서드 */
	public void joinMember(MemberDTO dto) {
		try {
			this.conn = this.pool.getConnection();
			String sql = "INSERT INTO p_member(email, name, password, zip, address1, address2, joinDate, active) VALUES(?,?,?,?,?,?,?,?)";
			this.pstmt = this.conn.prepareStatement(sql);
			this.pstmt.setString(1, dto.getEmail());
			this.pstmt.setString(2, dto.getName());
			this.pstmt.setString(3, dto.getPassword());
			this.pstmt.setInt(4, dto.getZip());
			this.pstmt.setString(5, dto.getAddress1());
			this.pstmt.setString(6, dto.getAddress2());
			this.pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
			this.pstmt.setInt(8, 1);
			this.pstmt.executeUpdate();
		} catch (Exception var6) {
			System.out.println("Error in joinMember()");
			var6.printStackTrace();
		} finally {
			this.closeRes();
		}

	}
	
	/* 회원정보 수정 메서드 */
	public void modifyMember(MemberDTO dto){
		try {
			conn = pool.getConnection();
			String sql = "UPDATE p_member SET name=?, password=?, zip=?, address1=?, address2=? WHERE email=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPassword());
			pstmt.setInt(3, dto.getZip());
			pstmt.setString(4, dto.getAddress1());
			pstmt.setString(5, dto.getAddress2());
			pstmt.setString(6, dto.getEmail());
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("Error in modifyMember()");
			e.printStackTrace();
		}finally {
			closeRes();
		}
	}
	
	/* email 중복체크 메서드 */
	public boolean dupEmail(String email) {
		boolean result = true;

		try {
			this.conn = this.pool.getConnection();
			String sql = "SELECT email FROM p_member WHERE email=?";
			this.pstmt = this.conn.prepareStatement(sql);
			this.pstmt.setString(1, email);
			this.rs = this.pstmt.executeQuery();
			if (this.rs.next()) {
				result = true;
			} else {
				result = false;
			}
		} catch (Exception var7) {
			System.out.println("Error in dupEmail()");
			var7.printStackTrace();
		} finally {
			this.closeRes();
		}

		return result;
	}
	
	/* 6자리 인증번호 생성 메서드 */
	public String authNum() {
		StringBuffer authNum = new StringBuffer();

		for (int i = 0; i < 6; ++i) {
			int randNum = (int) (Math.random() * 10.0D);
			authNum.append(randNum);
		}

		return authNum.toString();
	}
	
	/* 인증메일 전송 메서드 */
	public boolean sendEmail(String email, String authNum) {
		boolean result = false;
		String sender = "mailAuthTest2019@gmail.com";
		String subject = "_ CONCERT HALL 인증번호입니다.";
		String content = "안녕하세요 " + email + "님, <br>" + "귀하의 인증번호는    [<b>" + authNum + "</b>]   입니다.";

		try {
			Properties properties = System.getProperties();
			properties.put("mail.smtp.starttls.enable", "true");
			properties.put("mail.smtp.host", "smtp.gmail.com");
			properties.put("mail.smtp.auth", "true");
			properties.put("mail.smtp.port", "587");
			Authenticator auth = new GoogleAuthentication();
			Session session = Session.getDefaultInstance(properties, auth);
			Message message = new MimeMessage(session);
			Address senderAd = new InternetAddress(sender);
			Address receiverAd = new InternetAddress(email);
			message.setHeader("content-type", "text/html;charset=UTF-8");
			message.setFrom(senderAd);
			message.addRecipient(RecipientType.TO, receiverAd);
			message.setSubject(subject);
			message.setContent(content, "text/html;charset=UTF-8");
			message.setSentDate(new Date());
			Transport.send(message);
			result = true;
		} catch (Exception var13) {
			result = false;
			System.out.println("Error in SendEmail()");
			var13.printStackTrace();
		} finally {
			closeRes();
		}

		return result;
	}
	
	/* 로그인 시 email, password 체크 메서드 */
	public int checkMember(String email, String password){
		
		// chkResult = 1 (모두일치) : 0 (아이디 불일치) : -1 (아이디 일치, 비밀번호 불일치)
		int chkResult = 0;
		
		try {
			conn = pool.getConnection();
			
			String sql = "SELECT * FROM p_member WHERE email=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			
			if(!rs.next()){
				chkResult = 0;
			}else{
				if(rs.getString("password").equals(password)){
					chkResult = 1;
				}else{
					chkResult = -1;
				}
			}
			
		} catch (Exception e) {
			System.out.println("Error in checkMember()");
			e.printStackTrace();
		} finally {
			closeRes();
		}
		
		return chkResult;
	}
	
	/* email에 해당하는 회원 이름 검색 메서드 */
	public MemberDTO memberInfo(String email){
		
		MemberDTO dto = new MemberDTO();
				
		try {
			conn = pool.getConnection();
			
			String sql = "SELECT * FROM p_member WHERE email=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			rs = pstmt.executeQuery();
			
			rs.next();
			dto.setActive(rs.getInt("active"));
			dto.setAddress1(rs.getString("address1"));
			dto.setAddress2(rs.getString("address2"));
			dto.setEmail(rs.getString("email"));
			dto.setJoinDate(rs.getTimestamp("joinDate"));
			dto.setName(rs.getString("name"));
			dto.setPassword(rs.getString("password"));
			dto.setZip(rs.getInt("zip"));
			
			
		} catch (Exception e) {
			System.out.println("Error in checkMember()");
			e.printStackTrace();
		} finally {
			closeRes();
		}
		
		return dto;
	}
	
	/*회원탈퇴메서드*/
	public void deleteMember(String email){
		
		try {
			conn = pool.getConnection();
			String sql = "DELETE FROM p_member WHERE email=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, email);
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("Error in deleteMember()");
			e.printStackTrace();
		}finally {
			closeRes();
		}
		
		
	}
	
}
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	
	String email = request.getParameter("email");
	String password = request.getParameter("password");
	
	MemberDAO dao = new MemberDAO();
	int chkResult = dao.checkMember(email, password);
	
	// chkResult = 1 (모두일치) : 0 (아이디 불일치) : -1 (아이디 일치, 비밀번호 불일치)
	if(chkResult == 0){
%>		<script type="text/javascript">
			alert("아이디를 다시 확인 해 주십시오.");
			history.back();
		</script>
<%	}else if(chkResult == -1){
%>		<script type="text/javascript">
			alert("비밀번호를 다시 확인 해 주십시오.");
			history.back();
		</script>
<%	}else{
		session.setAttribute("email", email);
		response.sendRedirect("../index.jsp");
	}
%>
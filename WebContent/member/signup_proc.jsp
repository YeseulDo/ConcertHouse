<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="dao" class="member.MemberDAO"/>
<jsp:useBean id="dto" class="member.MemberDTO"/>    
	<jsp:setProperty property="*" name="dto"/>
<%
	dao.joinMember(dto);
%>
<script type="text/javascript">
	alert("회원가입에 성공하셨습니다, 로그인페이지로 이동합니다.");
	location.href="login.jsp";
</script>
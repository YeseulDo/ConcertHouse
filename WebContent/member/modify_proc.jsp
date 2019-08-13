<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="dao" class="member.MemberDAO"/>
<jsp:useBean id="dto" class="member.MemberDTO"/>   
	<jsp:setProperty property="*" name="dto"/> 
<%
	dao.modifyMember(dto);
%>
<script type="text/javascript">
	alert("회원정보가 성공적으로 수정되었습니다.");
	location.href="modify.jsp";
</script>
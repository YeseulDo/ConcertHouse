<%@page import="member.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Resign</title>

<!-- Custom styles for this template -->
<link href="../css/floating-labels.css" rel="stylesheet">
<jsp:include page="../include/headlink.jsp"/>
  
<jsp:useBean id="dao" class="member.MemberDAO"></jsp:useBean>

<%
	String email = request.getParameter("email");
	MemberDTO dto = dao.memberInfo(email);
	
	String password = dto.getPassword();
	String input_pass;
	
	if(request.getParameter("password") != null){
		
		input_pass = request.getParameter("password");

		if(password.equals(input_pass)){
			dao.deleteMember(email);
%>
		<script type="text/javascript">
			alert("탈퇴가 완료되었습니다. 안녕히가십시오:-)");
			window.close();
			window.opener.location.href="logout.jsp";
		</script>

<%		
		}else{
%>		<script type="text/javascript">
			alert("비밀번호를 잘 못 입력하셨습니다.");
		</script>
<%		}
	}
%>

<script type="text/javascript">
	function deleteMember(){
		if(document.form.password.value == ""){
			alert("비밀번호를 입력하십시오.");
			form.password.focus;
			return false;
		}else{
			document.form.submit();
		}				
	}
</script>
</head>

<body>
	<form class="form-signin" action="resign.jsp" name="form" method="post">
		<div class="text-center mt-5 mb-4">
			<h1 class="h3 mb-3">Resign</h1>
			<p>정말 탈퇴하시겠습니까?</p>
		</div>
		<div class="form-label-group mt-4">
			<input type="password" name="password" id="password" class="form-control" autofocus="">
			<label for="password">비밀번호를 입력하세요.</label>
			<input type="hidden" name="email" value="<%=email%>">
		</div> 
		<div class="mt-3">
			<button class="btn btn-lg btn-primary btn-block" type="button" onclick="deleteMember()">Request Resign</button>
		</div>
		<p class="mt-5 mb-3 text-muted text-center">© 2017-2019</p>
	</form>

</body>
</html>
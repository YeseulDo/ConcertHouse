<%@page import="board_aud.BoardDTO"%>
<%@page import="board_aud.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Delete</title>

<!-- Custom styles for this template -->
<link href="../css/floating-labels.css" rel="stylesheet">
<jsp:include page="../include/headlink.jsp"/>

<jsp:useBean id="dao" class="board_aud.BoardDAO"></jsp:useBean>
<%
	request.setCharacterEncoding("UTF-8");
	int no = Integer.parseInt(request.getParameter("no"));
	
	BoardDTO dto = dao.getContent(no);
	
	String password = dto.getPassword();
	String input_pass;

	if(request.getParameter("password") != null){
	
		input_pass = request.getParameter("password");
			
		if(password.equals(input_pass)){
			dao.deleteBoard(no);
	%>
		<script type="text/javascript">
			alert("성공적으로 삭제되었습니다.");
			window.close();
			window.opener.location.href="board_audience.jsp";
		</script>
	<%		
		}else{
	%>	<script type="text/javascript">
			alert("비밀번호를 잘 못 입력하셨습니다.");
		</script>
	<%	}
	}
%>
<script type="text/javascript">
	function deleteBoard(){
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
<body>
	<form class="form-signin" action="delete_audience.jsp" name="form" method="post">
		<div class="text-center mt-5 mb-4">
			<h1 class="h3 mb-3">Delete Post</h1>
			<p>정말 삭제하시겠습니까?</p>
		</div>
		<div class="form-label-group mt-4">
			<input type="password" name="password" class="form-control" autofocus="">
			<label for="password">비밀번호를 입력하세요.</label>
			<input type="hidden" value="request" name="request">
			<input type="hidden" value=<%=no %> name="no">
		</div>
		<div class="mt-3">
			<button class="btn btn-lg btn-primary btn-block" type="button" onclick="deleteBoard()">Request Delete</button>
		</div>
		<p class="mt-5 mb-3 text-muted text-center">© 2019 Concert House</p>
	</form>

</body>
</html>
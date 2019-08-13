<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>LOGIN</title>

<!-- Custom styles for this template -->
<link href="../css/floating-labels.css" rel="stylesheet">
<jsp:include page="../include/headlink.jsp"/>
<!-- js-cookie -->
<script src="https://cdn.jsdelivr.net/npm/js-cookie@2/src/js.cookie.min.js"></script>

<script type="text/javascript">

	/* Remember Me 체크 시 아이디 기억 */
	$(function(){
		$("#email").val(Cookies.get('key'));  
	    if($("#email").val()!="")     $("#emailsaveCheck").attr("checked", true);
	    
		$("#emailsaveCheck").change(function(){
		    if($("#emailsaveCheck").is(":checked")) Cookies.set('key', $("#email").val(), { expires: 180 });
		    else 	Cookies.remove('key');
		});
		$("#emailsaveCheck").keyup(function(){
		  	if($("#emailsaveCheck").is(":checked")) Cookies.set('key', $("#email").val(), { expires: 180 });
		});
	})

</script>
</head>

<body>

	<!-- header.jsp -->
	<jsp:include page="../include/header.jsp"/>

	<div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center" id="title_back3">
		<div class="col-md-5 p-lg-5 mx-auto my-5">
			<h1 class="display-4 font-weight-normal">WELCOME:-)</h1>
		</div>
	</div>

	<div class="container">
	
	<!-- 로그인 폼 -->
	<form class="form-signin" action="login_proc.jsp" method="post">
		<p>로그인 해 주세요!</p>
		<div class="form-label-group">
			<input type="email" id="email" name="email" class="form-control"
				placeholder="Email address" required="" autofocus="">
			<label for="inputEmail">Email address</label>
		</div>
		<div class="form-label-group">
			<input type="password" name="password" class="form-control"
				placeholder="Password" required="">
			<label for="inputPassword">Password</label>
		</div>
		<div class="checkbox mb-3">
			<label> <input type="checkbox" id="emailsaveCheck" value="remember-me">
				Remember me <span class="text-muted">(for 180 days!)</span>
			</label>
		</div>
		<button class="btn btn-lg btn-primary btn-block" type="submit">
			LOGIN
		</button>
		<div class="text-center mt-4">
			<p>Concert House 회원이 아니신가요?</p>
			<a href="signup.jsp">회원가입하러가기↗</a>
		</div>
	</form>
	
	</div>

	<!-- footer.jsp -->
	<jsp:include page="../include/footer.jsp" />

</body>
</html>
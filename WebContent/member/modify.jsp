<%@page import="member.MemberDTO"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Edit your information</title>

<jsp:include page="../include/headlink.jsp" />
<!-- Daum postcode API -->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>

<%
	String email = (String) session.getAttribute("email");

	MemberDAO dao = new MemberDAO();
	MemberDTO dto = dao.memberInfo(email);
	
	String name = dto.getName();
	String address1 = dto.getAddress1();
	String address2 = dto.getAddress2();
	String password = dto.getPassword();
	int zip = dto.getZip();
%>

<script type="text/javascript">

	var result_pwd = false;
	
	// Daum postcode API
	 function daumPostcode() {
	     new daum.Postcode({
	         oncomplete: function(data) {
	             // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
	             // 각 주소의 노출 규칙에 따라 주소를 조합한다.
	             // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
	             var addr = ''; // 주소 변수
	             var extraAddr = ''; // 참고항목 변수
	
	             //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
	             if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
	                 addr = data.roadAddress;
	             } else { // 사용자가 지번 주소를 선택했을 경우(J)
	                 addr = data.jibunAddress;
	             }
	
	             // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
	             if(data.userSelectedType === 'R'){
	                 // 법정동명이 있을 경우 추가한다. (법정리는 제외)
	                 // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
	                 if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
	                     extraAddr += data.bname;
	                 }
	                 // 건물명이 있고, 공동주택일 경우 추가한다.
	                 if(data.buildingName !== '' && data.apartment === 'Y'){
	                     extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	                 }
	                 // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
	                 if(extraAddr !== ''){
	                     extraAddr = ' (' + extraAddr + ')';
	                 }
	              // 참고항목의 유무에 따라 최종 주소를 만든다.
	                 addr += (extraAddr !== '' ? extraAddr : '');
	             
	             } 
	
	             // 우편번호와 주소 정보를 해당 필드에 넣는다.
	             document.getElementById("zip").value = data.zonecode;
	             document.getElementById("address1").value = addr;
	             // 커서를 상세주소 필드로 이동한다.
	             document.getElementById("address2").focus();
	         }
	     }).open();
	 }
	
    /* 비밀번호 유효성 검사 메서드*/
    function checkPwd(){
    	var pwd1 = $("#password").val();
    	var checkSpan = $("#checkPwd1");
    	var reg = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{8,25}$/;
    	
     	if(!reg.test(pwd1)){
     		checkSpan.html("<font color='red'><b>√ 비밀번호는 숫자, 알파벳, 특수문자 조합으로 8자리 이상 입력해야 합니다.</b></font>");
     	}else{
     		checkSpan.html("<font color='green'><b>√</b></font>");
     		result_pwd = true;
     	}
    }
    
    /* 비밀번호 재입력 일치 검사 메서드 */
    function checkPwd2(){
    	var pwd1 = document.getElementById("password").value;
    	var pwd2 = document.getElementById("password2").value;
    	var checkSpan = document.getElementById("checkPwd2");
    	if(pwd2 != ""){
	    	if(pwd2 == pwd1){
	    		checkSpan.innerHTML = "<font color='green'><b>√ 비밀번호가 일치합니다.</b></font>";
	    	}else{
	    		checkSpan.innerHTML = "<font color='red'><b>√ 비밀번호가 일치하지 않습니다.</b></font>";
	    	}
    	}
    }
    
    /* SUBMIT 전 공백 검사 메서드 */
    function checkForm(){
    	
    	if($("#name").val()==""){
    		alert("이름을 입력하지 않으셨습니다.");
    		$("#name").focus();
    		return false;
    	}else if($("#password").val()==""){
    		alert("비밀번호를 입력하지 않으셨습니다.");
    		$("#password").focus();
    		return false;
    	}else if($("#password2").val()==""){
    		alert("비밀번호 확인을 입력하지 않으셨습니다.");
    		$("#password2").focus();
    		return false;
    	}else if(!result_pwd){
    		alert("비밀번호를 올바르게 입력하지 않으셨습니다.");
    		$("#password1").focus();
    		return false;
    	}else if($("#zip").val()==""){
    		alert("주소를 입력하지 않으셨습니다.");
    		$("#search").focus();
    		return false;
    	}else if($("#address2").val()==""){
    		alert("나머지 주소를 입력하지 않으셨습니다.");
    		$("#address2").focus();
    		return false;
    	}else return;
    }
    
    /* 회원 탈퇴 확인 메서드 */
    function checkResign(){
    	var email = "<%=email%>";
    	var checkRes = confirm("정말로 탈퇴하시겠습니까?");
    	if(checkRes==true){
    		window.open('resign.jsp?email='+email, '회원탈퇴',
    		'width=500, height=400, menubar=no, status=no, toolbar=no');
    	}
    }
    
</script>
</head>

<body>

	<!-- header.jsp -->
	<jsp:include page="../include/header.jsp" />

	<div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center" id="title_back3">
		<div class="col-md-5 p-lg-5 mx-auto my-5">
			<h1 class="display-4 font-weight-normal">회원정보수정</h1>
		</div>
	</div>

	<form action="modify_proc.jsp" class="needs-validation" method="post" onsubmit="return checkForm();">
	<div class="container" id="container">
	
		<div class="order-md-1">

			<div class="mt-5 mb-3">
				<label for="name">&nbsp;이름</label>
				<input type="text" class="form-control" id="name" name="name" value="<%=name%>">
			</div>

			<div class="mb-3">
				<label for="email">&nbsp;Email</label>
				<div class="input-group">
					<input type="email" class="form-control" id="email" name="email" value="<%=email%>" readonly>
				</div>
			</div>

			<div class="mb-3">
				<label for="password">&nbsp;비밀번호</label><span id="checkPwd1">&nbsp;</span>
				<input type="password" class="form-control" id="password" name="password" onblur="checkPwd()" required="" value="<%=password%>">
			</div>

			<div class="mb-3">
				<label for="password2">&nbsp;비밀번호 확인</label><span id="checkPwd2">&nbsp;</span>
				<input type="password" class="form-control" id="password2" name="password2" onblur="checkPwd2()" required=""> 
			</div>

			<div class="row">
				<div class="col-md-5 mb-3">
					<label for="zip">&nbsp;우편번호</label>
					<div class="input-group">
						<input type="text" class="form-control" id="zip" name="zip" readonly value="<%=zip%>">
						<div class="input-group-append">
							<button type="button" id="search" class="btn btn-secondary" onclick="daumPostcode()">Search</button>
						</div>
					</div>
				</div>
				
				<div class="col-md-7 mb-3">
					<label for="address1">&nbsp;</label>
					<input type="text" class="form-control" id="address1" name="address1" value="<%=address1%>" required="" readonly>
				</div>
			</div>

			<div class="mb-5">
				<label for="address2">&nbsp;주소</label>
				<input type="text" class="form-control" id="address2" name="address2" value="<%=address2%>" required="">
			</div>
	
			<hr class="mb-5">
			
			<input class="btn btn-dark btn-lg col-md-10" type="submit" value="수정">
			<input class="btn btn-outline-secondary btn-sm col-md-1 float-right" type="button" value="회원탈퇴" onclick="checkResign()">
		
		</div>
		</div>
		</form>
		
	<!-- footer.jsp -->
	<jsp:include page="../include/footer.jsp" />
	
</body>
</html>
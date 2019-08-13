<%@page import="member.MemberDTO"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>CONCERT HALL</title>

<jsp:include page="../include/headlink.jsp"/>
<script type="text/javascript" src="/PROJECT_01/ckeditor/ckeditor.js"></script>	
<%
if((String)session.getAttribute("email") == null) {
%>
	<script>
		alert("로그인 후 이용해주세요.");
		history.back();
	</script>
<% }
	String email = (String) session.getAttribute("email");
	MemberDAO dao = new MemberDAO();
	MemberDTO dto = dao.memberInfo(email);
	String name = dto.getName();
%>

<script type="text/javascript">
	/* 공백 검사 메서드 */
	function checkForm(){
		
		var upFile = document.getElementById("upload").value;
		var content = CKEDITOR.instances.p_content.getData();
		
		 if($("#title").val()==""){
	 		alert("제목을 입력하지 않으셨습니다.");
	 		$("#title").focus();
	 		return false;
	 	}else if($("#password").val()==""){
	 		alert("비밀번호를 입력하지 않으셨습니다.");
	 		$("#password").focus();
	 		return false;
	 	}else if(content == ""){
	 		alert("본문을 입력하지 않으셨습니다.");
	 		return false;
	 	}else if(upFile != ""){
	 		if(!document.getElementById("originalFileName").value){
	 			alert(upFile);
	 			alert("전송하기 버튼을 눌러주십시오.");
	 			document.getElementById("check").focus();
	 			return false;
	 		}	
	 	}else return;
	 }
	
 	/* 파일업로드 */
	function fileUpload(){
		var upFile = document.getElementById("upload").value;
		if(!upFile) alert("첨부 할 파일을 선택 해 주세요.");
		else{
			var open = window.open('about:blank','upload','width=500, height=400');
		    var frm = document.getElementById("fileUploadForm");
		    frm.action = 'upload_rental.jsp';
		    frm.target ="upload";
		    frm.method ="post";
		    frm.submit();
		}
	}
</script>
</head>

<body>
	<!-- header.jsp -->
	<jsp:include page="../include/header.jsp"/>
	
	<div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-light" id="title_back2">
		<div class="col-md-5 p-lg-5 mx-auto my-5">
			<h1 class="display-4 font-weight-normal">대관 신청</h1>
		</div>
	</div>
	
	<div class="ck p-3 mt-5 container">
	
	<!-- 게시글 작성 폼 -->
	<form action="post_rental_proc.jsp" method="post" name="form" onsubmit="return checkForm();">
		<div class="input-group mb-3">
            <div class="input-group-prepend"><span class="input-group-text">
            	제  목 </span></div>
            <input type="text" class="form-control" name="title" id="title">
            
            <div class="input-group-prepend ml-3"><span class="input-group-text">
            	비밀번호</span></div>
            <input type="password" class="form-control col-2" name="password" id="password">
            <input type="submit" class="btn btn-secondary ml-3" value="등록">
            <input type="button" class="btn btn-outline-secondary ml-3" onclick="location.href='board_rental.jsp'" value="목록으로">
        </div>

		<textarea class="form-control" id="p_content" name="content"></textarea>
		 	  <script>CKEDITOR.replace('p_content', {height: 400});</script>
	   	 
	  	<!-- 작성자 이름, 이메일, 업로드된 파일 이름을 전달하는 hidden영역 -->
		<input type="hidden" value="<%=name%>" name="name">
		<input type="hidden" value="<%=email%>" name="email">
		<input type="hidden" value="" name="originalFileName" id="originalFileName">
		<input type="hidden" value="" name="uploadedFileName" id="uploadedFileName">
    </form>
    
    <!-- 파일업로드 폼 -->
    <form action="" method="post" enctype="multipart/form-data" id="fileUploadForm">
     	<div class="input-group mt-3">	
			<div class="input-group-prepend fileUD"><span class="input-group-text">
				첨부파일</span></div>
           	<input type="file" class="col-7 fileUD" name="upload" id="upload">
           	<input type="button" class="ml-2 btn btn-sm btn-outline-secondary" id="uploadBtn" value="전송하기" onclick="fileUpload()">
           	<span class="ml-4" id="check">전송하기 버튼을 눌러주세요.</span>
     	</div>
	</form>
	
	</div>
	
	<!-- footer.jsp -->
	<jsp:include page="../include/footer.jsp" />

</body>
</html>
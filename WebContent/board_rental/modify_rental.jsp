<%@page import="board_rent.BoardDTO"%>
<%@page import="board_rent.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<jsp:include page="../include/headlink.jsp"/>
<script type="text/javascript" src="/PROJECT_01/ckeditor/ckeditor.js"></script>

<jsp:useBean id="dao" class="board_rent.BoardDAO"/>

<%
	request.setCharacterEncoding("UTF-8");

	int no = Integer.parseInt(request.getParameter("no"));
	BoardDTO dto = dao.getContent(no);
	
	String password = dto.getPassword();
%>	

<script type="text/javascript">
	/* 공백검사 */
	function checkForm(){
		
		var upFile = document.getElementById("upload").value;
		var content = CKEDITOR.instances.p_content.getData();
		var db_pwd = <%=password%>;
		
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
	 	}else if($("#password").val() != db_pwd){
	 		alert("비밀번호가 일치하지 않습니다.");
			return false;
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
	
	
	<div class="ck p-3 container mt-5">
	
	<!-- 게시글 수정 폼 -->
	<form action="modify_rental_proc.jsp" method="post" name="form" onsubmit="return checkForm();" >
		<div class="input-group pb-3">
            <div class="input-group-prepend"><span class="input-group-text">
            	제  목</span></div>
            <input type="text" class="form-control" name="title" value="<%=dto.getTitle() %>" required="">
            
            <div class="input-group-prepend ml-4"><span class="input-group-text">
            	비밀번호</span></div>
            <input type="password" class="form-control col-2" id="password" name="password" required="">
            
            <input type="submit" class="btn btn-secondary ml-4" value="수정">
            <input type="button" class="btn btn-outline-secondary ml-3" onclick="javascript:history.back();" value="뒤로">
            <input type="hidden" value="<%=dto.getOriginalFileName() %>" name="originalFileName" id="originalFileName">
      		<input type="hidden" value="<%=dto.getUploadedFileName() %>" name="uploadedFileName" id="uploadedFileName">
            
       		<input type="hidden" value="<%=no %>" name="no">
        </div>
		
		<textarea class="form-control" id="p_content" name="content"><%=dto.getContent() %></textarea>
	   	 	<script>CKEDITOR.replace('p_content', {height: 300}); </script>
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
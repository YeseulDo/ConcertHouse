<%@page import="board_aud.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>CONCERT HALL</title>

<jsp:include page="../include/headlink.jsp"/>
<script type="text/javascript" src="/PROJECT_01/ckeditor/ckeditor.js"></script>	

<jsp:useBean id="dao" class="board_aud.BoardDAO"/>
<%
	if((String)session.getAttribute("email") == null) {
%>
	<script>
		alert("로그인 후 이용해주세요.");
		history.back();
	</script>
<% }
	String email = (String) session.getAttribute("email");

	int no = Integer.parseInt(request.getParameter("no"));
	BoardDTO dto = dao.getContent(no);
	
	String password = dto.getPassword();
%>

<script type="text/javascript">
	/* 이미지업로드 */
	function fileUpload(){
		var upFile = document.getElementById("upload").value;
		if(!upFile) alert("첨부 할 파일을 선택 해 주세요.");
		else{
			var open = window.open('about:blank','upload','width=500, height=400');
		    var frm = document.getElementById("fileUploadForm");
		    frm.action = 'upload_audience.jsp';
		    frm.target ="upload";
		    frm.method ="post";
		    frm.submit();
		}
	}

	function checkForm(){
		var upFile = document.getElementById("upload").value;
		var original_pass = <%=password%>;
		
		 if($("#p_content").val()==""){
	 		alert("내용을 입력하지 않으셨습니다.");
	 		$("p_content").focus();
	 		return false;
	 	}else if($("#p_content").val().length>101){
	 		alert("내용은 100자 이내로 입력하셔야 합니다.");
	 		return false;
	 	}else if($("#password").val()==""){
	 		alert("비밀번호를 입력하지 않으셨습니다.");
	 		$("#password").focus();
	 		return false;
	 	} else if(upFile != ""){
	 		if(!document.getElementById("img").value){
	 			alert(upFile);
	 			alert("이미지 등록 버튼을 눌러주십시오.");
	 			document.getElementById("check").focus();
	 			return false;
	 		}	
	 	} else if($('#password').val()!=original_pass){
	 		alert("비밀번호를 잘 못 입력하셨습니다.");
	 		return false;
	 	}else return;
	 }
	
</script>
</head>

<body>
	<!-- header.jsp -->
	<jsp:include page="../include/header.jsp"/>
	
	<div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-light" id="title_back2">
		<div class="col-md-5 p-lg-5 mx-auto my-5">
			<h1 class="display-4 font-weight-normal">POST_audience</h1>
		</div>
	</div>
	
	<div class="ck p-2 container" id="out">
	<div id="in">
	 
	 <!-- 이미지 업로드 폼 -->
	 <form action="" method="post" enctype="multipart/form-data" id="fileUploadForm">
     	<div class="input-group my-2">	
			<div class="input-group-prepend fileUD">
             	<span class="input-group-text">첨부파일</span>
           	</div>
           	<input type="file" class="col-4 fileUD" name="upload" id="upload">
           	<input type="button" class="ml-1 btn btn-sm btn-outline-secondary" id="uploadBtn" value="사진업로드" onclick="fileUpload()">
     	</div>
	</form>
	
	<!-- 게시글 업로드 폼 -->
	<form action="modify_audience_proc.jsp" method="post" onsubmit="return checkForm();">
		<div class="input-group mb-3">
            <div class="input-group-prepend"><span class="input-group-text fileUD">
            	비밀번호</span></div>
            <input type="password" class="col-3 form-control fileUD" id="password" name="password">
            <input type="submit" class="btn btn-sm btn-secondary ml-1 fileUD" value ="수정">
            <input type="button" class="btn btn-sm btn-outline-secondary ml-1 fileUD" onclick="location.href='board_audience.jsp'"value ="목록으로">
            <input type="hidden" value="<%=dto.getImg() %>" name="img" id="img">
            <input type="hidden" value="<%=dto.getNo()%>" name="no">
        </div>
		<div class="form-control my-3" id="img">
			<span id="check_img"><img width='100%' height='100%' src='upload/<%=dto.getImg()%>'></span>
		</div>	
		<div id="text">		
			<textarea class="form-control" id="p_content" name="content" rows="4" placeholder="내용을 입력하세요:-)"><%=dto.getContent() %></textarea>
    	</div>
    </form>
    
    </div>
	</div>
	
	<!-- footer.jsp -->
	<jsp:include page="../include/footer.jsp" />
</body>
</html>
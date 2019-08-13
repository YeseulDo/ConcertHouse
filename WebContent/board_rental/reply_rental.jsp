<%@page import="member.MemberDTO"%>
<%@page import="board_rent.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<jsp:include page="../include/headlink.jsp"/>
<script type="text/javascript" src="/concerthouse/ckeditor/ckeditor.js"></script>	

<jsp:useBean id="Bdao" class="board_rent.BoardDAO"/>
<jsp:useBean id="Mdao" class="member.MemberDAO"/>

<%
	request.setCharacterEncoding("UTF-8");

	String email = (String) session.getAttribute("email");
	MemberDTO Mdto = Mdao.memberInfo(email);
	
	int original_no = Integer.parseInt(request.getParameter("no"));
	BoardDTO Bdto = Bdao.getContent(original_no);
	
	String parent_content = 
			"<br><br><br>---------------------- Original Post ----------------------<br>"
			+ "<b>작성자</b> : '"+Bdto.getName()+"' ("+Bdto.getEmail()+")<br>"
			+"<b>제목</b> : "+Bdto.getTitle()+"<br>";
%>	

<script type="text/javascript">

	/* 공백검사 */
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
	
	<!-- 답글 작성 폼 -->
	<form action="reply_rental_proc.jsp" method="post" name="form" onsubmit="return checkForm();" >
	
        <div class="input-group mb-3">
            <div class="input-group-prepend"><span class="input-group-text">
            	제  목</span></div>
           <input type="text" class="form-control" name="title" value="RE: <%=Bdto.getTitle() %>" required="">
            
            <div class="input-group-prepend ml-3"> <span class="input-group-text">
            	비밀번호</span></div>
            <input type="password" class="form-control col-2" name="password" id="password">
            <input type="submit" class="btn btn-secondary ml-3" value="등록">
            <input type="button" class="btn btn-outline-secondary ml-3" onclick="javascript:history.back();" value="뒤로">
        </div>
		
		<textarea class="form-control" id="p_content" name="content">
			<%=parent_content %><%=Bdto.getContent() %></textarea>
			<script>CKEDITOR.replace('p_content', {height: 400});</script>
		   	 
	   	<input type="hidden" value="<%=original_no %>" name="no">
   		<input type="hidden" value="<%=Mdto.getName()%>" name="name">
   		<input type="hidden" value="<%=email%>" name="email">
    	
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
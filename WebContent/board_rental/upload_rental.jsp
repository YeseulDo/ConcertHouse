<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 파일업로드
	
	request.setCharacterEncoding("UTF-8");
	
	String realPath = getServletContext().getRealPath("board_rental/upload");
	int maxSize = 1024*1024*5;
	
	MultipartRequest multi = new MultipartRequest(request, realPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
			
	Enumeration en = multi.getFileNames();
	
	
	if(en.hasMoreElements()){
		String fileName = (String) en.nextElement();
		String originalFileName = multi.getOriginalFileName(fileName);
		String uploadedFileName = multi.getFilesystemName(fileName);
%>		
		<script type="text/javascript">
			opener.document.getElementById("originalFileName").value = "<%=originalFileName%>";
			opener.document.getElementById("uploadedFileName").value = "<%=uploadedFileName%>";
			opener.document.getElementById("check").innerHTML = "<font color='green'>파일전송에 성공하였습니다.</font>";
			opener.document.getElementById("uploadBtn").disabled=true;
			window.close();
		</script>
<%		
	}else{
%>		<script type="text/javascript">
			alert("파일전송에 실패하였습니다.");
			window.close();
		</script>
<%	}
%>

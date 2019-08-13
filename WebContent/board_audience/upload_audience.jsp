<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	request.setCharacterEncoding("UTF-8");
	
	String realPath = getServletContext().getRealPath("board_audience/upload");
	int maxSize = 1024*1024*10;
	
	MultipartRequest multi = new MultipartRequest(request, realPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
			
	Enumeration en = multi.getFileNames();
	
	
	if(en.hasMoreElements()){
		String fileName = (String) en.nextElement();
		String originalFileName = multi.getOriginalFileName(fileName);
		String uploadedFileName = multi.getFilesystemName(fileName);
		String imgsrc = "<img width='100%' height='100%' src='upload/"+uploadedFileName+"'>";
%>		
		<script type="text/javascript">
			opener.document.getElementById("img").value = "<%=uploadedFileName%>";
			opener.document.getElementById("check_img").innerHTML = "<%=imgsrc%>";
			window.close();
		</script>
<%		
	}else{
%>		<script type="text/javascript">
			alert("이미지전송에 실패하였습니다.");
			window.close();
		</script>
<%	}
%>

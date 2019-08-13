<%@page import="java.io.BufferedOutputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("Application/x-msdownload");
	
	String path = request.getParameter("path");
	String name = request.getParameter("name");
	
	String realPath = getServletContext().getRealPath("/"+path);
	
	response.setHeader("Content-Disposition", "attachment; fileName=\""+URLEncoder.encode(name, "UTF-8")+"\";");
	
	String fileName = new String(name.getBytes("UTF-8"));
	
	// String fileName = new String(name.getBytes("UTF-8"), "8859_1");
	// http://www.33gram.com/java-java-encoding%EC%9D%B8%EC%BD%94%EB%94%A9%EA%B3%BC-characterset%EC%BA%90%EB%A6%AD%ED%84%B0%EC%85%8B%EC%97%90-%EB%8C%80%ED%95%B4/
	
	File file = new File(realPath+"/"+fileName);
	byte[] data = new byte[1024];
	
	if(file.isFile()){
		try{
			out.clear();
			out=pageContext.pushBody();
			
			BufferedInputStream input = new BufferedInputStream(new FileInputStream(file));
			BufferedOutputStream output = new BufferedOutputStream(response.getOutputStream());
			
			int read;
			
			while((read = input.read(data))!=-1){
				output.write(data, 0, read);
			}
			
			output.flush();
			output.close();
			input.close();
			
		}catch(Exception e){
			e.printStackTrace();			
		}
	}
%>
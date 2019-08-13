<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="bdao" class="board_rent.BoardDAO"/>
<jsp:useBean id="cdto" class="board_rent.CommentDTO"/>
	<jsp:setProperty property="*" name="cdto"/>
<%
	System.out.println(cdto.getComName());
	int result = bdao.addComment(cdto);
	
%>	
<jsp:forward page="content_rental.jsp"/>
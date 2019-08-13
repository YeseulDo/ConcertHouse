<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
	int original_no = Integer.parseInt(request.getParameter("no"));
%>
<jsp:useBean id="dto" class="board_rent.BoardDTO"/>
	<jsp:setProperty property="*" name="dto"/>
<jsp:useBean id="dao" class="board_rent.BoardDAO"></jsp:useBean>
<%
	dao.replyBoard(dto, original_no);
%>	
<jsp:forward page="board_rental.jsp"/>
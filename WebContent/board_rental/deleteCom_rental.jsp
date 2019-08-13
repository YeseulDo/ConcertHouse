<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="dao" class="board_rent.BoardDAO"></jsp:useBean>
<%
	request.setCharacterEncoding("UTF-8");
	int comNo = Integer.parseInt(request.getParameter("comNo"));
	int supNo = Integer.parseInt(request.getParameter("no"));
	
	dao.deleteComment(supNo, comNo);
%>

<jsp:forward page="content_rental.jsp"></jsp:forward>
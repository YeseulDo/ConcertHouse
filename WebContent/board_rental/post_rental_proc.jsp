<%@page import="board_rent.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="dto" class="board_rent.BoardDTO"/>
	<jsp:setProperty property="*" name="dto"/>
<jsp:useBean id="dao" class="board_rent.BoardDAO"/>
<%
	dao.insertBoard(dto);
%>	
<jsp:forward page="board_rental.jsp"/>
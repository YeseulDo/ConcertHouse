<%@page import="board_aud.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="dto" class="board_aud.BoardDTO"/>
	<jsp:setProperty property="*" name="dto"/>
<jsp:useBean id="dao" class="board_aud.BoardDAO"></jsp:useBean>
<%
	dao.insertBoard(dto);
%>	
<jsp:forward page="board_audience.jsp"/>
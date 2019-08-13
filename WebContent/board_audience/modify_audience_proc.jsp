<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="dao" class="board_aud.BoardDAO"/>
<jsp:useBean id="dto" class="board_aud.BoardDTO"/>
	<jsp:setProperty property="*" name="dto"/>
<%
	dao.modifyBoard(dto);
%>	
<jsp:forward page="board_audience.jsp"/>
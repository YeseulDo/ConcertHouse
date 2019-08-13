<%@page import="java.util.ArrayList"%>
<%@page import="member.MemberDTO"%>
<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<header>
	<!-- 상단 navigation bar -->
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
	
	<div class="container">
		<a class="navbar-brand" href="/PROJECT_01/index.jsp">CONCERT HOUSE</a>
			<button class="navbar-toggler collapsed" type="button" data-toggle="collapse"
					data-target="#navbarsExample07" aria-controls="navbarsExample07"
					aria-expanded="false" aria-label="Toggle navigation">
			</button>
	
		<div class="navbar-collapse collapse" id="navbarsExample07" style="">
			<ul class="navbar-nav mr-auto">
				
				<!-- 드롭다운 메뉴 시작 -->
				<li class="nav-item dropdown">
					<a class="nav-link" href="/PROJECT_01/board_rental/board_rental.jsp" id="dropdown02" 
					aria-haspopup="true" aria-expanded="false">
						대관신청
					</a>
				</li>
				<li class="nav-item dropdown">
					<a class="nav-link" href="/PROJECT_01/board_audience/board_audience.jsp" id="dropdown03"
					aria-haspopup="true" aria-expanded="false">
						공연후기
					</a>
				</li>
				
				
				<!-- 드롭다운 메뉴 끝 -->
	
	
			</ul>
			
			<form class="form-inline my-2 my-md-0">
			
<%
				String email = (String) session.getAttribute("email");
				if(email==null||email.length()==0){
%>					<a class="btn btn-sm btn-outline-secondary" href="/PROJECT_01/member/login.jsp">
					LOGIN / SIGN-UP
					</a>
<%				}else{
					MemberDAO dao = new MemberDAO();
					MemberDTO dto = dao.memberInfo(email);
					String name = dto.getName();
					
%>					<span style="color: white;"><b><%=name %></b>님 환영합니다:-)</span>
					<span>&nbsp; &nbsp;</span>
					<a class="btn-sm btn-outline-secondary" href="/PROJECT_01/member/modify.jsp">
					EDIT</a>
					<a class="btn-sm btn-outline-secondary" href="/PROJECT_01/member/logout.jsp">
					LOGOUT</a>					
<%				}
			
%>
				
			</form>
	
		</div>
	</div>
	</nav>
</header>
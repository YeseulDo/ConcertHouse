<%@page import="board_aud.BoardDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>after CONCERT!</title>

<!-- Custom styles for this template -->
<link href="../css/form-validation.css" rel="stylesheet">
<jsp:include page="../include/headlink.jsp"/>
	
<jsp:useBean id="dao" class="board_aud.BoardDAO"/>
	
<%
	request.setCharacterEncoding("UTF-8");
	String check = (String)session.getAttribute("email");
%>

<%
	/* 페이징 */
	int nowPage;
		if(request.getParameter("nowPage")==null) nowPage = 0;
		else nowPage=Integer.parseInt(request.getParameter("nowPage"));
		if(nowPage<1)	nowPage=1;
	
	int recPerPage=6;		// 한 페이지당 보여질 글의 개수
	int pagePerGroup=5;		// 페이지그룹당 묶여질 페이지 개수
	int totalRecord = dao.getTotalRecord(); // 게시판에 저장된 전체 글의 개수
		
	
	int lastRecNum = nowPage*recPerPage; // 현재페이지의 마지막 글 번호
	int startRecNum = lastRecNum - (recPerPage-1); // 현재페이지의 첫 번째 글 번호
		if(lastRecNum>totalRecord)	lastRecNum = totalRecord;
	
	int totalPage = totalRecord / recPerPage + (totalRecord%recPerPage>0 ? 1:0); // 전체페이지 수
		if(nowPage>totalPage) nowPage = totalPage;
		if(totalPage == 0) totalPage=1;
	
	int nowGroup = nowPage / pagePerGroup + (nowPage%pagePerGroup>0 ? 1:0); // 현재 그룹
		if(nowGroup == 0) nowGroup=1;
	int totalGroup = totalPage / pagePerGroup + (totalPage%pagePerGroup>0 ? 1:0); // 전체그룹수
	
	int lastPageNum = nowGroup * pagePerGroup; // 현재 그룹 끝 번호
	int startPageNum = lastPageNum - (pagePerGroup - 1); // 현재 그룹 시작 번호
		if(lastPageNum>totalPage)	lastPageNum = totalPage;
	
	
	int prev_startPage = startPageNum - pagePerGroup; // 이전 그룹 시작 페이지
	int prov_lastPage = prev_startPage + (pagePerGroup-1); // 이전 그룹 마지막 페이지
	int next_startPage = startPageNum + pagePerGroup; // 다음 그룹 시작 페이지

		if(prev_startPage<1)	prev_startPage=1;
		if(next_startPage>totalPage) next_startPage = totalPage/pagePerGroup * pagePerGroup +1;
		
		if(nowPage<1)	nowPage=1;
		
//		out.print(startRecNum+"<br>"+lastRecNum);
%>

<script type="text/javascript">

	function deletePost(no){
		var check = "<%=check%>";
		if(check == "null") {		
			alert("로그인 후 이용해주세요.");
		}else{	
			window.open('delete_audience.jsp?no='+no, '삭제',
			'width=500, height=400, menubar=no, status=no, toolbar=no');
		}
	}

</script>
</head>
<body>
	<!-- header.jsp -->
	<jsp:include page="../include/header.jsp"/>
	
	<div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center" id="title_back">
		<div class="col-md-5 p-lg-5 mx-auto my-5">
			<h1 class="display-4 font-weight-normal">after CONCERT!</h1>
		    <p class="lead font-weight-normal">여러분의 공연 후 이야기를 들려주세요:-)</p>
		    <a class="btn btn-dark" href="post_audience.jsp">글쓰기</a>
		</div>
	</div>

	<div class="container">
	<div class="album py-3">
	<div class="container">
			
		<ul class="pagination justify-content-center my-3" name="pagenation">
			
<% 		if(nowGroup == 1) {}
		else{
%>			<li class="page-item">
				<a class="page-link" href="board_audience.jsp?nowPage=<%=prev_startPage+4%>">◀</a>
			</li>
<%		}	for(int i=startPageNum;i<(lastPageNum+1);i++){
%>		<li class="page-item">
				<a class="page-link" href="board_audience.jsp?nowPage=<%=i%>">
<%		if(nowPage == i){%>	<b><%=i %></b>					
<%		}else{%>	<%=i %>		<%}%>				
				</a>
			</li>	
<%		}

		if(nowGroup == totalGroup){
%>		</ul>
<%		}else{
%>			<li class="page-item">
				<a class="page-link" href="board_audience.jsp?nowPage=<%=next_startPage%>">▶</a>
			</li>
		</ul>		
<%		} %>
	
		<div class="row">
<%		SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
			ArrayList<BoardDTO> boardList = dao.searchBoard(startRecNum, recPerPage);
			
			if(boardList.isEmpty()){
%>			<h1>일치하는 글이 없습니다.</h1>	
<%		}else{
			for(int i=0;i<boardList.size();i++){	
				BoardDTO dto = (BoardDTO) boardList.get(i);
				int no = dto.getNo();
%>			<div class="col-md-4">
	          <div class="card shadow-sm mt-5">
	            <img width="100%" height="225" src='upload/<%=dto.getImg()%>'>
	            <div class="card-body" style="height: 100;">
	              <p id="content_aud" class="card-text"><%=dto.getContent() %></p>
	              <div class="d-flex justify-content-between align-items-center">
	                <div class="btn-group">
	                  <button type="button" onclick="location.href='modify_audience.jsp?no=<%=no %>'" class="btn btn-sm btn-outline-secondary">E</button>
	                  <button type="button" onclick="deletePost(<%=no %>)" class="btn btn-sm btn-outline-secondary">D</button>
	                </div>
	                <small><%=dto.getName()%></small>
	                <small class="text-muted"><%=format.format(dto.getDate())%></small>
	              </div>
	            </div>
	          </div>
	        </div>
<%			}
		}
%>
		</div>
	</div>
	</div>
	</div>
	
	<!-- footer.jsp -->
	<jsp:include page="../include/footer.jsp" />
</body>
</html>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board_rent.BoardDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>BOARD RENTAL</title>

<!-- CSS 및 jQuery 사용관련 링크 -->
<jsp:include page="../include/headlink.jsp"/>
<jsp:useBean id="dao" class="board_rent.BoardDAO"/>
	
<%! String keyField, keyWord; %>
<%
	request.setCharacterEncoding("UTF-8");

	SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
	
  	/* 게시물 검색관련 keyField, keyWord 값 설정 */
 	if(request.getParameter("keyWord")!=null){
		keyField = request.getParameter("keyField");
		keyWord = request.getParameter("keyWord");
	}else{
		keyWord="";
	}
	
  	/* 게시물 검색 후 초기 목록으로 돌아오기 위한 keyWord값 초기화 */
	if(request.getParameter("re_val")!=null){
		if(request.getParameter("re_val").equals("reload")){
			keyWord="";
		}
	}
  	
	/* 페이징 관련 변수 설정 및 초기화 */
	int nowPage;
		if(request.getParameter("nowPage")==null) nowPage = 0;
		else nowPage=Integer.parseInt(request.getParameter("nowPage"));
		if(nowPage<1)	nowPage=1;
		
	int recPerPage=5;		// 한 페이지당 보여질 글의 개수
	int pagePerGroup=5;		// 페이지그룹당 묶여질 페이지 개수
	int totalRecord = dao.getTotalRecord();; // 게시판에 저장된 전체 글의 개수
		if(keyWord != "")	totalRecord = dao.getSearchedRecord(keyField, keyWord);
	
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
	int prev_lastPage = prev_startPage + (pagePerGroup-1); // 이전 그룹 마지막 페이지
	int next_startPage = startPageNum + pagePerGroup; // 다음 그룹 시작 페이지

		if(prev_startPage<1)	prev_startPage=1;
		if(next_startPage>totalPage) next_startPage = totalPage/pagePerGroup * pagePerGroup +1;
		
		if(nowPage<1)	nowPage=1;
		
// out.print("totalRecord"+totalRecord+", totalPage"+totalPage+", totalGroup"+totalGroup+", nowGroup"+nowGroup+", nowPage"+nowPage);
%>
	
<script type="text/javascript">
	
	/* 게시글 제목 클릭 시 해당 글번호 전달*/
	function showContent(no){
		document.content.no.value=no;
		document.content.submit();
	}
	
	/* 검색어(keyWord) 공백 검사 */
	function searchList(){
		if(document.search.keyWord.value!="") document.search.submit();
		else alert("검색어를 입력하세요.");
	}
	
	/* 처음으로 버튼 클릭 시 re_val값 체크 (재요청시 keyWord 초기화) */
	function checkReload(){
		var re = document.reload.re_val.value;
		if(re=="reload"){
			document.reload.action="board_rental.jsp";
			document.reload.submit();
		}
	}
	
</script>

</head>
<body>

	<!-- header.jsp -->
	<jsp:include page="../include/header.jsp"/>
	
	<div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-light" id="title_back">
		<div class="col-md-5 p-lg-5 mx-auto">
			<h1 class="display-4 font-weight-normal">대관신청</h1>
			<p class="lead font-weight-normal my-3">대관안내페이지를 참고하여 <br>대관신청글을 작성 해 주시기 바랍니다.</p>
			<a class="btn btn-dark" href="post_rental.jsp">글쓰기</a>
		</div>
	</div>

	<div class="container mb-5">
		<!-- 게시글 검색 폼 -->
		<form class="form-inline float-right mt-3 mb-4" name="search" action="board_rental.jsp" method="post">
			<select class="custom-select mr-sm-2" id="state" name="keyField" required="">
	              <option value="title">제목</option>
	              <option value="content">내용</option>
	              <option value="name">작성자</option>
	         </select>
	        <input class="form-control mr-sm-2" type="text" placeholder="Search" aria-label="Search" name="keyWord" value="<%=keyWord%>">
	        <button class="btn btn-outline-success my-2 my-sm-0" type="button" onclick="searchList()">Search</button>
	        <button class="btn btn-outline-secondary my-2 my-sm-0 ml-1" type="button" onclick="checkReload()">처음으로</button>
	    </form>
	    
	    <!-- 게시글 검색 목록 초기화를 위한 재요청 여부를 체크하는 폼 -->
		<form name="reload" method="post">
			<input type="hidden" name="re_val" value="reload">
		</form>
		
		<!-- 게시글 목록 출력 테이블 -->
		<table class="table table-hover">
			<thead>
				<tr class="text-center" id="title">
					<th>번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>날짜</th>
					<th>조회수</th>
				</tr>
			</thead>
			<tbody id="tBody">
				<tr>
					<td>*</td>
					<td>대관신청게시판입니다.</td>
					<td>개발자</td>
					<td>2019/05/28</td>
					<td>*</td>
				</tr>
<%
		
		ArrayList<BoardDTO> boardList = dao.searchBoard(keyField, keyWord, startRecNum, recPerPage);


		if(boardList.isEmpty()){
%>				<tr>
					<td colspan='5'>일치하는 글이 없습니다.</td>
				</tr>	
<%		}else{
			 //for(int i=startRecNum-1;i<lastRecNum;i++){
			for(int i=0;i<boardList.size();i++){
				
				BoardDTO dto = (BoardDTO) boardList.get(i);
				
				int repeat = dto.getGroupLay();
				String nbsp = "&nbsp;&nbsp;";
				for(int j=0;j<repeat;j++){
					nbsp += nbsp;
				}
				
%>				<tr>
					<td><%=dto.getNo() %></td>
					<td><a id="content" href="content_rental.jsp" onclick="showContent('<%=dto.getNo() %>'); return false;">
							<%=nbsp%><%=dto.getTitle() %>
					</a></td>
					<td><%=dto.getName() %></td>
					<td><%=format.format(dto.getDate())%></td>
					<td><%=dto.getCount() %></td>
				</tr>
<%			}
		}
%>			</tbody>
		</table>
		
		<!-- 게시글 제목 클릭 시 클릭한 글 번호와 keyWord, keyField를 전달 form -->
		<form action="content_rental.jsp" method="post" name="content">
			<input type="hidden" name="no" value="">
			<input type="hidden" name="keyWord" value="<%=keyWord %>">
			<input type="hidden" name="keyField" value="<%=keyField %>">
		</form>	
	
	
		<!-- 페이징 -->
		<ul class="pagination justify-content-center" name="pagenation">
		
<% 		// ◀ 출력 여부
		if(nowGroup == 1) {}
		else{
%>			<li class="page-item"><a class="page-link" href="board_rental.jsp?nowPage=<%=prev_startPage+4%>">◀</a></li>
<%		}
		for(int i=startPageNum;i<(lastPageNum+1);i++){
%>			<li class="page-item">
				<a class="page-link" href="board_rental.jsp?nowPage=<%=i%>">
<%					if(nowPage == i){%>	<b><%=i %></b>					
<%					}else{%>	<%=i %>		<%}%>				
				</a>
			</li>	
<%		}
		// ▶ 출력 여부
		if(nowGroup == totalGroup){
%>		</ul>
<%		}else{
%>			<li class="page-item">
				<a class="page-link" href="board_rental.jsp?nowPage=<%=next_startPage%>">▶</a>
			</li>
		</ul>		
<%		} %>		

			
	</div>
	
	<!-- footer.jsp -->
	<jsp:include page="../include/footer.jsp" />
	
</body>
</html>
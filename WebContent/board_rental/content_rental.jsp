<%@page import="java.util.ArrayList"%>
<%@page import="board_rent.CommentDTO"%>
<%@page import="member.MemberDAO"%>
<%@page import="member.MemberDTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board_rent.BoardDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>CONCERT HALL</title>

<jsp:include page="../include/headlink.jsp"/>
<script type="text/javascript" src="/PROJECT_01/ckeditor/ckeditor.js"></script>	

<jsp:useBean id="mdao" class="member.MemberDAO"/>
<jsp:useBean id="dao" class="board_rent.BoardDAO"/>
<jsp:useBean id="cdto" class="board_rent.CommentDTO"/>

<%
	request.setCharacterEncoding("UTF-8");
	String email = (String)session.getAttribute("email");
	if(email == null) {
%>	<script>
		alert("로그인 후 이용해주세요.");
		history.back();
	</script>
<% } %>
<%	
	String keyField = request.getParameter("keyField");
	String keyWord = request.getParameter("keyWord");
	SimpleDateFormat format = new SimpleDateFormat("yyyy/MM/dd");
	int no = Integer.parseInt(request.getParameter("no"));
	
	dao.addCount(no);
	BoardDTO dto =  dao.getContent(no);
	
	MemberDTO mdto = mdao.memberInfo(email);
	String mname = mdto.getName();
%>

<script type="text/javascript">
	
	/* 게시글 삭제 체크 */
	function deletePost(){
		window.open('delete_rental.jsp?no=<%=no%>', '삭제',
		'width=500, height=400, menubar=no, status=no, toolbar=no');
	}
	
	/* 목록으로 돌아갈 때 keyword, keyfield값이 포함된 form태그 전송*/
	function returnList(){
		document.returnlist.submit();
	}
	
	/* 댓글 등록 */
	function addComment(){
		var comContent = document.getElementById("comContent").value;
		if(comContent==""){
			alert("댓글 내용을 입력 해 주세요.");
		}else{
			document.getElementById("commentForm").submit();
		}
	}
	
	/* ajax를 이용해 댓글 삭제 후 해당부분만 새로고침 */
	function deleteComment(i){
		var comNo = $("#comNo_"+i).val(); 
		var no = <%=no%>;
		var keyWord = "<%=keyWord%>";
		var keyField = "<%=keyField%>";
		
		$.ajax({
			type : 'POST',
			url  : '/PROJECT_01/DeleteComment',
			async: false,
			data: {supNo: no, comNo: comNo}, 
			success: function(result){
				if(result == "1"){
					alert("삭제되었습니다.");
					$('#refresh').load(document.URL +' #refresh'); }},
			error: function(){
				alert("ERROR!!");
			}
		});
	}
	
</script>

</head>

<body>
	<!-- header.jsp -->
	<jsp:include page="../include/header.jsp"/>
	
	<div class="position-relative overflow-hidden p-3 p-md-5 m-md-3 text-center bg-light" id="title_back2">
		<div class="col-md-5 p-lg-5 mx-auto my-5">
			<h1 class="display-4 font-weight-normal">대관신청</h1>
		</div>
	</div>
	
	<div class="ck p-3 container">
	
		<!-- 수정, 삭제, 답글, 목록으로 버튼 / 해당 글 작성자일 경우에만 수정, 삭제메뉴가 나타나도록 설정 -->
	    <div class="row pb-2">
<%		if(email.equals(dto.getEmail())){
%>			<input type="button" onclick="location.href='modify_rental.jsp?no=<%=dto.getNo() %>'" class="btn btn-sm btn-outline-secondary ml-3" value="수정">
            <input type="button" id="delete" onclick="deletePost()" class="btn btn-sm btn-outline-secondary ml-1 mr-1" value="삭제">
            <input type="button" onclick="location.href='reply_rental.jsp?no=<%=dto.getNo() %>'" class="btn btn-sm btn-outline-secondary mr-1" value="답글">
            <input type="button" onclick="returnList()" class="btn btn-sm btn-outline-secondary" value="목록으로">
<%		}else{
%>			<input type="button" onclick="location.href='reply_rental.jsp?no=<%=dto.getNo() %>'" class="btn btn-sm btn-outline-secondary ml-3" value="답글">
		    <input type="button" onclick="returnList()" class="btn btn-sm btn-outline-secondary ml-1" value="목록으로">
<%		}
%>		</div>	
            
		<!-- 게시글 내용 및 댓글 출력 영역 -->
		<div class="card mb-4 shadow-sm">
		
			<div class="card-header">
				<table width=100%>
					<tr id="contentHeader">
						<td width="60%"><b><%=dto.getTitle() %></b></td>
						<td width="10%"><%=dto.getName() %></td>
						<td width="20%"><%=format.format(dto.getDate())%></td>
						<td width="10%"><%=dto.getCount() %></td>
					</tr>
				</table>
			</div>
			
			<div class="card-body">
<%
			if(dto.getOriginalFileName() != null){
%>				<a href="download_rental.jsp?path=board_rental/upload&name=<%=dto.getUploadedFileName()%>"><%=dto.getOriginalFileName()%></a>
				<br><br>
<%			}
%>				<p class="mb-5"><%=dto.getContent() %></p>
		
				<!-- 댓글영역 -->
				<div id="comment">
				
					<!-- 이전댓글 내용출력 테이블 -->
					<div id="refresh">
					<table id="comTable">
						<tr><td>&nbsp;</td></tr>

<%				ArrayList<CommentDTO> clist = dao.getComment(no);
				if(clist.isEmpty()){
%>					<tr><td colspan="3">등록된 댓글이 없습니다.</td></tr>
<%				} else{
					for(int i=0;i<clist.size();i++){
						cdto = (CommentDTO) clist.get(i);
%>					<tr>
						<td><%=cdto.getComName() %></td>
						<td><%=cdto.getComContent() %></td>
						<td class="text-muted"><%=format.format(cdto.getComDate())%></td>
						<td>
							<a>수정</a>&nbsp;
							<a onclick="deleteComment(<%=i%>); return false;" href="#">삭제</a>
							<input type="hidden" value="<%=cdto.getComNo() %>" id="comNo_<%=i %>">
						</td>
					</tr>	
<%					}
				}
%>					<tr><td>&nbsp;</td></tr>
					</table>
					</div>
					
					<!-- 신규댓글 추가 폼 -->
					<form action="comment_rental.jsp?no=<%=no %>" method="post" id="commentForm">	
						<table id="textarea">
							<tr>
								<td><%=mname %></td>
								<td><textarea class="form-control" rows="2" id="comContent" name="comContent"></textarea></td>
								<td><input type="button" class="btn btn-outline-secondary" value="등록" onclick="addComment()"></td>
							</tr>
						</table>
						
						<input type="hidden" id="comName" name="comName" value="<%=mname%>">
						<input type="hidden" id="supNo" name="supNo" value="<%=no%>">
						<input type="hidden" name="keyWord" value="<%=keyWord %>">
						<input type="hidden" name="keyField" value="<%=keyField %>">
					</form>
				</div>
			</div>
	
			<!-- 목록으로 버튼 클릭 시 전송되는 form -->
			<form action="board_rental.jsp" method="post" name="returnlist">
				<input type="hidden" name="no">
				<input type="hidden" name="keyWord" value="<%=keyWord %>">
				<input type="hidden" name="keyField" value="<%=keyField %>">
			</form>
		
	</div>
	</div>
	
	
	<!-- footer.jsp -->
	<jsp:include page="../include/footer.jsp" />
	
</body>
</html>
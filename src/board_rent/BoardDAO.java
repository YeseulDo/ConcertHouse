package board_rent;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class BoardDAO {
	
	private DataSource pool;
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;

	public BoardDAO() {
		try {
			Context init = new InitialContext();
			this.pool = (DataSource) init.lookup("java:comp/env/jdbc/jspbeginner");
		} catch (Exception e) {
			System.out.println("Error in Connection Pool");
			e.printStackTrace();
		}

	}
	
	/* 자원해제 메서드 */
	public void closeRes() {
		if (this.conn != null) {
			try {
				this.conn.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		if (this.rs != null) {
			try {
				this.rs.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		if (this.pstmt != null) {
			try {
				this.pstmt.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}
	
	/* DB내 총 게시글 수 검색 메서드*/
	public int getTotalRecord(){
		int totalRecord = 0;
		
		try {
			conn = pool.getConnection();
			String sql = "SELECT count(*) as totalRecord FROM p_board_rent";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			rs.next();
			
			totalRecord = rs.getInt("totalRecord");
			
		} catch (Exception e) {
			System.out.println("error in getTotalRecoard()");
			e.printStackTrace();
		} finally{
			closeRes();
		}
		return totalRecord;
	}
	
	public int getSearchedRecord(String keyField, String keyWord){
		
		int totalRecord = 0;
		
		try {
			
			conn = pool.getConnection();
			String sql = "SELECT count(*) as totalRecord FROM p_board_rent WHERE "+keyField+" LIKE '%"+keyWord+"%'";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			rs.next();
			
			totalRecord = rs.getInt("totalRecord");
			
		} catch (Exception e) {
			System.out.println("error in getSearchedRecord()");
			e.printStackTrace();
		} finally {
			closeRes();
		}
		
		return totalRecord;
	}
	
	  
	/* 게시글 목록 검색 메서드 - LIMIT문 사용 
	  	 LIMIT 1, 2 --> 1번째 인덱스위치로부터 2개 출력 
	 */
	public ArrayList<BoardDTO> searchBoard(String keyField, String keyWord, int startRecNum, int recPerPage){
		
		ArrayList<BoardDTO> boardList = new ArrayList<>();
		String sql;
		
		try {
			conn = pool.getConnection();
			
			if(keyWord==null || keyWord.isEmpty()==true){
				sql = "SELECT * FROM p_board_rent ORDER BY groupNo DESC, groupOrd ASC, groupLay ASC"
						+ " LIMIT ?, ?";
				
			}else{
				sql = "SELECT * FROM p_board_rent WHERE "+keyField+" LIKE '%"+keyWord+"%'"
						+ " ORDER BY groupNo DESC, groupOrd ASC, groupLay ASC"
						+ " LIMIT ?, ?";
				
			}
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, startRecNum-1);
			pstmt.setInt(2, recPerPage);
			rs = pstmt.executeQuery();
			
			while(rs.next()){
				
				BoardDTO dto = new BoardDTO();
				dto.setContent(rs.getString("content"));
				dto.setCount(rs.getInt("count"));
				dto.setDate(rs.getTimestamp("date"));
				dto.setEmail(rs.getString("email"));
				dto.setName(rs.getString("name"));
				dto.setNo(rs.getInt("no"));
				dto.setPassword(rs.getString("password"));
				dto.setTitle(rs.getString("title"));
				dto.setGroupLay(rs.getInt("groupLay"));
				dto.setGroupNo(rs.getInt("groupNo"));
				dto.setGroupOrd(rs.getInt("groupOrd"));
				
				boardList.add(dto);
			}
			
		} catch (Exception e) {
			System.out.println("error in searchBoard()");
			e.printStackTrace();
		} finally {
			closeRes();
		}
		
		return boardList;
	}
	
	
	
	/* 게시글 등록 메서드 */
	public void insertBoard(BoardDTO dto) {
		try {
			this.conn = this.pool.getConnection();
			
			String sql = "INSERT INTO p_board_rent"
					+ "(email, name, password, date, title, content, count, groupNo, groupOrd, groupLay, originalFileName, uploadedFileName)"
									+ " VALUES(?,?,?,?,?,?,0,0,0,0,?,?)";
			
			this.pstmt = this.conn.prepareStatement(sql);
			
			this.pstmt.setString(1, dto.getEmail());
			this.pstmt.setString(2, dto.getName());
			this.pstmt.setString(3, dto.getPassword());
			this.pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
			this.pstmt.setString(5, dto.getTitle());
			this.pstmt.setString(6, dto.getContent());
			this.pstmt.setString(7, dto.getOriginalFileName());
			this.pstmt.setString(8, dto.getUploadedFileName());
			
			this.pstmt.executeUpdate();
			
			sql = "SELECT no FROM p_board_rent ORDER BY no desc";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			rs.next();
			int no = rs.getInt(1);
			
			sql = "UPDATE p_board_rent SET groupNo=? WHERE no=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, no);
			pstmt.setInt(2, no);
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("Error in insertBoard()");
			e.printStackTrace();
		} finally {
			this.closeRes();
		}

	}
	
	/* 조회수 증가 메서드 */
	public void addCount(int no){
		
		try {
			conn = pool.getConnection();
			String sql = "UPDATE p_board_rent SET count=count+1 WHERE no="+no;
			pstmt = conn.prepareStatement(sql);
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("error in addCount");
			e.printStackTrace();
		} finally {
			closeRes();
		}
		
		
	}
	
	/* 개별 게시글 내용 출력 메서드 */
	public BoardDTO getContent(int no){
		BoardDTO dto = new BoardDTO();
		
		try {
			conn = pool.getConnection();
			
			String sql = "SELECT * FROM p_board_rent WHERE no=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, no);
			
			rs = pstmt.executeQuery();
			
			rs.next();
			
			dto.setContent(rs.getString("content"));
			dto.setCount(rs.getInt("count"));
			dto.setDate(rs.getTimestamp("date"));
			dto.setEmail(rs.getString("email"));
			dto.setName(rs.getString("name"));
			dto.setNo(rs.getInt("no"));
			dto.setPassword(rs.getString("password"));
			dto.setTitle(rs.getString("title"));
			dto.setGroupLay(rs.getInt("groupLay"));
			dto.setGroupNo(rs.getInt("groupNo"));
			dto.setGroupOrd(rs.getInt("groupOrd"));
			dto.setOriginalFileName(rs.getString("originalFileName"));
			dto.setUploadedFileName(rs.getString("uploadedFileName"));
		
			
		} catch (Exception e) {
			System.out.println("error in getContent()");
			e.printStackTrace();
		} finally {
			closeRes();
		}
		
		return dto;
	}
	
	/* 게시글 수정 메서드 */
	public void modifyBoard(BoardDTO dto){
		
		try {
			conn = pool.getConnection();
			
			String sql = "UPDATE p_board_rent SET title=?, content=?, originalFileName=?, uploadedFileName=?  WHERE no=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setString(3, dto.getOriginalFileName());
			pstmt.setString(4, dto.getUploadedFileName());
			pstmt.setInt(5, dto.getNo());
			
			
			pstmt.executeUpdate();
			
			
		} catch (Exception e) {
			System.out.println("error in modifyBoard()");
			e.printStackTrace();
		}finally {
			closeRes();
		}
		
	}
	
	/* 게시물 삭제 메서드 */
	public void deleteBoard(int no){
		try {
			conn = pool.getConnection();
			String sql = "DELETE FROM p_board_rent WHERE no=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, no);
			
			pstmt.executeUpdate();
					
		} catch (Exception e) {
			System.out.println("error in deleteBoard()");
			e.printStackTrace();
		}finally {
			closeRes();
		}
	}
	
	/* 게시글 답글 등록 메서드 */
	public void replyBoard(BoardDTO dto, int original_no){
		
		try {

			BoardDTO o_dto = getContent(original_no);
            
            int groupNo = o_dto.getGroupNo();
            int groupOrd = o_dto.getGroupOrd();
            int groupLay = o_dto.getGroupLay();
            
            conn = pool.getConnection();
            
            String sql = "UPDATE p_board_rent SET groupOrd = groupOrd+1"
                  + " WHERE groupNo = ? AND groupOrd > ?";
            
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, groupNo);
            pstmt.setInt(2, groupOrd);
            
            pstmt.executeUpdate();
            
            
            sql = "INSERT INTO p_board_rent"
                  + "(email, name, password, date, title, content, count, groupNo, groupOrd, groupLay)"
                              + " VALUES(?,?,?,?,?,?,0,?,?,?)";
         
	         pstmt = conn.prepareStatement(sql);
	         
	         pstmt.setString(1, dto.getEmail());
	         pstmt.setString(2, dto.getName());
	         pstmt.setString(3, dto.getPassword());
	         pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
	         pstmt.setString(5, dto.getTitle());
	         pstmt.setString(6, dto.getContent());
	         pstmt.setInt(7, groupNo);
	         pstmt.setInt(8, groupOrd+1);
	         pstmt.setInt(9, groupLay+1);
	         
	         pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("error in replyBoard()");
			e.printStackTrace();
			
		}finally {
			closeRes();
		}
		
	}
	
	/* 게시글 댓글 등록 메서드 */
	public int addComment(CommentDTO cdto){
		
		int result = 0;
		
		try {
			conn = pool.getConnection();
			String sql = "INSERT INTO p_comment_rent(supNo, comName, comDate, comContent)"
					+ " VALUES(?,?,?,?)";
			pstmt = conn.prepareStatement(sql);
			
			pstmt.setInt(1, cdto.getSupNo());
			pstmt.setString(2, cdto.getComName());
			pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
			pstmt.setString(4, cdto.getComContent());
			
			pstmt.executeUpdate();
			result = 1;
			
			
			
		} catch (Exception e) {
			System.out.println("error in addComment1()");
			e.printStackTrace();
			
		}finally {
			closeRes();
		}
		
		return result;
	}
	
	
	/* 댓글 출력 메서드 */
	public ArrayList<CommentDTO> getComment(int supNo){
		
		ArrayList<CommentDTO> list = new ArrayList<>();
		CommentDTO cdto = null;
		
		try {
			conn = pool.getConnection();
			String sql = "SELECT * FROM p_comment_rent WHERE supNo=? ORDER BY comNo";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, supNo);
			
			rs = pstmt.executeQuery();
			
			while(rs.next()){
			
				cdto = new CommentDTO();
				cdto.setComContent(rs.getString("comContent"));
				cdto.setComName(rs.getString("comName"));
				cdto.setComNo(rs.getInt("comNo"));
				cdto.setComDate(rs.getTimestamp("comDate"));
				cdto.setSupNo(rs.getInt("supNo"));
				
				list.add(cdto);
			}
			
		} catch (Exception e) {
			System.out.println("error in getComment()");
			e.printStackTrace();
			
		}finally {
			closeRes();
		}
		
		return list;
	}
	
	/* 댓글 삭제 메서드 */
	public int deleteComment(int supNo, int comNo){
		
		int result = 0;
		
		try {
			conn = pool.getConnection();
			String sql = "DELETE FROM p_comment_rent WHERE supNo=? AND comNo=?";
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, supNo);
			pstmt.setInt(2, comNo);
			
			pstmt.executeUpdate();
			result = 1;
					
		} catch (Exception e) {
			System.out.println("error in deleteComment()");
			e.printStackTrace();
		}finally {
			closeRes();
		}
		
		return result;
	}
}
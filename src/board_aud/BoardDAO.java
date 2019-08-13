package board_aud;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
			String sql = "SELECT count(*) as totalRecord FROM p_board_aud";
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
	
	  
	/* 게시글 목록 검색 메서드 - LIMIT문 사용 
	  	 LIMIT 1, 2 --> 1번째 인덱스위치로부터 2개 출력 
	 */
	public ArrayList<BoardDTO> searchBoard(int startRecNum, int recPerPage){
		
		ArrayList<BoardDTO> boardList = new ArrayList<>();
		String sql;
		
		try {
			conn = pool.getConnection();
			
			sql = "SELECT * FROM p_board_aud ORDER BY no DESC"+ " LIMIT ?, ?";
			
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
				dto.setImg(rs.getString("img"));
				dto.setUploadedFileName(rs.getString("uploadedFileName"));
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
			
			String sql = "INSERT INTO p_board_aud"
					+ "(email, name, password, date, img, content, count, uploadedFileName)"
									+ " VALUES(?,?,?,?,?,?,0,?)";
			
			this.pstmt = this.conn.prepareStatement(sql);
			
			this.pstmt.setString(1, dto.getEmail());
			this.pstmt.setString(2, dto.getName());
			this.pstmt.setString(3, dto.getPassword());
			this.pstmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
			this.pstmt.setString(5, dto.getImg());
			this.pstmt.setString(6, dto.getContent());
			this.pstmt.setString(7, dto.getUploadedFileName());
			
			this.pstmt.executeUpdate();
			
			
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
			String sql = "UPDATE p_board_aud SET count=count+1 WHERE no="+no;
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
			
			String sql = "SELECT * FROM p_board_aud WHERE no=?";
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
			dto.setImg(rs.getString("img"));
			dto.setUploadedFileName(rs.getString("uploadedFileName"));
		
			
		} catch (Exception e) {
			System.out.println("error in getContent()");
			e.printStackTrace();
		} finally {
			closeRes();
		}
		
		return dto;
	}
	
//	 게시글 수정 메서드 
	public void modifyBoard(BoardDTO dto){
		
		try {
			conn = pool.getConnection();
			
			String sql = "UPDATE p_board_aud SET img=?, content=? WHERE no=?"; 
			
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getImg());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getNo());
			
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
			String sql = "DELETE FROM p_board_aud WHERE no=?";
			
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
	
	
}
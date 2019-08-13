package board_rent;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/DeleteComment")
public class DeleteComment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		
		BoardDAO dao = new BoardDAO();
		
		
		int comNo = Integer.parseInt(request.getParameter("comNo"));
		int supNo = Integer.parseInt(request.getParameter("supNo"));
		
		int result = dao.deleteComment(supNo, comNo);
		
		response.getWriter().write(result+"");
		System.out.println(result);
	
	}

}

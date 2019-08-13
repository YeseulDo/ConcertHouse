package board_rent;

import java.sql.Timestamp;

public class CommentDTO {
	
	private int comNo, supNo;
	private String comName, comContent;
	private Timestamp comDate;
	
	public int getComNo() {
		return comNo;
	}
	public void setComNo(int comNo) {
		this.comNo = comNo;
	}
	public int getSupNo() {
		return supNo;
	}
	public void setSupNo(int supNo) {
		this.supNo = supNo;
	}
	public String getComName() {
		return comName;
	}
	public void setComName(String comName) {
		this.comName = comName;
	}
	public String getComContent() {
		return comContent;
	}
	public void setComContent(String comContent) {
		this.comContent = comContent;
	}
	public Timestamp getComDate() {
		return comDate;
	}
	public void setComDate(Timestamp comDate) {
		this.comDate = comDate;
	}
	
	
}

package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("LoanHistory")
public class LoanHistory {
	private int no;
	private Date loanDate;
	private Date returnDate;
	private Date dueDate;
	private String loanStatus;
	private User user;
	private Library library;
	private Book book;
	private String isExtension;
}

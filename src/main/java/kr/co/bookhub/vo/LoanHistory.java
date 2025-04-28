package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("LoanHistory")
public class LoanHistory {
	int no;
	Date loanDate;
	Date returnDate;
	Date dueDate;
	String loanStatus;
	User user;
	Library library;
	Book book;
	String isExtension;
}

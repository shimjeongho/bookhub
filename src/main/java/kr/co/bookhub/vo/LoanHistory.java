package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("LoanHistory")
public class LoanHistory {
	private int no; 
	private Date date; 
	private Date returnDate;
	private Date dueDate;
	private User user; // user_id를 참조
	private Library library;// lib_no를 참조 
	private Book book;// book_no를 참조 
	private String isExtension;
}

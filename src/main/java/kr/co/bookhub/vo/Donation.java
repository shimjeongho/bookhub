package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@Alias("Donation")
public class Donation {
	private int no;
	private String title;
	private String author;
	private String publisher;
	private String description;
	private Date createdDate;
	private Date updatedDate;
	private String isDeleted;
	private User user;
	private Library library;
}

package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@Alias("BookReview")
public class BookReview {

	private int no;
	private String id;
	private String content;
	private int star;
	private int likes;
	private String title;
	private Date createdDate;
	private Date updatedDate;
	private String isDeleted;
	private User writer;
	private Book book;
}

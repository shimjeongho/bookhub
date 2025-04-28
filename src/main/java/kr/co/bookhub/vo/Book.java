package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("Book")
public class Book {
	int no;
	String title;
	String author;
	String publisher;
	String description;
	Date pubDate;
	int reviewAvg;
	String coverImage;
	Date createdDate;
	Date updatedDate;
	String isbn;
	Category category;
	
}

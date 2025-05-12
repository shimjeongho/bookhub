package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;


@Alias("Book")
@Getter
@Setter
@NoArgsConstructor
public class Book {
	private int no;
	private String title;
	private String author;
	private String publisher;
	private String description;
	private Date pubDate;
	private int reviewCount;
	private double reviewAvg;
	private String coverImagePath;
	private Date createdDate;
	private Date updatedDate;
	private String isbn;
	private Category category;
}

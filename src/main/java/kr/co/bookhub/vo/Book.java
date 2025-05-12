package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("Book")
public class Book {

	private int no; 
 	private String title; 
 	private String author; 
 	private String publisher; 
 	private String description; 
 	private String pubDate;
 	private int reviewCount; 
 	private double reviewAvg; 
 	private String coverImagePath; 
 	private Date createdDate; 
 	private Date updatedDate; 
 	private String isbn; 
 	private Category category;
  
}

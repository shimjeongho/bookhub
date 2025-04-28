package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
@Getter
@Setter
@NoArgsConstructor
@Alias("Post")
public class Post {
	private int No; 
	private String title; 
	private String content; 
	private int viewCnt; 
	private Date createdDate; 
	private Date updatedDate; 
	private String isDeleted; 
	private String isPublic; 
	private User user; // user_id 
	private Book book; // book_no; 
	private PostCategory postCategoy; // post_cate_no; 

}

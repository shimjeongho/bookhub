package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("PostReply")
public class PostReply {
	private int no; 
	private PostReply postReply; // parent_no
	private String content; 
	private Date createdDate; 
	private Date updatedDate; 
	private String isDeleted; 
	private User user;  // user_id
	private Post post; // post_no
	
}

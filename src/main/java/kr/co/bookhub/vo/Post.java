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
	private int no; // 게시물 번호
	private String title; // 게시물 제목
	private String content; // 게시물 내용 
	private int viewCnt; // 조회 수
	private Date createdDate; // 생성된 날짜
	private Date updatedDate; // 수정된 날짜
	private String isDeleted; // 삭제 여부
	private String isPublic; // 공개 여부
	private User user; // user_id 
	private Book book; // book_no; 
	private Library library;
	private PostCategory postCategory; // post_cate_no; 

}

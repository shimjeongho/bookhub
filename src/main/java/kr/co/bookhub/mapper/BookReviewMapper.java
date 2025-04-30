package kr.co.bookhub.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.bookhub.vo.BookReview;

public interface BookReviewMapper {

	void insertBookReview(BookReview bookreview);
	
	int getTotalRows(int bookNo);
	
	List<BookReview> getAllBookReviewsByUserId(String userId);
	
	List<BookReview> getBookReviewsByBookNo(@Param("bookNo") int bookNo);
	
	
}

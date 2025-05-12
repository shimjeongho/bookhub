package kr.co.bookhub.mapper;

import java.util.List;
import java.util.Map;

import kr.co.bookhub.vo.BookReview;

public interface BookReviewMapper {

	/**
	 * 새 도서리뷰정보를 전달받아서 테이블에 추가한다.
	 * @param bookreview 도서리뷰정보
	 */
	void insertBookReview(BookReview bookreview);
	
	/**
	 * 책번호를 전달받아서 해당 도서의 리뷰개수를 조회해서 반환한다.
	 * @param bookNo 책 번호
	 * @return 리뷰개수
	 */
	int getTotalRows(int bookNo);
	
	List<BookReview> getAllBookReviewsByUserId(String userId);
	
	/**
	 * 도서의 리뷰 목록
	 * @param condition 
	 * @return 리뷰 목록
	 */
	List<BookReview> getBookReviewsByBookNo(Map<String, Object> condition);
	
	/**
	 * 리뷰 is_deleted 'Y'로 교체
	 * @param reviewNo 리뷰 번호
	 */
	void updateReview(int reviewNo);

	/**
	 * 리뷰 총점
	 * @param bookNo 책 번호
	 * @return 도서의 리뷰 평점 총점
	 */
	int getTotalReviewScore(int bookNo);

	
}

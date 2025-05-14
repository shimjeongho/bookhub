package kr.co.bookhub.mapper;

import java.util.List;

import kr.co.bookhub.vo.Book;

public interface BookMapper {

	/**
	 * 책 정보 조회
	 * @param no 책 번호
	 * @return 책 정보
	 */
	Book getBookByNo(int no);
	/**
	 * 책 리뷰 개수와 수정날짜, 리뷰 평균 평점 변경
	 * @param book 업데이트된 책 정보
	 */
	void updateBook(Book book);
	
	//세션으로 찜정보 정보 가져오기
	List<Book> getMyWishListBooks(String userId);
}

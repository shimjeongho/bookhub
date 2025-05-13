package kr.co.bookhub.mapper;

import kr.co.bookhub.vo.Book;

public interface BookMapper {

	/**
	 * 책 정보 조회
	 * @param no 책 번호
	 * @return
	 */
	Book getBookByNo(int no);
	/**
	 * 책 리뷰 개수와 수정날짜 변경
	 * @param book 책
	 */
	void updateBook(Book book);
}

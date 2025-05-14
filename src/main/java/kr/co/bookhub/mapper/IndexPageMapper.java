package kr.co.bookhub.mapper;

import java.util.List;

import kr.co.bookhub.vo.Book;
import kr.co.bookhub.vo.Donation;

public interface IndexPageMapper {

	/**
	 * 최근 출판된 책 20개 조회
	 * @return book 형식의 리스트
	 */
	List<Book> getBooksForIndexPage();
	
	/**
	 * 최근 기증된 책 20개 조회
	 * @return
	 */
	List<Donation> getDonationBooksForIndexPage();
	
}

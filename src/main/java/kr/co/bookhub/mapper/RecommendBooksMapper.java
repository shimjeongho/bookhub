package kr.co.bookhub.mapper;

import java.util.List;

import kr.co.bookhub.vo.Book;

public interface RecommendBooksMapper {

	/**
	 * 로그인 유저의 대여 도서 정보로 맞춤 도서 목록 가져오기
	 * @param userId 로그인 유저 아이디
	 * @return 맞춤 도서 목록
	 */
	List<Book> getRecommendBooksByUserId(String userId);
	
}

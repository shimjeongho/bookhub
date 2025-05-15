package kr.co.bookhub.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.bookhub.vo.Book;

public interface RecommendBooksMapper {
	
	/**
	 * 로그인 유저의 대여/찜 도서 목록 개수 조회
	 * @param userId 로그인 유저 아이디
	 * @return 대여 목록 개수
	 */
	int getTotalLoanHistoryAndWishlistRows(String userId);

	/**
	 * 로그인 유저의 대여/찜 도서 정보로 맞춤 도서 목록 가져오기
	 * @param userId 로그인 유저 아이디
	 * @param userLoanAndWishlistCnt 로그인 유저가 대여/찜한 도서 개수
	 * @return 맞춤 도서 목록
	 */
	List<Book> getRecommendBooksByUserId(@Param("userId") String userId
										,@Param("userLoanAndWishlistCnt") int userLoanAndWishlistCnt);
	
}

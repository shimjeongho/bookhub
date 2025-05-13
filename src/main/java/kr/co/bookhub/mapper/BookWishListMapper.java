package kr.co.bookhub.mapper;

import java.util.Map;

public interface BookWishListMapper {
	
	/**
	 * 찜하기 여부
	 * @param condition
	 * @return 1(찜하기 중), 0(찜 취소) count(*)은 안좋다
	 */
	int isBookWish(Map<String, Object> condition);

	/**
	 * 찜하기
	 * @param condition 찜 추가목록
	 */
	void addWishList(Map<String, Object> condition);
	
	/**
	 * 찜하기 취소
	 * @param condition 찜 취소목록
	 */
	int removeWishList(Map<String, Object> condition);
	
}

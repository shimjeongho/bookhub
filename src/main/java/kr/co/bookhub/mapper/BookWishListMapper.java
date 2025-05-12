package kr.co.bookhub.mapper;

import java.util.Map;

public interface BookWishListMapper {
	
	int isWished(Map<String, Object> condition);

	/**
	 * 찜하기
	 * @param condition 찜 추가목록
	 */
	void addWishList(Map<String, Object> condition);
	
	/**
	 * 찜하기 취소
	 * @param condition 찜 취소목록
	 */
	void removeWishList(Map<String, Object> condition);
	
}

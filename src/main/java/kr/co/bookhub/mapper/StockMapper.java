package kr.co.bookhub.mapper;

import org.apache.ibatis.annotations.Param;

public interface StockMapper {

	/**
	 * 책번호와 도서관 번호를 받아서 해당 도서의 재고를 업데이트한다.
	 * @param bno 책번호
	 * @param lno 도서관번호
	 */
	void updateStock(@Param("bno") String bno, @Param("lno") String lno);
}

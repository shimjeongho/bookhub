package kr.co.bookhub.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

public interface StockMapper {

	/**
	 * 책번호와 도서관 번호를 받아서 해당 도서의 재고를 업데이트한다.
	 * @param bno 책번호
	 * @param lno 도서관번호
	 */
	void updateStock(@Param("bno") String bno, @Param("lno") String lno);
	
	/**
	 * 책번호와 도서관 번호를 받아서 해당 도서의 수량이 몇개인지 받아온다.
	 * @param bno
	 * @param lno
	 * @return
	 */
	int getBookStockCount(@Param("bno") String bno, @Param("lno") String lno); 
	
	/**
	 * 특정 도서 번호를 전달받아 모든 도서관 재고를 체크한다
	 * @param bookNo 책번호
	 * @return 특정 도서 번호의 대한 모든 도서관 재고 체크
	 */
	int getBookAvailability(int bookNo); 	
}

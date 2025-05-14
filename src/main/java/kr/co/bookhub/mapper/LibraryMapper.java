package kr.co.bookhub.mapper;

import java.util.List;
import java.util.Map;

import kr.co.bookhub.vo.Library;
import kr.co.bookhub.vo.Stock;

public interface LibraryMapper {

	/**
	 * 도서관 정보 조회
	 * @param no 도서관 번호
	 * @return 도서관 정보
	 */
	Library getLibraryByNo(int no);
	
	/**
	 * 도서 번호를 이용하여 도서관 책 재고 조회
	 * @param bookNo 도서 번호
	 * @return 도서관 번호, 이름, 도서 재고 수 
	 */
	List<Stock> getLibraryStocksByBookNo(int bookNo);
}

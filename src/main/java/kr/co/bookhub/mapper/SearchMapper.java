package kr.co.bookhub.mapper;

import java.util.List;
import java.util.Map;

import kr.co.bookhub.vo.Book;


public interface SearchMapper {

	/**
	 * 검색정보, 검색옵션, 정렬, 페이지 정보를 가져와서 도서 정보를 반환한다.
	 * @param condition
	 * @return
	 */
	List<Book> searchBooks(Map<String, Object> condition);
	
	/**
	 * 검색정보, 검색옵션, 정렬, 페이지 정보를 가져와서 데이터의 갯수를 조회한다.
	 * @param condition
	 * @return
	 */
	int getTotalRows(Map<String, Object> condition);
}

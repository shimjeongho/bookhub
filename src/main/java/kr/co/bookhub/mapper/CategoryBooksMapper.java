package kr.co.bookhub.mapper;

import java.util.List;
import java.util.Map;

import kr.co.bookhub.vo.Book;
import kr.co.bookhub.vo.Category;

public interface CategoryBooksMapper {

	/**
	 * 대분류 목록 가져오기
	 * @return 대분류 목록
	 */
	List<Category> getMainCategory();
	
	/**
	 * 특정 대분류 정보 가져오기
	 * @param cateNo 대분류 번호
	 * @return 카테고리 정보
	 */
	Category getCategory(int cateNo);
	
	/**
	 * 대분류 번호를 전달받아 대분류에 속한 하위 분류 목록 가져오기
	 * @param cateNo 대분류 번호
	 * @return 대분류에 속한 하위 분류 목록
	 */
	List<Category> getSubCategory(int cateNo);
	
	/**
	 * 조건에 맞는 모든 데이터 개수 가져오기
	 * @param condition.cateNo 대분류 번호
	 * @param condition.subCateNo 대분류에 속한 하위 분류 번호(선택하지 않으면 0)
	 * @param condition.searchPart 검색 조건
	 * @param condition.searchStr 검색어
	 * @param condition.keywords 검색어 키워드
	 * @return 조회된 모든 데이터 개수
	 */
	int getTotalRows(Map<String, Object> condition);
	
	/**
	 * 대분류에 속한 하위분류 번호로 도서 목록 가져오기
	 * @param condition.cateNo 대분류 번호
	 * @param condition.subCateNo 대분류에 속한 하위 분류 번호(선택하지 않으면 0)
	 * @param condition.offset 요청페이지 offset 값 
	 * @param condition.rows 요청페이지의 데이서 개수 
	 * @param condition.sort 정렬조건
	 * @param condition.searchPart 검색 조건
	 * @param condition.searchStr 검색어
	 * @param condition.keywords 검색어 키워드
	 * @return 도서 목록
	 */
	List<Book> getBooksByCategoryAndKeywords(Map<String, Object> condition);
	
}

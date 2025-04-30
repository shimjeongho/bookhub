package kr.co.bookhub.mapper;

import java.util.List;

import kr.co.bookhub.vo.Book;
import kr.co.bookhub.vo.Category;

public interface CategoryBooksMapper {

	/**
	 * 대분류 목록 가져오기
	 * @return 대분류 목록
	 */
	List<Category> getMainCategory();
	
	/**
	 * 대분류 번호를 전달받아 대분류에 속한 하위 분류 목록 가져오기
	 * @param categoryNo 대분류 번호
	 * @return 대분류에 속한 하위 분류 목록
	 */
	List<Category> getSubCategory(int categoryNo);
	
	/**
	 * 대분류에 속한 하위분류 번호로 도서 목록 가져오기
	 * @param mainCateNo 대분류 번호
	 * @param subCateNo 대분류에 속한 하위 분류 번호(선택하지 않으면 0)
	 * @return 도서 목록
	 */
	List<Book> getBooksByCategory(int mainCateNo, int subCateNo);
	
	/**
	 * 카테고리, 검색어를 전달받아 도서 목록 가져오기
	 * @param categoryNo 카테고리 번호
	 * @param searchStr 검색어
	 * @return 조회된 도서 목록
	 */
	List<Book> searchBooks(int categoryNo, String searchStr);
	
}

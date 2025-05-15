package kr.co.bookhub.mapper;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import kr.co.bookhub.vo.LoanHistory;

public interface LoanBookMapper {

	/**
	 * 사용자의 아이디를 통해 해당 유저가 빌린 책의 목록을 반환한다.
	 * @param id
	 * @return 해당 유저가 빌린 책의 목록이 다 조회된다.
	 */
	List<LoanHistory> getAllBookByUserId(String id);
	
	
	List<LoanHistory> getSortedLoanBooksByUserId(Map<String, Object> condition);
	
	
	List<LoanHistory> getSortedReturnBooksByUserId(Map<String, Object> condition);
	
	List<LoanHistory> getAllReturnBooks();
	
	
	/**
	 * 모든 행의 갯수를 조회한다.
	 * @param condition
	 * @return
	 */
	int getLoanTotalRows(String id);
	
	/**
	 * 반납한 책의 모든 행의 갯수를 조회한다.
	 * @param id
	 * @return
	 */
	int getReturnTotalRows(String id);
	
	
	/**
	 * 사용자의 아이디를 통해 해당 유저가 연체한 책의 상태("L" -> "D")를 업데이트한다.
	 * @param id
	 */
	void updateDelayBooksStatus(String id);
	
	void updateReturnBook(String lno);
	
	/**
	 * 사용자 아이디를 통해 해당 유저가 빌린 책 중에 연체중인 도서의 목록을 반환한다.
	 * @param id
	 * @return
	 */
	List<LoanHistory> getDelayBookByUserId(String id);
	
	/**
	 * 대여번호(LoanNo)를 통해 대여내역테이블에서 도서대여이력을 조회한다.
	 * @param lno
	 * @return 대여번호를 통해 해당 도서가 조회된다.
	 */
	LoanHistory getLoanHistoryByLoanNo(String lno);
	
	/**
	 * 도서 번호를 통해 해당 유저가 빌린 혹은 반납신청한 도서를 가져온다.
	 * @param bno
	 * @return
	 */
	LoanHistory getLoanHistoryByIdAndBno(@Param("id") String id, @Param("bno") String bno);
	
	/**
	 * 대여번호(LoanNo)를 통해 대여내역테이블에서 대여상태, 반납일을 업데이트한다.
	 * @param lno
	 */
	void updateIsExtensionAndDueDateByLoanNo(String lno);
	
	
	void InsertLoanHistoryByBnoAndRnoAndId(@Param("id") String id, @Param("lno") String lno, @Param("bno") String bno);

	/**
	 * 사용자의 아이디를 통해 반납처리중인 도서의 목록을 반환한다.
	 * @param id
	 * @return 반납처리중인 도서의 목록을 반환한다.
	 */
	List<LoanHistory> getReturnBookByUserId(String id);
	
	/**
	 * 대여내역테이블의 번호를 통해 반납처리중인 도서를 반환한다
	 * @param lno
	 * @return 반납처리중인 도서를 반환한다.
	 */
	LoanHistory getReturnBookByLoanNo(String lno);
	
	/**
	 * 대여내역테이블의 번호를 통해 대여상태를 변경한다.
	 * @param lno
	 */
	void updateLoanStatusAndreturnDateByLoanNo(String lno);
	
}

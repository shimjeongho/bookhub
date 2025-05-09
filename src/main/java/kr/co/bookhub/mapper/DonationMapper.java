package kr.co.bookhub.mapper;

import java.util.List;

import kr.co.bookhub.vo.Donation;
import kr.co.bookhub.vo.Library;

public interface DonationMapper {

	/**
	 * 모든 도서관 정보 가져오기
	 * @return
	 */
	List<Library> getAllLibrary();
	
	/**
	 * 기부 정보를 전달받아서 해당 기부 테이블을 업데이트한다.
	 * @param donation
	 */
	void insertDonationBook(Donation donation);
	
	/**
	 * 모든 기부 정보 가져오기
	 * @return
	 */
	List<Donation> getAllDonation();
	
}

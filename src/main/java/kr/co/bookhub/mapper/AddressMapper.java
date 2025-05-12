package kr.co.bookhub.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import kr.co.bookhub.vo.Address;

public interface AddressMapper {

	/**
	 * 주소를 추가하는 메소드
	 * @param address
	 */
	void insertAddress(Address address);
	
	/**
	 * 유저아이디를 통해 유저 모든 주소를 가져옴
	 * @param id
	 * @return
	 */
	List<Address> getAllAddressByUserId(String id);
	
	Address getGibonAddressByUserId(String id);
	
	/**
	 * 유저아이디와 주소번호 값을 통해 해당 주소를 가져옴
	 * @param id
	 * @return
	 */
	Address getAddressByUserIdAndNo(@Param("id") String id, @Param("no") String no);
	
	/**
	 * Id를 통해 기본이 "Y" 인 주소를 가져온다.
	 * @param id
	 * @return
	 */
	Address getGibonAddressByIdAndNo(@Param("id") String id, @Param("no") int no);
	
	/**
	 * 아이디를 통해 No값을 기준으로 가장 숫자가 작은 값의 주소를 하나 가져온다.
	 * @return
	 */
	Address getAddressOrderByNoById();
	
	/**
	 * Address객체를 통해 gibon을 'N'으로 설정함.
	 * @param address
	 */
	void updateGibonAddress(Address address);
	
	/**
	 * no값을 이용해 주소테이블에서 no값에 해당하는 행을 삭제한다.
	 * @param no
	 */
	void deleteAddressByNo(String no);
	
	/**
	 * address객체를 통해 수정된 정보를 주소테이블에 반영한다.
	 * @param address
	 */
	void updateAddressByAddress(Address address);
}

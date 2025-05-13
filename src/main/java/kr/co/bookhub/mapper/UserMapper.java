package kr.co.bookhub.mapper;

import kr.co.bookhub.vo.User;

//User정보를 담은 Mapper
public interface UserMapper {
	
	/**
	 * 신규 사용자 정보를 전달받아서 테이블에 저장한다.
	 * @param user 신규 사용자 정보
	 */
	void insertUser(User user);
	
	/**
	 * 사용자 아이디를 전달받아서 해당 사용자정보를 반환한다.
	 * @param id 조회할 사용자 아이디
	 * @return 사용자 정보, 일치하는 사용자정보가 없으면 null이 반환된다.
	 */
	User getUserById(String id);
	
		
	/**
	 * 변경된 사용자정보를 전달받아서 테이블에 반영시킨다.
	 * @param user 변경된 사용자 정보
	 */
	void updateUser(User user);
	
	
	
	void deleteUser(String id);
		
}

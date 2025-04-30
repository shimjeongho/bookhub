package kr.co.bookhub.mapper;

import kr.co.bookhub.vo.Book;

public interface BookMapper {

	Book getBookByNo(int no);
	
	void updateBook(Book book);
}

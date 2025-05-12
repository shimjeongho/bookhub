package kr.co.bookhub.vo;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("Wishlist")
public class Wishlist {

	private Book book;
	private User user;
}

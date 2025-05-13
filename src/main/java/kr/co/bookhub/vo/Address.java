package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Alias("Address")
@Setter
@Getter
@NoArgsConstructor
public class Address {

	private int no;
	private String zipcode;
	private String basic;
	private String detail;
	private String gibon;
	private Date createdDate;
	private String name;
	private User user;
	
}

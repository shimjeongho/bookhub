package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("User")
@Data
public class User {
	String id;
	String password;
	String name;
	int zipcode;
	String address;
	String datail;
	String phone;
	Date birth;
	Date createdDate;
	Date updatedDate;
	String isDeleted;
}

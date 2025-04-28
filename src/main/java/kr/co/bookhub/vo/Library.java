package kr.co.bookhub.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("Library")
@Data
public class Library {
	
	int no;
	String name;
	String location;
	String longitude;
	String latitude;
	String tel;
	String imgPath;
	String businessHour;
	
}

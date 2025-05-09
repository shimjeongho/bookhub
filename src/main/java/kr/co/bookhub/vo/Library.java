package kr.co.bookhub.vo;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Setter
@Getter
@NoArgsConstructor
@Alias("Library")
public class Library {

	private int no;
	private String name;
	private String location;
	private String longitude;
	private String latitude;
	private String tel;
	private String imgPath;
	private String businessHours;
}

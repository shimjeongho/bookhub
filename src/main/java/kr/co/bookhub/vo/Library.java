package kr.co.bookhub.vo;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("Library")
public class Library {
	private int no; 
	private String name; 
	private String location;
	private String logitude; // 경도
	private String latitude; // 위도
	private String tel; // 도서관 전화번호
	private String imgPath; 
	private String businessHours;// 운영 시간
}

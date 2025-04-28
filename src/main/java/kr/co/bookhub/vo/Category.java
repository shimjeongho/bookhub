package kr.co.bookhub.vo;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("Category")
public class Category {

	int no;
	String name;
	int parentsNo;
}

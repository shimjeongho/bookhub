package kr.co.bookhub.vo;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("Category")
public class Category {
	private int no;
	private String name;
	private Category parents;
}

package kr.co.bookhub.vo;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("PostCategory")
public class PostCategory {
	private int no; // post_cate_no
	private String name; // post_cate_name
	
}

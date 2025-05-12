package kr.co.bookhub.vo;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Alias("Stock")
@Getter
@Setter
@NoArgsConstructor
public class Stock {
	private int libNo;
	private int bookNo;
	private int stock;
}

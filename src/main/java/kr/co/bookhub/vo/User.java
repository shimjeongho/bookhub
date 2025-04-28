package kr.co.bookhub.vo;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@Alias("User")
public class User {
	private String id; 
	private String password; 
	private String name; 
	private String phone; 
	private Date birth; 
	private Date createdDate; 
	private Date updatedDate; 
	private String isDeleted; 

}

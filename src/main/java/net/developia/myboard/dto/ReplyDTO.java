package net.developia.myboard.dto;

import java.util.Date;

import lombok.Data;

@Data
public class ReplyDTO {
	
	private Long rno;
	private Long no;
	
	private String reply;
	private String replyer;
	private Date replyDate;
	private Date updateDate;
}

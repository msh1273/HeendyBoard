package net.developia.myboard.dto;

import java.io.Serializable;
import java.util.List;

import lombok.Data;

@Data
public class BoardDTO implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private long no;
	private String title;
	private String name;
	private String content;
	private String regdate;
	private int readcount;
	private String password;
	private String boardName;
	
	private List<BoardAttachDTO> attachList;
	
}

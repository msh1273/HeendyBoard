package net.developia.myboard.dto;

import lombok.Data;

@Data
public class BoardAttachDTO {

	private String uuid;
	private String uploadPath;
	private String fileName;
	private boolean fileType;
	
	private long no;
}

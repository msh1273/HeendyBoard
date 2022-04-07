package net.developia.myboard.dao;

import java.util.List;

import net.developia.myboard.dto.BoardAttachDTO;

public interface BoardAttachDAO {
	
	public void register(BoardAttachDTO dto);
	/*
	 * public void delete(String uuid); public List<BoardAttachDTO> findByNo(Long
	 * no);
	 */

	public List<BoardAttachDTO> findByNo(Long no);
}

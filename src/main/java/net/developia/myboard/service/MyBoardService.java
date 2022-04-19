package net.developia.myboard.service;

import java.util.List;

import net.developia.myboard.dto.BoardAttachDTO;
import net.developia.myboard.dto.BoardDTO;

public interface MyBoardService {

	List<BoardDTO> getBoardList(String bt, long pg, String type, String keyword) throws Exception;

	long getBoardTotal(String bt, String type, String keyword) throws Exception;

	List<String> getAllBoardType() throws Exception;

	void insertBoard(BoardDTO boardDTO) throws Exception;

	void updateViews(long no) throws Exception;

	BoardDTO getDetail(long no) throws Exception;

	int updateBoard(BoardDTO boardDTO) throws Exception;

	void insertBoardType(String boardTypeName) throws Exception;

	int deleteBoard(BoardDTO boardDTO) throws Exception;

	public List<BoardAttachDTO> getAttachList(Long no) throws Exception;
}

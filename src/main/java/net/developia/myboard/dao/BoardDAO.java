package net.developia.myboard.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.developia.myboard.dto.BoardDTO;

public interface BoardDAO {

	List<BoardDTO> getBoardList(@Param("bt") String bt, @Param("startNum") long startNum, @Param("endNum")long endNum) throws Exception;

	long getBoardTotal(@Param("bt") String bt) throws Exception;

	List<String> getAllBoardType() throws Exception;

	void insertBoard(BoardDTO boardDTO) throws Exception;

	void updateViews(long no) throws Exception;

	BoardDTO getDetail(long no) throws Exception;

	int updateBoard(BoardDTO boardDTO)throws Exception;

	void insertBoardType(@Param("boardTypeName") String boardTypeName)throws Exception;

	int deleteBoard(BoardDTO boardDTO) throws Exception;
	
	

}

package net.developia.myboard.service;

import java.util.List;

import javax.management.RuntimeErrorException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.developia.myboard.dao.BoardAttachDAO;
import net.developia.myboard.dao.BoardDAO;
import net.developia.myboard.dto.BoardAttachDTO;
import net.developia.myboard.dto.BoardDTO;

@Log4j
@Service
public class MyBoardServiceImpl implements MyBoardService{

	@Setter(onMethod_ = @Autowired)
	private BoardDAO boardDAO;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachDAO boardAttachDAO;
	
	/*
	 * 
	 * public MyBoardServiceImpl(BoardDAO boardDAO) { this.boardDAO = boardDAO; }
	 */


	@Value("${pageSize}")
	private int pageSize;
	
	// 게시글 리스트 받아오기
	@Override
	public List<BoardDTO> getBoardList(String bt, long pg) throws Exception {
		long startNum = (pg-1)*pageSize + 1;
		long endNum = pg * pageSize;
		return boardDAO.getBoardList(bt, startNum, endNum);
	}

	@Override
	public long getBoardTotal(String bt) throws Exception {
		return boardDAO.getBoardTotal(bt);
	}

	@Override
	public List<String> getAllBoardType() throws Exception {
		return boardDAO.getAllBoardType();
	}

	@Transactional
	@Override
	public void insertBoard(BoardDTO boardDTO) throws Exception {
		log.info("insert!!!!" + boardDTO);
		
		boardDAO.insertBoard(boardDTO);
		
		if(boardDTO.getAttachList() == null || boardDTO.getAttachList().size() <= 0) {
			return;
		}
		boardDTO.getAttachList().forEach(attach ->{
			attach.setNo(boardDTO.getNo());
			boardAttachDAO.register(attach);
		});
	}

	@Override
	public void updateViews(long no) throws Exception {
		boardDAO.updateViews(no);
	}

	@Override
	public BoardDTO getDetail(long no) throws Exception {
		if(no == -1) {
			throw new RuntimeException("잘못된 접근입니다.");
		}
		BoardDTO boardDTO = boardDAO.getDetail(no);
		if(boardDTO == null) {
			throw new RuntimeException(no + "번 글이 존재하지 않습니다.");
		}
		return boardDTO;
	}

	@Override
	public void updateBoard(BoardDTO boardDTO) throws Exception {
		boardDAO.updateBoard(boardDTO);
	}

	@Override
	public void insertBoardType(String boardTypeName) throws Exception {
		boardDAO.insertBoardType(boardTypeName);
	}

	@Override
	public void deleteBoard(BoardDTO boardDTO) throws Exception {
		boardDAO.deleteBoard(boardDTO);
	}

	@Override
	public List<BoardAttachDTO> getAttachList(Long no) throws Exception {
		log.info("get Attach list by no" + no);
		return boardAttachDAO.findByNo(no);
	}

}

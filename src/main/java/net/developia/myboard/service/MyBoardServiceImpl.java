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
import net.developia.myboard.dao.ReplyDAO;
import net.developia.myboard.dto.BoardAttachDTO;
import net.developia.myboard.dto.BoardDTO;
import net.developia.myboard.dto.Criteria;


@Log4j
@Service
public class MyBoardServiceImpl implements MyBoardService{

	@Setter(onMethod_ = @Autowired)
	private BoardDAO boardDAO;
	
	@Setter(onMethod_ = @Autowired)
	private BoardAttachDAO boardAttachDAO;

	@Setter(onMethod_ = @Autowired)
	private ReplyDAO replyDAO;
	
	private Criteria cri = new Criteria();
	
	@Value("${pageSize}")
	private int pageSize;
	
	// 게시글 리스트 받아오기
	@Override
	public List<BoardDTO> getBoardList(String bt, long pg, String type, String keyword) throws Exception {
		long startNum = (pg-1)*pageSize + 1;
		long endNum = pg * pageSize;
		log.info("타입은!!!!" + type);
		String[] typeArr = {"T", "C", "W"};

		if(type != null) {
			typeArr = type.split("");			
		}
		if(keyword == null) {
			keyword = "";
		}
//		String[] typeArr = {"T", "C", "W"};
//		String keyword = "";
		return boardDAO.getBoardList(bt, pg, startNum, endNum, typeArr, keyword);
	}

	@Override
	public long getBoardTotal(String bt, String type, String keyword) throws Exception {
		String[] typeArr = {"T", "C", "W"};

		if(type != null) {
			typeArr = type.split("");			
		}
		if(keyword == null) {
			keyword = "";
		}
		return boardDAO.getBoardTotal(bt, typeArr, keyword);
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

	@Transactional
	@Override
	public int updateBoard(BoardDTO boardDTO) throws Exception {
		log.info("수정중." + boardDTO);
		
		boardAttachDAO.deleteAll(boardDTO.getNo());
		
		int n = boardDAO.updateBoard(boardDTO);
		
		if(n == 1 && boardDTO.getAttachList() != null &&
		boardDTO.getAttachList().size() > 0) {
		boardDTO.getAttachList().forEach(attach ->{ attach.setNo(boardDTO.getNo());
		boardAttachDAO.register(attach); }); }
		
		return n;
	}

	@Override
	public void insertBoardType(String boardTypeName) throws Exception {
		boardDAO.insertBoardType(boardTypeName);
	}

	//첨부파일 삭제와 실제 게시물 삭제가 같이 처리되기 위한 트랜잭션
	@Transactional
	@Override
	public int deleteBoard(BoardDTO boardDTO) throws Exception {
		log.info("삭제..." + boardDTO.getNo());
		//DB의 첨부파일부터 삭제
		boardAttachDAO.deleteAll(boardDTO.getNo());
		
		//게시글의 모든 댓글DB 삭제
		replyDAO.deleteAll(boardDTO.getNo());
		
		//이후 게시글 삭제
		int n = boardDAO.deleteBoard(boardDTO);
		return n;
	}

	@Override
	public List<BoardAttachDTO> getAttachList(Long no) throws Exception {
		log.info("get Attach list by no" + no);
		return boardAttachDAO.findByNo(no);
	}

}

package net.developia.myboard.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.developia.myboard.dao.ReplyDAO;
import net.developia.myboard.dto.ReplyDTO;


@Service
@Log4j
public class ReplyServiceImpl implements ReplyService {

	@Setter(onMethod_ = @Autowired)
	private ReplyDAO dao;
	
	@Override
	public int replyInsert(ReplyDTO dto) throws Exception {
		log.info("댓글 등록! " + dto);
		return dao.replyInsert(dto);
	}

	@Override
	public ReplyDTO get(Long rno) throws Exception {
		log.info("댓글 가져오기! " + rno);
		return dao.read(rno);
	}

	@Override
	public int remove(Long rno) throws Exception {
		log.info("댓글 삭제하기! " + rno);
		return dao.delete(rno);
	}

	@Override
	public int modify(ReplyDTO dto) throws Exception {
		log.info("댓글 수정하기! " + dto);
		return dao.update(dto);
	}

	@Override
	public List<ReplyDTO> getList(Long no) throws Exception {
		log.info("댓글 목록 가져오기! " + no);
		return dao.getListWithPaging(no);
	}

}

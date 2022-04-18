package net.developia.myboard.service;

import java.util.List;

import net.developia.myboard.dto.ReplyDTO;

public interface ReplyService {
	
	public int replyInsert(ReplyDTO dto) throws Exception;
	
	//특정 댓글 읽기
	public ReplyDTO get(Long rno) throws Exception;
	
	//특정 댓글 삭제
	public int remove(Long rno) throws Exception;
	
	//댓글 수정 시 댓글 내용과 최종 수정 시간 업데이트
	public int modify(ReplyDTO dto) throws Exception;
	
	//댓글 페이징 처리
	public List<ReplyDTO> getList(Long no) throws Exception;
}

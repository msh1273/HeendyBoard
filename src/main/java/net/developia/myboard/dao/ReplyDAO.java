package net.developia.myboard.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import net.developia.myboard.dto.Criteria;
import net.developia.myboard.dto.ReplyDTO;

public interface ReplyDAO {
	
	public int replyInsert(ReplyDTO dto) throws Exception;
	
	//특정 댓글 읽기
	public ReplyDTO read(Long rno) throws Exception;
	
	//특정 댓글 삭제
	public int delete(Long rno) throws Exception;
	
	//댓글 수정 시 댓글 내용과 최종 수정 시간 업데이트
	public int update(ReplyDTO dto) throws Exception;
	
	//댓글 페이징 처리
	public List<ReplyDTO> getListWithPaging(
			@Param("no") Long no) throws Exception;

	//모든 댓글 삭제
	public void deleteAll(long no) throws Exception;
}

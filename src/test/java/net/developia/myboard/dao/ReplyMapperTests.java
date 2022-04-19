package net.developia.myboard.dao;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.developia.myboard.dto.ReplyDTO;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class ReplyMapperTests {
	
	private Long[] noArr = {184L, 183L, 182L, 181L, 180L};
	
	@Setter(onMethod_ = @Autowired)
	private ReplyDAO dao;
	
	
	@Test
	public void testMapper() {
		log.info(dao);
	}
	
	@Test
	public void testCreate() {
		IntStream.rangeClosed(1, 10).forEach(i ->{
			ReplyDTO dto = new ReplyDTO();
			
			dto.setNo(noArr[i % 5]);
			dto.setReply("댓글 테스트중 " + i);
			dto.setReplyer("replyer" + i);
			try {
				dao.replyInsert(dto);
			} catch (Exception e) {
				e.printStackTrace();
			}
		});
	}
	
	@Test
	public void testRead() throws Exception{
		Long targetRno = 5L;
		
		ReplyDTO dto = dao.read(targetRno);
		
		log.info(dto);
	}
	
	@Test
	public void testDelete() throws Exception {
		Long targetRno = 1L;
		dao.delete(targetRno);
	}
	
	@Test
	public void testUpdate() throws Exception {
		Long targetRno = 10L;
		ReplyDTO dto = dao.read(targetRno);
		
		dto.setReply("수정된 댓글입니당.");
		
		int count = dao.update(dto);
		log.info("UPDATE COUNT : " + count);
	}
	
	@Test
	public void testList() throws Exception {
		List<ReplyDTO> replies = dao.getListWithPaging(noArr[0]);
		
		replies.forEach(reply -> log.info(reply));
	}
	

}

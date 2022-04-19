package net.developia.myboard.dao;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringRunner;

import lombok.Setter;
import lombok.extern.log4j.Log4j;
import net.developia.myboard.dto.BoardDTO;
import net.developia.myboard.dto.Criteria;

@RunWith(SpringRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardMapperTests {

	@Setter(onMethod_ = @Autowired)
	private BoardDAO dao;

	@Test
	public void testSearch() throws Exception {
//		Criteria cri = new Criteria();
//		cri.setKeyword("Test");
//		cri.setType("TC");
		
		String[] typeArr = {"T", "C"};
		String keyword = "Test";
		List<BoardDTO> list = dao.getBoardList("test",1L, 1, 10, typeArr, keyword);
		list.forEach(board -> log.info(board));
	}

}

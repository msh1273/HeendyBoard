package net.developia.myboard.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.log4j.Log4j;
import net.developia.myboard.dto.BoardDTO;
import net.developia.myboard.service.MyBoardService;

@Log4j
@Controller
@RequestMapping("board/{bt}/{pg}/{no}")
public class MyBoardDetailController {
	@Autowired
	private MyBoardService myBoardService;
	
	@GetMapping(value="/")
	public String detail(
			@PathVariable String bt,
			@PathVariable long no, 
			@PathVariable long pg, 
			@RequestParam long vn, 
			Model model
			) throws Exception{
		try {
			//상세보기 들어왔을 때 조회수 증가
			myBoardService.updateViews(no);
			//상세보기
			BoardDTO boardDTO = myBoardService.getDetail(no);
			System.out.println(boardDTO);
			model.addAttribute("boardDTO", boardDTO);
			model.addAttribute("vn", vn);
			return "detail";
		}catch (RuntimeException e) {
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url", "../");
			return "result";
		}catch(Exception e) {
			model.addAttribute("msg", "상세보기 에러");
			model.addAttribute("url", "../");
			return "result";
		}
		
	}
	
	@GetMapping(value="update")
	public String update(@PathVariable long no, Model model) {
		try {
			BoardDTO boardDTO = myBoardService.getDetail(no);
			model.addAttribute("boardDTO", boardDTO);
			return "update";
		}catch (Exception e) {
			model.addAttribute("msg", "업데이트 에러");
			model.addAttribute("url", "../../1/");
			return "result";
		}
	}
	
	@PostMapping(value="update")
	public String update(@ModelAttribute BoardDTO boardDTO, Model model) {
		try {
			myBoardService.updateBoard(boardDTO);
			model.addAttribute("msg", boardDTO.getNo() + "번 게시물이 수정되었습니다.");
			model.addAttribute("url", "../");
			return "result";
		}catch (Exception e) {
			model.addAttribute("msg", "입력에러");
			model.addAttribute("url", "javascript:history.back();");
			return "result";
		}
		
	}
	
	@GetMapping(value="delete")
	public String delete(@PathVariable long no, Model model) {
		return "delete";
	}
	@PostMapping(value="delete")
	public String delete(@ModelAttribute BoardDTO boardDTO, Model model) {
		try {
			myBoardService.deleteBoard(boardDTO);
			model.addAttribute("msg", boardDTO.getNo() + "번 게시물이 삭제되었습니다.");
			model.addAttribute("url", "../../1/");
			return "result";
		}catch (Exception e) {
			model.addAttribute("msg", e.getMessage());
			model.addAttribute("url", "javascript:history.back();");
			return "result";
		}
	}
}

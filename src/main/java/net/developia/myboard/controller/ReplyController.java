package net.developia.myboard.controller;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;
import net.developia.myboard.dto.ReplyDTO;
import net.developia.myboard.service.ReplyService;

@RequestMapping("board/{bt}/{pg}/{no}/replies")
@Log4j
@RestController
@AllArgsConstructor
public class ReplyController {
	
	private ReplyService service;
	
	@PostMapping(value = "/new", consumes = "application/json", produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> create(@RequestBody ReplyDTO dto) throws Exception{
		log.info("Reply DTO : " + dto);
		
		int insertCount = service.replyInsert(dto);
		
		log.info("댓글 삽입 카운트 : " + insertCount);
		
		return insertCount == 1 ? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	@GetMapping(value = "/pages/{no}", produces = {
			MediaType.APPLICATION_XML_VALUE,
			MediaType.APPLICATION_JSON_UTF8_VALUE
	})
	public ResponseEntity<List<ReplyDTO>> getList(@PathVariable("no") Long no) throws Exception{
		log.info("getList---------------");
		return new ResponseEntity<>(service.getList(no), HttpStatus.OK);
	}
	
	@GetMapping(value ="/{rno}", produces = {MediaType.APPLICATION_XML_VALUE, MediaType.APPLICATION_JSON_UTF8_VALUE}) 
	public ResponseEntity<ReplyDTO> get(@PathVariable("rno") Long rno) throws Exception{
		log.info("get : " + rno);
		return new ResponseEntity<ReplyDTO>(service.get(rno), HttpStatus.OK);
		
	}
	
	@DeleteMapping(value ="/{rno}", produces = {MediaType.TEXT_PLAIN_VALUE}) 
	public ResponseEntity<String> remove(@PathVariable("rno") Long rno) throws Exception{
		log.info("remove : " + rno);
		return service.remove(rno) == 1 ? new ResponseEntity<>("success", HttpStatus.OK) : new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
	
	//댓글 수정
	@RequestMapping(method = {RequestMethod.PUT, RequestMethod.PATCH},
			value = "/{rno}",
			consumes = "application/json",
			produces = {MediaType.TEXT_PLAIN_VALUE})
	public ResponseEntity<String> modify(@RequestBody ReplyDTO dto, @PathVariable("rno") Long rno) throws Exception{
		dto.setRno(rno);
		log.info("rno : " + rno);
		return service.modify(dto) == 1 ? new ResponseEntity<String>("success", HttpStatus.OK) : new ResponseEntity<String>(HttpStatus.INTERNAL_SERVER_ERROR);
	}
}

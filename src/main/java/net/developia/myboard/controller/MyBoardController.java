package net.developia.myboard.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import lombok.extern.log4j.Log4j;
import net.coobird.thumbnailator.Thumbnailator;
import net.developia.myboard.dto.BoardAttachDTO;
import net.developia.myboard.dto.BoardDTO;
import net.developia.myboard.service.MyBoardService;

@Log4j
@Controller
@RequestMapping("board/{bt}/{pg}")
public class MyBoardController {
	@Autowired
	private MyBoardService myBoardService;

	@Value("${pageSize}")
	private long pageSize;
	
	@Value("${blockSize}")
	private long blockSize;
	
	@Value("${uploadFolder}")
	private String uploadFolder;
	
	public MyBoardController(MyBoardService myBoardService) {
		this.myBoardService = myBoardService;
	}
	
	// 폴더 생성하기 위해 이름 지정하기
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	//이미지 타입인지 검사
	private boolean checkImageType(File file) {
		try {
			String contentType = Files.probeContentType(file.toPath());
			
			return contentType.startsWith("image");
		}catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
	
	@GetMapping("/")
	public String list(@PathVariable("bt") String bt, @PathVariable("pg") long pg, @RequestParam(value="type", required=false) String type, @RequestParam(value="keyword", required=false) String keyword, Model model)throws Exception{
		try {
			long totalCount = myBoardService.getBoardTotal(bt, type, keyword);
			//나타낼 총 페이지 수
			long pageCount = (long) Math.ceil((double)totalCount / pageSize);
			
			//현재 페이지에서 필요한 만큼만 리스트를 가져온다.
			List<BoardDTO> list = myBoardService.getBoardList(bt, pg, type, keyword);
			System.out.println("리스트 사이즈!" + list.size());
			long startPage = (pg-1) / blockSize * blockSize+1;
			long endPage = startPage + blockSize - 1;
			if (endPage > pageCount) {
				endPage = pageCount;
			}
			if(type != null && keyword != null) {
				model.addAttribute("type", type);
				model.addAttribute("keyword", keyword);
			}
			model.addAttribute("list", list);
			model.addAttribute("pageCount", pageCount);
			model.addAttribute("pg", pg);
			model.addAttribute("bt", bt);
			model.addAttribute("startPage", startPage);
			model.addAttribute("endPage", endPage);
			model.addAttribute("totalCount", totalCount);
			model.addAttribute("pageSize", pageSize);
			return "list";
		}catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	@PostMapping("addBoaradType")
	public String list(Model model, HttpServletRequest req)throws Exception {
		String boardTypeName = req.getParameter("boardTypeName");
		myBoardService.insertBoardType(boardTypeName);
		model.addAttribute("boardTypeName", boardTypeName);
		return "redirect:/";
	}
	
	@GetMapping("insert")
	public String insertBoard(@PathVariable("bt")String bt, @PathVariable("pg") long pg, Model model) throws Exception{
		List<String> btList = new ArrayList<>();
		btList = loadBoardType();
		model.addAttribute("btList", btList);
		model.addAttribute("bt");
		model.addAttribute("pg");
		return "insert";
	}
	//게시글 작성
	@PostMapping("insert")
	public String insertBoard(@ModelAttribute BoardDTO boardDTO, Model model, RedirectAttributes rttr)throws Exception {
		try {
			log.info("===============");
			log.info("register : " + boardDTO);
			if(boardDTO.getAttachList() != null) {
				boardDTO.getAttachList().forEach(attach -> log.info(attach));
			}
			log.info("=================");
			
			myBoardService.insertBoard(boardDTO);
			return "redirect:../1/";
		}catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
	}
	
	//헤더의 게시판 목록 불러오기
	@GetMapping(value = "loadBoardType")
	@ResponseBody
	public List<String> loadBoardType() throws Exception {
		List<String> list = new ArrayList<>();
		list = myBoardService.getAllBoardType();
		return list;

	}
	@PostMapping(value="/uploadAjaxAction", produces=MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachDTO>> uploadAjaxAction(MultipartFile[] uploadFile) {
		log.info("upload ajax post....");
		List<BoardAttachDTO> list = new ArrayList<>();
		
		File uploadPath = new File(uploadFolder, getFolder());
		log.info("upload path: " + uploadPath);
		
		String uploadFolderPath = getFolder();
		
		if(uploadPath.exists() == false) {
			uploadPath.mkdirs();
		}
		
		for(MultipartFile multipartFile: uploadFile) {
			BoardAttachDTO attachDTO = new BoardAttachDTO();
			
			log.info("--------------------");
			log.info("Ajax Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Ajax Upload File Size : " + multipartFile.getSize());
			
			String uploadFileName = multipartFile.getOriginalFilename();
			
			attachDTO.setFileName(uploadFileName);
			//IE에선 uploadFileName이 업로드된 서버의 경로까지 나온다.
			
			uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			log.info("only file name : " + uploadFileName);
			
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			//File saveFile = new File(uploadFolder, uploadFileName);
			try {
				File saveFile = new File(uploadPath, uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				attachDTO.setFileType(false);
				//이미지 타입인지 체크
				if(checkImageType(saveFile)) {
					attachDTO.setFileType(true);
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath, "s_" + uploadFileName));
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100, 100);
					thumbnail.close();
				}
				
				list.add(attachDTO);
				
			}catch (Exception e) {
				log.error(e.getMessage());
			}
			
		}
		return new ResponseEntity<>(list, HttpStatus.OK);
	}
	
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		log.info("upload Ajax");
	}
	
	@GetMapping("/display")
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName){
		log.info("display fileName : " + fileName);
		
		File file = new File("c:\\upload\\" + fileName);
		log.info("display file: " + file);
		
		ResponseEntity<byte[]> result = null;
		
		try {
			HttpHeaders header = new HttpHeaders();
			header.add("Content-Type", Files.probeContentType(file.toPath()));
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);
		}catch (IOException e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@PostMapping("deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		log.info("deleteFile: " + fileName);
		
		File file;
		
		try {
			file = new File("c:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			file.delete();
			
			if(type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_", "");
				log.info("largeFileName : " + largeFileName);
				
				file = new File(largeFileName);
				
				file.delete();
			}
		}catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<String>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("deleted", HttpStatus.OK);
	}
	
	@GetMapping(value ="getAttachList", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachDTO>> getAttachList(Long no)throws Exception{
		log.info("getAttachList Controller : " + no);
		return new ResponseEntity<List<BoardAttachDTO>>(myBoardService.getAttachList(no), HttpStatus.OK);
	}
	
	//첨부 파일 다운로드
	@GetMapping(value = "/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		log.info("download file: " + fileName);
		
		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
		log.info("resource : " + resource);
		
		if(resource.exists() == false) {
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
		}
		
		String resourceName = resource.getFilename();
		
		// UUID 제거하기
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);
		
		HttpHeaders headers = new HttpHeaders();
		try {
			String downloadName = null;
			
			if(userAgent.contains("Trident")) {
				log.info("IE browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8").replaceAll("\\+", " ");
			}else if(userAgent.contains("Edge")){
				log.info("Edge browser");
				downloadName = URLEncoder.encode(resourceOriginalName, "UTF-8");
				log.info("Edge name: " + downloadName);
			}else {
				log.info("Chrome browser");
				downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
				
			}
			log.info(downloadName);
			
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);
		}catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource,headers, HttpStatus.OK);
		
	}
}

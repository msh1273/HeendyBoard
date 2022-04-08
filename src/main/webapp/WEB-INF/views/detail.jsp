<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="includes/header.jsp"%>
<script>
	$(function() {
		$(".bigPictureWrapper").on("click", function(e){
			$(".bigPicture").animate({width:'0%', height: '0%'}, 1000);
			setTimeout(() => {
				$(this).hide();
			}, 1000);
		});	
		$(".uploadResult").on("click", "li", function(e){
			console.log("view image");
			var liObj = $(this);
			console.log(liObj);
			var path = encodeURIComponent(liObj.data("path")+ "/" + liObj.data("uuid")+ "_" + liObj.data("filename"));

			if(liObj.data("type")){
				showImage(path.replace(new RegExp(/\\/g), "/"));
			}else{
				self.location = "${contextPath}/board/${bt}/${pg}/download?fileName="+path
			}
		});
		function showImage(fileCallPath){
			$(".bigPictureWrapper").css("display", "flex").show();

			$(".bigPicture").html("<img src='${contextPath}/board/${bt}/${pg}/display?fileName=" + fileCallPath + "'>").animate({width: '100%', height: '100%'}, 1000);
		}
		var no = '<c:out value="${boardDTO.no}"/>';

		$.getJSON("${contextPath}/board/${bt}/${pg}/getAttachList", {no : no}, function(arr) {
			console.log(arr);
			var str = "";
			
			$(arr).each(function(i, attach){
				//이미지인 경우
				if(attach.fileType){
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);

					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType+"' ><div>";
					str += "<img src='${contextPath}/board/${bt}/${pg}/display?fileName=" + fileCallPath + "'>";
					str += "</div>";
					str += "</li>";
				}else{
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" +attach.fileName + "' data-type='" + attach.fileType +"' ><div>";
					str += "<span> " + attach.fileName + "</span><br/>";
					str += "<img src='${contextPath}/resources/img/attach.png'>";
					str += "</div>";
					str += "</li>";
				}
			});
			$(".uploadResult ul").html(str);
		});
	});
</script>

<div class='bigPictureWrapper'>
	<div class='bigPicture'></div>
</div>
<style>
.uploadResult {
	width: 100%;
	background-color: gray;
}

.uploadResult ul {
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul il {
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
}

.uploadResult ul li img {
	width: 100px;
}

.uploadResult ul li span {
	color: white;
}

.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rgba(255, 255, 255, 0.5);
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.bigPicture img {
	width: 600px;
}
</style>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시물 상세보기</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시물 상세보기</div>
			<div class="panel-body">
				<div class="form-group">
					<label>현재 게시판</label> <input class="form-control" readonly
						value=${boardDTO.boardName }>
				</div>
				<div class="form-group">
					<label>글번호 </label> <input class="form-control" readonly
						value=${vn }>
				</div>
				<div class="form-group">
					<label>글제목 </label> <input class="form-control" readonly
						value=${boardDTO.title }>
				</div>
				<div class="form-group">
					<label>작성자</label> <input class="form-control" readonly
						value=${boardDTO.name }>
				</div>
				<div class="form-group">
					<label>내용</label>
					<textarea class="form-control" rows="3" readonly>${boardDTO.content }</textarea>
				</div>
				<div class="form-group">
					<label>작성일</label> <input class="form-control" readonly
						value=${boardDTO.regdate }>
				</div>
				<div class="form-group">
					<label>조회수</label> <input class="form-control" readonly
						value=${boardDTO.readcount }>
				</div>
				<!-- form-group -->
			</div>
			<!-- panel-body -->
		</div>
		<!-- panel heading -->
	</div>
</div>

<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">첨부 파일</div>
			<div class="panel-body">
				<div class='uploadResult'>
					<ul>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
<div class="pull-right">
<button class="btn" onclick="location.href='${contextPath }/board/${bt}/${pg}/'">리스트로 돌아가기</button>
<button class="btn" onclick="location.href='update'">수정하기</button>
<button class="btn" onclick="location.href='delete'">삭제하기</button>
</div>

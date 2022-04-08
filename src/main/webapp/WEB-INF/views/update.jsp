<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="includes/header.jsp"%>

<script>
	$(function(){
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5242880;
		var formObj = $("form[role='form']");
		
		function showUploadResult(uploadResultArr) {
			if (!uploadResultArr || uploadResultArr.length == 0) {
				return;

			}
			var uploadURL = $(".uploadResult ul");

			var str = "";
			$(uploadResultArr)
					.each(
							function(i, obj) {
								if (obj.fileType) {
									var fileCallPath = encodeURIComponent(obj.uploadPath
											+ "/s_"
											+ obj.uuid
											+ "_"
											+ obj.fileName);

									/* var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
									originPath = originPath.replace(new RegExp(/\\/g), "/"); */

									str += "<li data-path='"+obj.uploadPath+"'";
									str += " data-uuid='" + obj.uuid + "' data-filename='"+obj.fileName + "' data-type='" + obj.fileType + "'"
									str += " ><div>";
									str += "<span> "
											+ obj.fileName
											+ "</span>";
									str += "<button type='button' data-file=\'" + fileCallPath + "\'data-type='image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
									str += "<img src='${contextPath }/board/${bt }/${pg }/display?fileName="
											+ fileCallPath
											+ "'>";
									str += "</div>";
									str += "</li>";
								} else {
									var fileCallPath = encodeURIComponent(obj.uploadPath
											+ "/"
											+ obj.uuid
											+ "_"
											+ obj.fileName);
									var fileLink = fileCallPath.replace(new RegExp(/\\/g),"/");

									str += "<li data-path='"+ obj.uploadPath +"' data-uuid='"+ obj.uuid+"' data-filename='"+obj.fileName + "' data-type='"+obj.fileType + "' ><div>";
									str += "<span> "+ obj.fileName + "</span>";
									str += "<button type='button' data-file=\'" + fileCallPath + "\'data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
									str += "<img src='${contextPath}/resources/img/attach.png'></a>";
									str += "</div>";
									str += "</li>";
								}
							});
			uploadURL.append(str);
		}
		function checkExtension(fileName, fileSize) {
			if (fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
			if (regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			return true;
		}
		$("input[type='file']").change(function(e) {
					var formData = new FormData();
					var inputFile = $("input[name='uploadFile']");
					var files = inputFile[0].files;

					console.log("파일:  " + files);
					for (var i = 0; i < files.length; i++) {
						if (!checkExtension(
								files[i].name,
								files[i].size)) {
							return false
						}
						formData.append("uploadFile",
								files[i]);
					}
					$.ajax({
						url : 'uploadAjaxAction',
						processData : false,
						contentType : false,
						data : formData,
						type : 'POST',
						dataType : 'json',
						success : function(result) {
							console.log(result);
							showUploadResult(result);
							//$(".uploadDiv").html(cloneObj.html());
						}
					});
				});
		$("button[type='submit']").on("click", function(e) {
			e.preventDefault();
			console.log("submit Clicked!");
			var operation = $(this).data("oper");
			console.log(operation);
				console.log("submit clicked");
				var str="";
				$(".uploadResult ul li").each(function(i, obj){
					var jobj = $(obj);
					console.log("수정!! jobj")
					console.dir(jobj);
					
					str += "<input type='hidden' name='attachList["+i+"].fileName' value='" + jobj.data("filename") + "'>";
					str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid") + "'>";
					str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path") + "'>";
					str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type") + "'>";
				});
			formObj.append(str).submit();
		});
		$(".uploadResult").on("click", "button", function(e) {
			console.log("delete file");
			
			if(confirm("첨부파일을 삭제하시겠습니까? ")){
				var targetLi = $(this).closest("li");
				targetLi.remove();
			}
		});
		var no = '<c:out value="${boardDTO.no}"/>';

		$.getJSON("${contextPath}/board/${bt}/${pg}/getAttachList", {no : no}, function(arr) {
			console.log(arr);
			var str = "";
			
			$(arr).each(function(i, attach){
				//이미지인 경우
				if(attach.fileType){
					var fileCallPath = encodeURIComponent(attach.uploadPath + "/s_" + attach.uuid + "_" + attach.fileName);

					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" + attach.fileName + "' data-type='" + attach.fileType+"' ><div>";
					str += "<span> " + attach.fileName + "</span>";
					str += "<button type='button' data-file=\'" + fileCallPath + "\'data-type= 'image' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
					str += "<img src='${contextPath}/board/${bt}/${pg}/display?fileName=" + fileCallPath + "'>";
					str += "</div>";
					str += "</li>";
				}else{
					str += "<li data-path='" + attach.uploadPath + "' data-uuid='" + attach.uuid + "' data-filename='" +attach.fileName + "' data-type='" + attach.fileType +"' ><div>";
					str += "<span> " + attach.fileName + "</span><br/>";
					str += "<button type='button' data-file=\'" + fileCallPath + "\'data-type='file' class='btn btn-warning btn-circle'><i class='fa fa-times'></i></button><br>";
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

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시물 수정하기</h1>
	</div>
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
		<div class="panel panel-default">
			<div class="panel-heading">게시물 수정하기</div>
			<div class="panel-body">
				<form role="form" method="post">
					<div class="form-group">
						<label>글제목 </label> <input class="form-control" name='title' required="required"
							value=${boardDTO.title }>
					</div>
					<div class="form-group">
						<label>작성자</label> <input class="form-control" name='name' required="required"
							value=${boardDTO.name }>
					</div>
					<div class="form-group">
						<label>비밀번호</label><input class="form-control" name='password'
							required="required">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" name='content' rows="3" required="required">${boardDTO.content }</textarea>
					</div>
					<div class="form-group">
						<label>작성일</label> <input class="form-control" readonly name='regdate'
							value=${boardDTO.regdate }>
					</div>
					<div class="form-group">
						<label>조회수</label> <input class="form-control" readonly name='readcount'
							value=${boardDTO.readcount }>
					</div>
					<div class="form-group">
						<label>현재 게시판</label> <input class="form-control" readonly name='boardName'
							value=${boardDTO.boardName }>
					</div>
					<button type="submit" class="btn btn-default pull-right">등록하기</button>
				</form>
			</div>
		</div>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">첨부 파일</div>
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name='uploadFile' multiple="multiple">
				</div>
				<div class='uploadResult'>
					<ul>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
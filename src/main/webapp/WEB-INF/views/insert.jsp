<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="includes/header.jsp"%>

<script>

	$(document)
			.ready(
					function(e) {
						
						$(".uploadResult").on("click", "button", function(e) {
							console.log("delete file");
							
							var targetFile = $(this).data("file");
							var type = $(this).data("type");

							var targetLi = $(this).closest("li");
							
							$.ajax({
								url : 'deleteFile',
								data : {
									fileName : targetFile,
									type : type
								},
								dataType : "text",
								type : "POST",
								success : function(response) {
									alert(response);
									targetLi.remove();
								}
							});
						});
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
						$("input[type='file']")
								.change(
										function(e) {
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
							var str="";
							$(".uploadResult ul li").each(function(i, obj){
								var jobj = $(obj);
								console.dir(jobj);
								
								str += "<input type='hidden' name='attachList["+i+"].fileName' value='" + jobj.data("filename") + "'>";
								str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid") + "'>";
								str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path") + "'>";
								str += "<input type='hidden' name='attachList["+i+"].fileType' value='"+jobj.data("type") + "'>";
							});
						formObj.append(str).submit();
						});
					});
</script>
<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">Board Register</h1>
	</div>
</div>
<div class="row">
	<div class="col-lg-12">
		<div class="panel panel-default">
			<div class="panel-heading">게시물 등록</div>
			<div class="panel-body">
				<form role="form" method="post">
					<div class="form-group">
						<label>게시판 분류</label> <select class="form-select"
							aria-label="Default select example" name='boardName'>
							<c:forEach var="list" items="${btList}">
								<option value="${list }">${list}</option>
							</c:forEach>
						</select>
					</div>
					<div class="form-group">
						<label>글제목</label><input class="form-control" name='title'
							required="required">
					</div>
					<div class="form-group">
						<label>작성자</label><input class="form-control" name='name'
							required="required">
					</div>
					<div class="form-group">
						<label>비밀번호</label><input class="form-control" name='password'
							required="required">
					</div>
					<div class="form-group">
						<label>내용</label>
						<textarea class="form-control" rows="3" name='content'
							required="required"></textarea>
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
			<div class="panel-heading">File Attach</div>
			<div class="panel-body">
				<div class="form-group uploadDiv">
					<input type="file" name='uploadFile' multiple>
				</div>

				<div class='uploadResult'>
					<ul>

					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
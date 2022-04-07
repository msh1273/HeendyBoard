<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="includes/header.jsp"%>
<script>
$(function(){
		var no = '<c:out value="${boardDTO.no}"/>';
		
		$.getJSON("${contextPath}/board/${bt}/${pg}/getAttachList", {no: no},
			function (arr) {
				console.log(arr);
			});
	});
</script>

<div class='bigPictureWrapper'>
	<div class='bigPicture'>
	</div>
</div>
<style>
.uploadResult{
	width: 100%;
	background-color: gray;
}

.uploadResult ul{
	display: flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul il{
	list-style: none;
	padding: 10px;
	align-content: center;
	text-align: center;
}

.uploadResult ul li img{
	width: 20px;
}

.uploadResult ul li span{
	color: white;
}

.bigPictureWrapper{
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: gray;
	z-index: 100;
	background: rgba(255,255,255,0.5);
}

.bigPicture{
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.bigPicture img{
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

			</div>
		</div>
	</div>
</div>
<a href="${contextPath }/board/${bt}/${pg}/">리스트</a>
<a href="update">수정</a>
<a href="delete">삭제</a>
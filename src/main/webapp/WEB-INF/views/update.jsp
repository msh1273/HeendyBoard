<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<%@ include file="includes/header.jsp"%>

<div class="row">
	<div class="col-lg-12">
		<h1 class="page-header">게시물 수정하기</h1>
	</div>
</div>
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
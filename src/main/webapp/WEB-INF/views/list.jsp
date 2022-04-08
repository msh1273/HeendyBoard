<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<jsp:useBean id="now" class="java.util.Date" />
<fmt:formatDate value="${now }" pattern="YYYY/MM/dd" var="today" />

<%@ include file="includes/header.jsp"%>
<script>
	$(function(){
		var path = window.location.pathname;
		var rp = path + "loadBoardType";
		console.log(rp);
		$.ajax({
      url: rp,
      type: "GET",
      dataType:'json',
      success: function (response) {
    	  $.each(response, function(i, value){
		       $(".nav-pills").append($("<li class='nav-item'><a href='../../" + value + "/1/' aria-current='page'>" + value + "</a></li>"));   
    	  });
      }
    });
	})
</script>
<div class="container">
    <header class="d-flex justify-content-center py-3">
      <ul class="nav nav-pills">

      </ul>
      <form action="${contextPath }/board/${bt }/${pg }/addBoaradType" method="post">
        <input name='boardTypeName' required="required">
        <button type="submit" class="btn btn-default">게시판 만들기</button>      
      </form>
    </header>
  </div>

<table class="table table-striped">
	<tr>
		<td colspan="5">현재 페이지: ${pg }page / ${pageCount}page</td>
	</tr>

	<tr>
		<th>번호</th>
		<th>제목</th>
		<th>작성자</th>
		<th>작성일</th>
		<th>조회수</th>
	</tr>
	<c:forEach items="${list}" var="dto" varStatus="vs">
		<tr>
			<th>${totalCount- vs.index - ((pg-1)*pageSize) }</th>
			<th><a
				href="${dto.no}/?vn=${totalCount-vs.index - ((pg-1)*pageSize)}">${dto.title}</a></th>
			<th>${dto.name}</th>
			<c:if test="${fn:split(dto.regdate,' ')[0] == today}">
				<th>${fn:split(dto.regdate,' ')[1]}</th>
			</c:if>
			<c:if test="${fn:split(dto.regdate,' ')[0] != today}">
				<th>${fn:split(dto.regdate,' ')[0]}</th>
			</c:if>
			<th>${dto.readcount}</th>
		</tr>
	</c:forEach>
</table>

<div class="text-center">
	<ul class="pagination">
		<c:if test="${startPage != 1}">
			<li class="page-item"><a class="page-link"
				href="${contextPath}/board/${bt}/${startPage-1}/">이전블럭</a></li>
		</c:if>
		<c:forEach begin="${startPage}" end="${endPage}" var="p">
			<c:if test="${p == pg}">
				<li class="page-item active"><a class="page-link">${p }</a></li>
			</c:if>
			<c:if test="${p != pg}">
				<li class="page-item"><a href="${contextPath }/board/${bt}/${p }/">${p }</a></li>
			</c:if>
		</c:forEach>
		<c:if test="${endPage != pageCount }">
			<li><a href="${contextPath }/board/${bt}/${endPage+1}/">다음블럭</a></li>
		</c:if>
	</ul>
</div>
<a class="btn btn-default pull-right" href="insert">글쓰기 </a>
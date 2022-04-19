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
		/* function actionForm(){
			console.log("페이지 버튼 클릭!")
			document.getElementById('actionForm').submit();
		} */
		var searchForm = $("#searchForm");
		$("#searchForm button").on("click", function(e){
			if(!searchForm.find("option:selected").val()){
				alert("검색종류를 선택하세요");
				return false;
			}
			if(!searchForm.find("input[name='keyword']").val()){
				alert("키워드를 입력하세요");
				return false;
			}
			//searchForm.find("input[name='pg']").val();
			e.preventDefault();
			console.log("전송됨");
			searchForm.submit();
		});
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
    </header>
  </div>

<table class="table table-striped">
	<tr>
		<td colspan="5">현재 페이지: ${pg }page / ${pageCount}page       
		<form class="pull-right" action="${contextPath }/board/${bt }/${pg }/addBoaradType" method="post">
        <input name='boardTypeName' required="required">
        <button type="submit" class="btn btn-default">게시판 만들기</button>      
      	</form>
      </td>
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
<div class='row'>
	<div class="col-lg-12">
		<form id='searchForm' action="${pageCount}/../../1/" method='get'>
			<select name='type'>
				<option value="" <c:out value="${type == null ? 'selected':''}"/>>--</option>
					<option value="T" <c:out value="${type eq 'T' ? 'selected':'' }"/>>제목</option>
					<option value="C" <c:out value="${type eq 'C' ? 'selected':'' }"/>>내용</option>
					<option value="W" <c:out value="${type eq 'W' ? 'selected':'' }"/>>작성자</option>
					<option value="TC" <c:out value="${type eq 'TC' ? 'selected':'' }"/>>제목 or 내용</option>
					<option value="TW" <c:out value="${type eq 'TW' ? 'selected':'' }"/>>제목 or 작성자</option>
					<option value="TCW" <c:out value="${type eq 'TCW' ? 'selected':'' }"/>>제목 or 내용 or 작성자</option>
			</select>
			<input type="text"name='keyword' value='<c:out value="${keyword}"/>'/>
			<input type='hidden' name='pg' value='${pg}'>
			<button class='btn btn-default'>Search</button>
		</form>
	</div>
</div>
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
				<li class="page-item"><a href="${contextPath }/board/${bt}/${p }/?type=${type}&keyword=${keyword}">${p }</a></li>
			</c:if>
		</c:forEach>
		<c:if test="${endPage != pageCount }">
			<li><a href="${contextPath }/board/${bt}/${endPage+1}/">다음블럭</a></li>
		</c:if>
	</ul>
</div>

<form id='actionForm' action="${contextPath }/../" method='get'>
	<input type='hidden' name='pg' value='${pg}'>
	<input type='hidden' name='type' value='<c:out value="${type}"/>'/>
	<input type='hidden' name='keyword' value='<c:out value="${keyword}"/>'/>
</form>

<a class="btn btn-default pull-right" href="insert">글쓰기 </a>